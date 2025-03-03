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
    /// Use git mv if possible instead of filesystem move
    let gitMove: Bool
    
    var description: String {
        return """
        # Ignore Paths: \(ignorePaths)
        # Ignore File Types: \(ignoreFileTypes)
        # Move File Only: \(moveFileOnly)
        """
    }
    
    init() {
        self.ignorePaths = ["Pods", "Frameworks", "Products"]
        self.ignoreFileTypes = [
            "wrapper.framework",  // Frameworks
            "wrapper.pb-project", // Xcode project files
        ]
        self.moveFileOnly = false
        self.gitMove = true
    }
    
    init(ignorePaths: [Path], ignoreFileTypes: [String], moveFileOnly: Bool, gitMove: Bool) {
        self.ignorePaths = ignorePaths
        self.ignoreFileTypes = ignoreFileTypes
        self.moveFileOnly = moveFileOnly
        self.gitMove = gitMove
    }
}
