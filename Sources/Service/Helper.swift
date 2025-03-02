//
//  Helper.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/3/2.
//

import Foundation

struct Helper {
    static func readAsyncInput() async -> String {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                if let input = readLine() {
                    continuation.resume(returning: input.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    continuation.resume(returning: "")
                }
            }
        }
    }
}
