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
    
    var masterNode: PathNode?
    
    var fileType: String? {
        return (source as? PBXFileReference)?.lastKnownFileType
    }
    
    init(source: PBXFileElement, parent: PathNode?) {
        self.source = source
        self.name = source.name
        self.path = source.path
        self.parent = parent
    }
    
    func fullPath(projectPath: Path) -> Path {
        let result = parent?.fullPath(projectPath: projectPath) ?? Path()
        if let path = self.path {
            return projectPath + result + Path(Path(path).lastComponent)
        } else {
            return projectPath + result + Path(name ?? "")
        }
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
