//
//  XcodeProjRepository.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation
import XcodeProj
import PathKit

protocol XcodeProjRepositorySpec {
    var xcodeProjPath: Path { get }
    func parse() throws -> PathNode
    func isInBuildFiles(pathNode: PathNode) -> Bool
    func delete(pathNode: PathNode)
    func deleteGroupIfEmpty(pathNode: PathNode)
    func save() throws
}

final class XcodeProjRepository: XcodeProjRepositorySpec {
    
    let xcodeProjPath: Path
    
    private let proj: XcodeProj
    init(path: Path) throws {
        self.xcodeProjPath = path
        self.proj = try XcodeProj(path: path)
    }
    
    func parse() throws -> PathNode {
        guard let rootGroup = try proj.pbxproj.rootGroup() else {
            throw XcodeProjRepositoryError.mainGroupNotFound
        }
    
        var uniquePaths: [Path: [FileNode]] = [:]
        
        let root = GroupNode(source: rootGroup, parent: nil)
        enumerator(pathNode: root, group: rootGroup, uniquePaths: &uniquePaths)
        
        uniquePaths.filter { $0.value.count > 1 }.forEach { (key, value) in
            if let masetrNode = value.first(where: { self.isInBuildFiles(pathNode: $0) }) ?? value.first {
                value.forEach { node in
                    if node !== masetrNode {
                        node.masterNode = masetrNode
                    }
                }
            }
        }
        
        return root
    }
    
    func isInBuildFiles(pathNode: PathNode) -> Bool {
        return proj.pbxproj.buildFiles.contains { $0.file?.uuid == pathNode.source.uuid }
    }
    
    func delete(pathNode: PathNode) {
        proj.pbxproj.delete(object: pathNode.source)
    }
    
    func deleteGroupIfEmpty(pathNode: PathNode) {
        guard let group = pathNode.source as? PBXGroup else {
            return
        }
        
        if isEmptyGroup(group: group) {
            delete(pathNode: pathNode)
        }
    }
    
    func save() throws {
        try proj.write(path: xcodeProjPath)
    }
}

private extension XcodeProjRepository {
    func enumerator(pathNode: PathNode, group: PBXGroup, uniquePaths: inout [Path: [FileNode]]) {
        group.children.forEach { child in
            if let group = child as? PBXGroup {
                let node = GroupNode(source: group, parent: pathNode)
                pathNode.add(node: node)
                enumerator(pathNode: node, group: group, uniquePaths: &uniquePaths)
            } else if let file = child as? PBXFileReference {
                let node = FileNode(source: file, parent: pathNode)
                pathNode.add(node: node)
                
                if let originalPath = node.originalPath(projectPath: "/") {
                    if uniquePaths[originalPath] == nil {
                        uniquePaths[originalPath] = []
                    }
                    uniquePaths[originalPath]?.append(node)
                }
            }
        }
    }
    
    func isEmptyGroup(group: PBXGroup) -> Bool {
        guard !group.children.isEmpty else {
            return true
        }
        
        guard !group.children.contains(where: { !($0 is PBXGroup) }) else {
            return false
        }
        
        return group.children.compactMap({ $0 as? PBXGroup }).map({ isEmptyGroup(group: $0) }).reduce(true, { $0 && $1 })
    }
}
