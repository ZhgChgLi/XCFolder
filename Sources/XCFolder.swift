//
//  XCFolder.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/27.
//

import PathKit
import ArgumentParser
import Foundation
import AppKit

@main
struct XCFolder: AsyncParsableCommand {

    @Argument(help: "Your .xcodeproj file path")
    var xcodeProjFilePath: String?
    
    @Argument(help: "Configuration YAML file path")
    var configurationFilePath: String?

    @Flag(name: .long, help: "Set Non-interactive mode")
    var isNonInteractiveMode: Bool = false
    
    @Flag(name: .long, help: "Skip git safety check for uncommitted changes")
    var skipSafetyCheck: Bool = false
    
    enum CodingKeys: CodingKey {
        case xcodeProjFilePath
        case configurationFilePath
        case isNonInteractiveMode
        case skipSafetyCheck
    }
    
    private lazy var fileRepository: FileRepositorySpec = FileRepository()
    private lazy var configurationRepository: ConfigurationRepositorySpec = ConfigurationRepository()
    private lazy var logger: Logger = Logger()
    private var gitRepository: GitRepositorySpec?
    mutating func run() async throws {
        
        let xcodeProjFilePath = try await askXcodeProjFilePath(defaultPathString: self.xcodeProjFilePath)
        let configuration = await askConfigurationFromYAML(defaultPathString: self.configurationFilePath)
        
        do {
            let fileURL = URL(fileURLWithPath: xcodeProjFilePath.string)
            let gitRepository = try await GitRepository(path: fileURL, logger: self.logger)
            self.gitRepository = gitRepository
        } catch {
            logger.log(message: "❌ Not found valid git, will use filesystem instead: \(error)")
        }
        
        if !skipSafetyCheck {
            try await askSafeCheck(xcodeProjFilePath: xcodeProjFilePath)
        }
        
        let xcodeProjRepository = try XcodeProjRepository(path: xcodeProjFilePath)
        let groupToFolderUseCase = GroupToFolderUseCase(projectRootPath: xcodeProjFilePath.parent(), configuration: configuration, xcodeProjRepository: xcodeProjRepository, fileRepository: fileRepository, gitRepository: self.gitRepository, logger: logger)
        
        await groupToFolderUseCase.execute()
        
        let thanksUseCase = ThanksUseCase()
        await thanksUseCase.execute()
        
        if !isNonInteractiveMode {
            await promoptVisitMyBlog()
        }
    }
}

private extension XCFolder {
    mutating func askXcodeProjFilePath(defaultPathString: String?) async throws -> Path {
        let xcodeProjFilePathString: String
        if let defaultPathString = defaultPathString {
            xcodeProjFilePathString = defaultPathString.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            print("Please enter your .xcodeproj file path: ", terminator: " ")
            xcodeProjFilePathString = await Helper.readAsyncInput()
        }
        
        do {
            let fileURL = URL(fileURLWithPath: xcodeProjFilePathString).standardizedFileURL
            guard fileURL.pathExtension.lowercased() == "xcodeproj",
                  fileRepository.exists(at: Path(fileURL.path)) else {
                throw SafeCheckUseCaseError.invalidPath
            }
            
            return Path(fileURL.path)
        } catch {
            if !isNonInteractiveMode {
                logger.log(message: "⚠️ \(error)")
                return try await askXcodeProjFilePath(defaultPathString: nil)
            } else {
                throw error
            }
        }
    }
    
    mutating func askConfigurationFromYAML(defaultPathString: String?) async -> Configuration {
        if let defaultPathString = defaultPathString {
            do {
                let fileURL = URL(fileURLWithPath: defaultPathString).standardizedFileURL
                guard fileURL.pathExtension.lowercased() == "yaml" || fileURL.pathExtension.lowercased() == "yml",
                          fileRepository.exists(at: Path(fileURL.path)) else {
                    throw SafeCheckUseCaseError.invalidPath
                }
                
                let configurationPath = Path(defaultPathString)
                let result = configurationRepository.fetch(path: configurationPath)
                switch result {
                case .success(let configuration):
                    return configuration
                case .failure(let error):
                    throw error
                }
            } catch {
                logger.log(message: "⚠️ The provided Configuration.yaml is not valid. Using the default configuration instead, error: \(error)")
                if !isNonInteractiveMode {
                    return await askConfigurationFromYAML(defaultPathString: nil)
                } else {
                    return Configuration()
                }
            }
        } else {
            // doesn't provide default path
            if !isNonInteractiveMode {
                print("Please enter the path to your Configuration YAML file [Leave empty to use the default]: ")
                let configurationPathString = await Helper.readAsyncInput()
                if configurationPathString != "" {
                    return await askConfigurationFromYAML(defaultPathString: configurationPathString)
                } else {
                    return Configuration()
                }
            } else {
                logger.log(message: "⚠️ Doesn't provide Configuration.yaml path, use default configuration instead")
                return Configuration()
            }
        }
    }
    
    mutating func askSafeCheck(xcodeProjFilePath: Path) async throws {
        guard let gitRepository = self.gitRepository else {
            return
        }
        
        do {
            let safeCheckUseCase = SafeCheckUseCase(projectPath: xcodeProjFilePath.string, gitRepository: gitRepository, fileRepository: fileRepository)
            try await safeCheckUseCase.execute()
        } catch {
            if !isNonInteractiveMode {
                logger.log(message: "⚠️ \(error)")
                print("Please [enter] to continue...")
                _ = await Helper.readAsyncInput()
                return try await askSafeCheck(xcodeProjFilePath: xcodeProjFilePath)
            } else {
                throw error
            }
        }
    }
    
    mutating func promoptVisitMyBlog() async {
        print("Press [Enter] to visit my post at zhgchg.li...")
        let _ = await Helper.readAsyncInput()
        
        guard let url = URL(string: "https://zhgchg.li/posts/en/fd719053b376/"),
            NSWorkspace.shared.open(url) else {
            return
        }
    }
}
