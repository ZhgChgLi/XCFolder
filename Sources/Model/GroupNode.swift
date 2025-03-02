//
//  GroupNode.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation
import XcodeProj
import PathKit

final class GroupNode: PathNode {
    let source: PBXFileElement
    let path: String?
    let name: String?
    
    var parent: PathNode?
    var children: [PathNode] = []
    
    var isPBXVariantGroup: Bool {
        return self.source is PBXVariantGroup
    }
    
    var isMainGroup: Bool {
        return self.parent == nil
    }
    
    init(source: PBXFileElement, parent: PathNode?) {
        self.source = source
        self.name = source.name
        self.path = source.path
        self.parent = parent
    }
    
    func fullPath(projectPath: Path) -> Path {
        let result = parent?.fullPath(projectPath: projectPath) ?? Path()
        if isPBXVariantGroup {
            return projectPath + result
        } else {
            if let path = self.path {
                return projectPath + result + Path(Path(path).lastComponent)
            } else {
                return projectPath + result + Path(name ?? "")
            }
        }
    }
    
    func originalPath(projectPath: Path) -> Path? {
        var originalPath = projectPath
        if let parent = parent?.originalPath(projectPath: projectPath) {
            originalPath = originalPath + parent
        }
        
        if let path = path {
            originalPath = originalPath + path
        }
        
        return originalPath
    }
}
