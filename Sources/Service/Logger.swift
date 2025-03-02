//
//  Logger.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/2/28.
//

import Foundation

protocol LoggerSpec {
    func log(message: String)
}

class Logger: LoggerSpec {
    func log(message: String) {
        print(message)
    }
}

