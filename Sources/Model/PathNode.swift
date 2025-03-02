//
//  PathNode.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation
import XcodeProj
import PathKit

protocol PathNode: AnyObject {
    var source: PBXFileElement { get }
    var path: String? { get }
    var name: String? { get }
    
    var parent: PathNode? { get set }
    var children: [PathNode] { get set }
    
    func add(node: PathNode)
    func fullPath(projectPath: Path) -> Path
    func originalPath(projectPath: Path) -> Path?
}

extension PathNode {
    func add(node: PathNode) {
        node.parent = self
        children.append(node)
    }
}
