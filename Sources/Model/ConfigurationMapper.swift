//
//  ConfigurationMapper.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/3/1.
//

import Foundation
import PathKit

struct ConfigurationMapper {
    static func map(from entity: ConfigurationEntity) -> Configuration {
        let ignorePaths = entity.ignorePaths.map { Path($0) }.map ({ path in
            if path.string.hasPrefix("/") {
                return Path(String(path.string.dropFirst()))
            } else {
                return path
            }
        })
        let allowFileTypes = entity.allowFileTypes
        let moveFileOnly = entity.moveFileOnly
        return Configuration(ignorePaths: ignorePaths, allowFileTypes: allowFileTypes, moveFileOnly: moveFileOnly)
    }
}
