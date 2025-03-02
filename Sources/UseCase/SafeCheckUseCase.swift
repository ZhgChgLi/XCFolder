//
//  SafeCheckUseCase.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation
import PathKit

protocol SafeCheckUseCaseSepc {
    func execute() async throws
}

final class SafeCheckUseCase: SafeCheckUseCaseSepc {
    
    private let projectPath: String
    private let gitRepository: GitRepositorySpec
    private let fileRepository: FileRepositorySpec
    init(projectPath: String,
         gitRepository: GitRepositorySpec,
         fileRepository: FileRepositorySpec) {
        self.projectPath = projectPath
        self.gitRepository = gitRepository
        self.fileRepository = fileRepository
    }
    
    func execute() async throws {
        guard let url = URL(string: projectPath),
                  url.pathExtension.lowercased() == "xcodeproj",
                  fileRepository.exists(at: Path(url.standardizedFileURL.relativeString)) else {
            throw SafeCheckUseCaseError.invalidPath
        }
        
        let fileURL = URL(fileURLWithPath: projectPath)
        if case .success(let gitURL) = await gitRepository.retrieveGitPath(path: fileURL) {
            let gitFileURL = URL(fileURLWithPath: gitURL.standardizedFileURL.relativeString)
            if await gitRepository.hasUncommittedChanges(path: gitFileURL) {
                throw SafeCheckUseCaseError.hasUncommittedChanges
            }
        }
    }
}

