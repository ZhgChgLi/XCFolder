//
//  ConfigurationEntity.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/3/1.
//

import Foundation
import Yams

struct ConfigurationEntity: Decodable {
    /// Paths to ignore when scanning for source files
    let ignorePaths: [String]
    /// Allowed file types to include when scanning
    let allowFileTypes: [String]
    /// Whether to move files only, without changing .xcodeproj settings
    let moveFileOnly: Bool
}
