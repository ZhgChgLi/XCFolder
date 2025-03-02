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
    /// Allowed file types to include when scanning
    let allowFileTypes: [String]
    /// Whether to move files only, without changing .xcodeproj settings
    let moveFileOnly: Bool
    
    var description: String {
        return """
        # Ignore Paths: \(ignorePaths)
        # Allow File Types: \(allowFileTypes)
        # Move File Only: \(moveFileOnly)
        """
    }
    
    init() {
        self.ignorePaths = ["Pods", "Frameworks", "Products"]
        self.allowFileTypes = ["sourcecode.swift", "sourcecode.c.objc", "sourcecode.cpp.objcpp", "sourcecode.c.h","file.xib","file.storyboard","folder.assetcatalog","text.json.xcstrings","text.plist.strings"]
        self.moveFileOnly = false
    }
    
    init(ignorePaths: [Path], allowFileTypes: [String], moveFileOnly: Bool) {
        self.ignorePaths = ignorePaths
        self.allowFileTypes = allowFileTypes
        self.moveFileOnly = moveFileOnly
    }
}
