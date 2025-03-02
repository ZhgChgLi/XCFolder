//
//  FileRepository.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation
import PathKit

protocol FileRepositorySpec {
    func remove(at path: Path) throws
    func move(from: Path, to: Path) throws
    func exists(at path: Path) -> Bool
    func create(directory path: Path) throws
    func isEmpty(directory path: Path) throws -> Bool
    func read(file path: String) throws -> String
}

final class FileRepository: FileRepositorySpec {
    
    private let fileManager: FileManager
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func exists(at path: Path) -> Bool {
        return fileManager.fileExists(atPath: path.string, isDirectory: nil)
    }
    
    func move(from: Path, to: Path) throws {
        try fileManager.moveItem(atPath: from.string, toPath: to.string)
    }
    
    func remove(at path: Path) throws {
        try fileManager.removeItem(atPath: path.string)
    }

    func create(directory path: PathKit.Path) throws {
        try fileManager.createDirectory(atPath: path.string, withIntermediateDirectories: true, attributes: nil)
    }
    
    func isEmpty(directory path: Path) throws -> Bool {
        return try fileManager.contentsOfDirectory(atPath: path.string).isEmpty
    }
    
    func read(file path: String) throws -> String {
        let fileURL = URL(fileURLWithPath: path)
        let string = try String(contentsOf: fileURL, encoding: .utf8)
        return string
    }
}

