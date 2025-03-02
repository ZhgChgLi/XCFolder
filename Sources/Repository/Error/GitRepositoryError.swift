//
//  GitRepositoryError.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation

enum GitRepositoryError: Error, LocalizedError, CustomStringConvertible {
    case invalidPath
    case processError(ProcessServiceError)
    
    var errorDescription: String? {
        switch self {
        case .invalidPath:
            return "The provided path is not a valid Git repository path"
        case .processError(let error):
            return "An error occurred while executing Git process commands: \(error.localizedDescription)"
        }
    }
    
    var description: String {
        return errorDescription ?? "Unknown error"
    }
}
