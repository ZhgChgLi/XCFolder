//
//  GroupToFolderUseCase.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation
import PathKit
import XcodeProj

protocol GroupToFolderUseCaseSepc {
    func execute() async
}

class GroupToFolderUseCase: GroupToFolderUseCaseSepc {
    
    let projectRootPath: Path
    let xcodeProjRepository: XcodeProjRepositorySpec
    let fileRepository: FileRepositorySpec
    let gitRepository: GitRepositorySpec?
    let logger: LoggerSpec
    let configuration: Configuration
    
    init(projectRootPath: Path,
         configuration: Configuration,
         xcodeProjRepository: XcodeProjRepositorySpec,
         fileRepository: FileRepositorySpec,
         gitRepository: GitRepositorySpec?,
         logger: LoggerSpec) {
        self.projectRootPath = projectRootPath
        self.xcodeProjRepository = xcodeProjRepository
        self.fileRepository = fileRepository
        self.gitRepository = gitRepository
        self.configuration = configuration
        self.logger = logger
    }
    
    func execute() async {
        do {
            logger.log(message: "🔍 Congiuartion:")
            logger.log(message: configuration.description)
            logger.log(message: "🚀 Starting project organization")
            
            let pathNode = try xcodeProjRepository.parse()
            await enumerator(pathNode: pathNode)
            
            if !configuration.moveFileOnly {
                try xcodeProjRepository.save()
            }
            
            logger.log(message: "✅ Project organization completed successfully")
        } catch {
            logger.log(message: "❌ Operation failed: \(error)")
        }
    }
}

private extension GroupToFolderUseCase {
    func enumerator(pathNode: PathNode) async {
        let cleanFullPath = pathNode.fullPath(projectPath: "")
        guard !configuration.ignorePaths.contains(cleanFullPath) else {
            logger.log(message: "⏭️ Ignoring path: \(cleanFullPath)")
            return
        }
        
        let fullPath = pathNode.fullPath(projectPath: projectRootPath)
        if let pathNode = pathNode as? GroupNode {
            guard !pathNode.isPBXVariantGroup else {
                logger.log(message: "⏭️ Skipping PBXVariantGroup: \(pathNode.path ?? "unknown")")
                return
            }
            
            if !pathNode.isMainGroup {
                creatDirectoryIfNotExsits(path: fullPath)
            }
            
            for child in pathNode.children {
                await enumerator(pathNode: child)
            }
            
            if !pathNode.isMainGroup {
                if let originalPath = pathNode.originalPath(projectPath: projectRootPath) {
                    deleteDirectoryIfEmpty(path: originalPath)
                }
                
                adjustXcodeProjGroup(pathNode: pathNode, fullPath: fullPath)
            }
        } else if let pathNode = pathNode as? FileNode {
            guard let fileType = pathNode.fileType,
                  !configuration.ignoreFileTypes.contains(fileType) else {
                logger.log(message: "⏭️ Skipping file with unsupported type: \(pathNode.path ?? "unknown")")
                return
            }
            
            guard let originalPath = pathNode.originalPath(projectPath: projectRootPath) else {
                logger.log(message: "⚠️ Invalid path format: \(pathNode.path ?? "unknown")")
                return
            }
            
            guard originalPath != fullPath else {
                adjustXcodeProjFile(pathNode: pathNode, fullPath: fullPath)
                logger.log(message: "ℹ️ File already at correct path: \(pathNode.path ?? "unknown")")
                return
            }
            
            guard pathNode.masterNode == nil else {
                logger.log(message: "⏭️ Redundant path: \(pathNode.path ?? "unknown")")
                return
            }
            
            guard fileRepository.exists(at: originalPath) else {
                // File Not Found, remove reference file from xcodeproj
                xcodeProjRepository.delete(pathNode: pathNode)
                logger.log(message: "🗑️ Removing reference (file not found): \(pathNode.path ?? "unknown")")
                return
            }
            
            creatDirectoryIfNotExsits(path: fullPath.parent())
            await moveFile(from: originalPath, to: fullPath)
            adjustXcodeProjFile(pathNode: pathNode, fullPath: fullPath)
        }
    }
    
    func adjustXcodeProjGroup(pathNode: GroupNode, fullPath: Path) {
        pathNode.source.name = nil
        pathNode.source.path = fullPath.lastComponent
        xcodeProjRepository.deleteGroupIfEmpty(pathNode: pathNode)
    }
    
    func adjustXcodeProjFile(pathNode: FileNode, fullPath: Path) {
        pathNode.source.path = fullPath.lastComponent
        pathNode.source.sourceTree = .group
    }
    
    func creatDirectoryIfNotExsits(path: Path) {
        if !fileRepository.exists(at: path) {
            do {
                try fileRepository.create(directory: path)
                logger.log(message: "📁 Created new directory: \(path)")
            } catch {
                logger.log(message: "❌ Directory creation failed: \(error)")
            }
        }
    }
    
    func moveFile(from: Path, to: Path) async {
        do {
            if fileRepository.exists(at: to) {
                try fileRepository.remove(at: to)
                logger.log(message: "🗑️ Removing existing file: \(to)")
            }
        } catch {
            logger.log(message: "❌ File remove failed: \(error)")
        }
        
        do {
            if configuration.gitMove,
               let gitRepository = self.gitRepository {
                do {
                    try await gitRepository.move(from: from, to: to)
                    logger.log(message: "📝 (Git) Moved file from \(from) to \(to)")
                    
                    // Due to potential issues with Git when moving files, we will use filesystem move instead, double-check again.
                    if !fileRepository.exists(at: to) {
                        try fileRepository.move(from: from, to: to)
                        logger.log(message: "❌ (Git) Moved failed, use filesystem move instead: from \(to) to \(to)")
                    }
                } catch {
                    try fileRepository.move(from: from, to: to)
                    logger.log(message: "❌ (Git) Moved failed, use filesystem move instead: \(error)")
                    logger.log(message: "📝 Moved file from \(from) to \(to)")
                }
            } else {
                try fileRepository.move(from: from, to: to)
                logger.log(message: "📝 Moved file from \(from) to \(to)")
            }
            
        } catch {
            logger.log(message: "❌ File move failed: \(error)")
        }
    }
    
    func deleteDirectoryIfEmpty(path: Path) {
        do {
            guard try fileRepository.isEmpty(directory: path) else {
                return
            }
            try fileRepository.remove(at: path)
            logger.log(message: "🗑️ Removed empty directory: \(path)")
        } catch {
            logger.log(message: "❌ Directory removal failed: \(error)")
        }
    }
}
