//
//  XCFolder.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/27.
//

import PathKit
import ArgumentParser
import Foundation

@main
public struct XCFolder: AsyncParsableCommand {

    @Argument(help: "Your .xcodeproj file path")
    var xcodeProjFilePath: String?
    
    @Argument(help: "Configuration YAML file path")
    var configurationFilePath: String?
    
    var isTerminalMode: Bool = false
    
    public init(xcodeProjFilePath: String? = nil, configurationFilePath: String? = nil) {
        self.xcodeProjFilePath = xcodeProjFilePath
        self.configurationFilePath = configurationFilePath
    }
    
    public init() {
        
    }
    
    enum CodingKeys: CodingKey {
        case xcodeProjFilePath
        case configurationFilePath
    }
    
    private lazy var fileRepository: FileRepositorySpec = FileRepository()
    private lazy var gitRepository: GitRepository = GitRepository()
    private lazy var configurationRepository: ConfigurationRepositorySpec = ConfigurationRepository()
    private lazy var logger: Logger = Logger()
    public mutating func run() async throws {
        self.isTerminalMode = true
        
        let xcodeProjFilePath = await askXcodeProjFilePath(defaultPathString: self.xcodeProjFilePath)
        let configuration = await askConfigurationFromYAML(defaultPathString: self.configurationFilePath) ?? Configuration()
    
        let xcodeProjRepository = try XcodeProjRepository(path: xcodeProjFilePath)
        let groupToFolderUseCase = GroupToFolderUseCase(projectRootPath: xcodeProjFilePath.parent(), configuration: configuration, xcodeProjRepository: xcodeProjRepository, fileRepository: fileRepository, logger: logger)
        
        groupToFolderUseCase.execute()
        
        if self.isTerminalMode {
            let thanksUseCase = ThanksUseCase()
            await thanksUseCase.execute()
        }
    }
}

private extension XCFolder {
    mutating func askXcodeProjFilePath(defaultPathString: String?) async -> Path {
        do {
            let xcodeProjFilePathString: String
            if let defaultPathString = defaultPathString {
                xcodeProjFilePathString = defaultPathString.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                print("Please enter your .xcodeproj file path: ", terminator: " ")
                xcodeProjFilePathString = await Helper.readAsyncInput()
            }
            
            let safeCheckUseCase = SafeCheckUseCase(projectPath: xcodeProjFilePathString, gitRepository: gitRepository, fileRepository: fileRepository)
            try await safeCheckUseCase.execute()
            return Path(URL(fileURLWithPath: xcodeProjFilePathString).standardizedFileURL.path())
        } catch {
            logger.log(message: "❌ Error: \(error)")
            return await askXcodeProjFilePath(defaultPathString: nil)
        }
    }
    
    mutating func askConfigurationFromYAML(defaultPathString: String?) async -> Configuration? {
        do {
            print("Please enter your Configuration YAML file path: [Empty to use default]")
            let configurationPathString: String
            if let defaultPathString = defaultPathString {
                configurationPathString = defaultPathString.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                configurationPathString = await Helper.readAsyncInput()
            }
            
            guard configurationPathString != "" else {
                return nil
            }
            
            guard let url = URL(string: configurationPathString),
                      url.pathExtension.lowercased() == "yaml",
                      fileRepository.exists(at: Path(url.standardizedFileURL.relativeString)) else {
                throw SafeCheckUseCaseError.invalidPath
            }
            
            let configurationPath = Path(configurationPathString)
            let result = configurationRepository.fetch(path: configurationPath)
            switch result {
            case .success(let configuration):
                return configuration
            case .failure(let error):
                throw error
            }
        } catch {
            logger.log(message: "⚠️ Failed to load configuration: \(error)")
            return await askConfigurationFromYAML(defaultPathString: nil)
        }
    }
}
