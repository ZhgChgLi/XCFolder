//
//  GitVersionControlSystemRepository.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/27.
//

import Foundation
import PathKit

protocol GitRepositorySpec {
    func hasUncommittedChanges() async -> Bool
    func move(from: Path, to: Path) async throws
}

final class GitRepository: GitRepositorySpec {

    private let service: ProcessServiceSpec
    private let currentDirectory: URL
    private let logger: LoggerSpec
    init(path: URL, logger: LoggerSpec, service: ProcessServiceSpec = ProcessService()) async throws {
        self.service = service
        self.logger = logger
        let result = await service.run(currentDirectory: path, command: "git", arguments: ["rev-parse", "--show-toplevel"])
        switch result {
        case .success(let output):
            guard let url = URL(string: output) else {
                throw GitRepositoryError.invalidPath
            }
            self.currentDirectory = URL(fileURLWithPath: url.path)
        case .failure(let error):
            throw (GitRepositoryError.processError(error))
        }
    }
    
    func hasUncommittedChanges() async -> Bool {
        let result = await service.run(currentDirectory: currentDirectory, command: "git", arguments: ["status", "--porcelain | grep . >/dev/null && echo true || echo false"])
        switch result {
        case .success(let output):
            return output == "true"
        case .failure:
            return false
        }
    }
    
    func move(from: Path, to: Path) async throws {
        let result = await service.run(currentDirectory: currentDirectory, command: "git", arguments: ["mv", "\"\(from.string)\"", "\"\(to.string)\""])
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
