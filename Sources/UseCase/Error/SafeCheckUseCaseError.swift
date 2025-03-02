//
//  SafeCheckUseCaseError.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation

enum SafeCheckUseCaseError: Error, LocalizedError, CustomStringConvertible {
    case invalidPath
    case hasUncommittedChanges
    
    var errorDescription: String? {
        switch self {
        case .invalidPath:
            return "The provided path is invalid"
        case .hasUncommittedChanges:
            return "There are uncommitted changes in the repository"
        }
    }
    
    var description: String {
        return errorDescription ?? "Unknown error"
    }
}
