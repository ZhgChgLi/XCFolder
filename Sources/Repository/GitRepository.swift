//
//  GitVersionControlSystemRepository.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/27.
//

import Foundation

protocol GitRepositorySpec {
    func retrieveGitPath(path: URL) async -> Result<URL, GitRepositoryError>
    func hasUncommittedChanges(path: URL) async -> Bool
}

final class GitRepository: GitRepositorySpec {

    private let service: ProcessServiceSpec
    init(service: ProcessServiceSpec = ProcessService()) {
        self.service = service
    }
    
    func retrieveGitPath(path: URL) async -> Result<URL, GitRepositoryError> {
        let result = await service.run(currentDirectory: path, command: "git", arguments: ["rev-parse", "--show-toplevel"])
        switch result {
        case .success(let output):
            guard let url = URL(string: output) else {
                return .failure(GitRepositoryError.invalidPath)
            }
            return .success(url)
        case .failure(let error):
            return .failure(GitRepositoryError.processError(error))
        }
    }
    
    func hasUncommittedChanges(path: URL) async -> Bool {
        let result = await service.run(currentDirectory: path, command: "git", arguments: ["status", "--porcelain | grep . >/dev/null && echo true || echo false"])
        switch result {
        case .success(let output):
            return output == "true"
        case .failure:
            return false
        }
    }
}
