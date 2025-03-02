//
//  ProcessServiceSpec.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/27.
//

import Foundation

protocol ProcessServiceSpec {
    func run(currentDirectory: URL?, command: String, arguments: [String]) async -> Result<String, ProcessServiceError>
}
