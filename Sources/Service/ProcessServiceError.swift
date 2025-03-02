//
//  ProcessServiceError.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/27.
//

import Foundation

enum ProcessServiceError: Error {
    enum CommandError: Error {
        case notFound
        case unknown(String)
        
        init(string: String) {
            let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if trimmedString.lowercased().hasSuffix("command not found") {
                self = .notFound
            } else {
                self = .unknown(trimmedString)
            }
        }
    }
    case commandFailed(CommandError)
    case outputDecodeFailed(Data)
    case processFailed(Error)
}
