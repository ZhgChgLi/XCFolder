//
//  ProcessService.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/27.
//

import Foundation

final class ProcessService: ProcessServiceSpec {
    
    enum ShellType: String {
        case bash = "/bin/bash"
    }
    
    private let shellType: ShellType
    
    init (shellType: ShellType = .bash) {
        self.shellType = shellType
    }
    
    func run(currentDirectory: URL? = nil, command: String, arguments: [String] = []) async -> Result<String, ProcessServiceError> {
        let process = Process()
        process.currentDirectoryURL = currentDirectory
        process.launchPath = shellType.rawValue
        let fullCommand = ([command] + arguments).joined(separator: " ")
        process.arguments = ["-c", fullCommand]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            if !errorData.isEmpty,
               let errorString = String(data: errorData, encoding: .utf8),
               !errorString.isEmpty {
                return .failure(ProcessServiceError.commandFailed(.init(string: errorString)))
            }
                
                
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            guard let outputString = String(data: outputData, encoding: .utf8) else {
                return .failure(ProcessServiceError.outputDecodeFailed(outputData))
            }
            return .success(outputString.trimmingCharacters(in: .whitespacesAndNewlines))
        } catch {
            return .failure(ProcessServiceError.processFailed(error))
        }
    }
}
