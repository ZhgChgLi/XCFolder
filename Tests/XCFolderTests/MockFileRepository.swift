//
//  MockFileRepository.swift
//  XCFolderTests
//
//  Created by Fallah, Alex on 2025/2/27.
//

import Foundation
import PathKit
@testable import XCFolder

class MockFileRepository: FileRepositorySpec {
    var existingPaths: Set<String> = []
    var removedPaths: [Path] = []
    var movedPaths: [(from: Path, to: Path)] = []
    var createdDirectories: [Path] = []
    var fileContents: [String: String] = [:]
    
    func exists(at path: Path) -> Bool {
        return existingPaths.contains(path.string)
    }
    
    func remove(at path: Path) throws {
        removedPaths.append(path)
        existingPaths.remove(path.string)
    }
    
    func move(from: Path, to: Path) throws {
        movedPaths.append((from: from, to: to))
        existingPaths.remove(from.string)
        existingPaths.insert(to.string)
    }
    
    func create(directory path: Path) throws {
        createdDirectories.append(path)
        existingPaths.insert(path.string)
    }
    
    func isEmpty(directory path: Path) throws -> Bool {
        // Mock implementation - return true if no files exist with this path as prefix
        return !existingPaths.contains { $0.hasPrefix(path.string + "/") }
    }
    
    func read(file path: String) throws -> String {
        guard let content = fileContents[path] else {
            throw NSError(domain: "MockFileRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        return content
    }
    
    // Helper methods for testing
    func addExistingPath(_ path: String) {
        existingPaths.insert(path)
    }
    
    func setFileContent(_ path: String, content: String) {
        fileContents[path] = content
        existingPaths.insert(path)
    }
    
    func reset() {
        existingPaths.removeAll()
        removedPaths.removeAll()
        movedPaths.removeAll()
        createdDirectories.removeAll()
        fileContents.removeAll()
    }
} 