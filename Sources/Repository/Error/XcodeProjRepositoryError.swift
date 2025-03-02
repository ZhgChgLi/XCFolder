//
//  XcodeProjRepositoryError.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation

enum XcodeProjRepositoryError: Error, LocalizedError, CustomStringConvertible {
    case mainGroupNotFound
    
    var errorDescription: String? {
        switch self {
        case .mainGroupNotFound:
            return "Main group not found in Xcode project"
        }
    }
    
    var description: String {
        return errorDescription ?? "Unknown error"
    }
}
