//
//  ConfigurationRepository.swift
//  XCFolder
//
//  Created by zhgchgli on 2025/3/1.
//

import Yams
import Foundation
import PathKit

protocol ConfigurationRepositorySpec {
    func fetch(path: Path) -> Result<Configuration, Error>
}

final class ConfigurationRepository: ConfigurationRepositorySpec {
    
    private lazy var decoder: YAMLDecoder = YAMLDecoder()
    
    func fetch(path: Path) -> Result<Configuration, Error> {
        let fileURL = URL(fileURLWithPath: path.string)
        do {
            let data = try Data(contentsOf: fileURL)
            let enitiy = try decoder.decode(ConfigurationEntity.self, from: data)
            
            return .success(ConfigurationMapper.map(from: enitiy))
        } catch {
            return .failure(error)
        }
    }
}

