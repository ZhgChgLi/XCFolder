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
        if await gitRepository.hasUncommittedChanges() {
            throw SafeCheckUseCaseError.hasUncommittedChanges
        }
    }
}

