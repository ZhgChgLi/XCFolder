//
//  FileNode.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation
import XcodeProj
import PathKit

final class FileNode: PathNode {
    let source: PBXFileElement
    let path: String?
    let name: String?
    
    var parent: PathNode?
    var children: [PathNode] = []
    
    var fileType: String? {
        return (source as? PBXFileReference)?.lastKnownFileType
    }
    
    var newPath: Path {
        guard let path = self.path else {
            return Path(name ?? "")
        }
        
        switch source.sourceTree {
        case .absolute, .sourceRoot:
            return Path(Path(path).lastComponent)
        case .group:
            return Path(path)
        default:
            return Path(path)
        }
    }
    
    init(source: PBXFileElement, parent: PathNode?) {
        self.source = source
        self.name = source.name
        self.path = source.path
        self.parent = parent
    }
    
    func fullPath(projectPath: Path) -> Path {
        let result = parent?.fullPath(projectPath: projectPath) ?? Path()
        return projectPath + result + newPath
    }
    
    func originalPath(projectPath: Path) -> Path? {
        guard let path = path else {
            return nil
        }
        
        switch source.sourceTree {
        case .absolute:
            return Path(path)
        case .group:
            let result = parent?.originalPath(projectPath: projectPath) ?? Path()
            return result + Path(path)
        case .sourceRoot:
            return projectPath + Path(path)
        default:
            return nil
        }
    }
}
