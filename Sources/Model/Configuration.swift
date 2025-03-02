//
//  Configuration.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/3/1.
//

import PathKit

struct Configuration: CustomStringConvertible {
    /// Paths to ignore when scanning for source files
    let ignorePaths: [Path]
    /// File types to ignore when scanning for source files
    let ignoreFileTypes: [String]
    /// Whether to move files only, without changing .xcodeproj settings
    let moveFileOnly: Bool
    
    var description: String {
        return """
        # Ignore Paths: \(ignorePaths)
        # Ignore File Types: \(ignoreFileTypes)
        # Move File Only: \(moveFileOnly)
        """
    }
    
    init() {
        self.ignorePaths = ["Pods", "Frameworks", "Products"]
        self.ignoreFileTypes = ["wrapper.framework", "wrapper.pb-project"]
        self.moveFileOnly = false
    }
    
    init(ignorePaths: [Path], ignoreFileTypes: [String], moveFileOnly: Bool) {
        self.ignorePaths = ignorePaths
        self.ignoreFileTypes = ignoreFileTypes
        self.moveFileOnly = moveFileOnly
    }
}
