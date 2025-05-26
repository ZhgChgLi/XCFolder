//
//  PathValidationTests.swift
//  XCFolderTests
//
//  Created by Fallah, Alex on 2025/2/27.
//

import XCTest
import Foundation
import PathKit
@testable import XCFolder

final class PathValidationTests: XCTestCase {
    var mockFileRepository: MockFileRepository!
    
    override func setUp() {
        super.setUp()
        mockFileRepository = MockFileRepository()
    }
    
    override func tearDown() {
        mockFileRepository = nil
        super.tearDown()
    }
    
    // MARK: - Xcode Project Path Validation Tests
    
    func testValidXcodeProjectPath() throws {
        // Given
        let projectPath = "/Users/test/MyProject.xcodeproj"
        mockFileRepository.addExistingPath(projectPath)
        
        // When & Then - This should not throw
        let url = URL(fileURLWithPath: projectPath).standardizedFileURL
        XCTAssertEqual(url.pathExtension.lowercased(), "xcodeproj")
        XCTAssertTrue(mockFileRepository.exists(at: Path(url.path)))
    }
    
    func testXcodeProjectPathWithSpaces() throws {
        // Given
        let projectPath = "/Users/test/My Project Name.xcodeproj"
        mockFileRepository.addExistingPath(projectPath)
        
        // When & Then - This should work with our fix
        let url = URL(fileURLWithPath: projectPath).standardizedFileURL
        XCTAssertEqual(url.pathExtension.lowercased(), "xcodeproj")
        XCTAssertTrue(mockFileRepository.exists(at: Path(url.path)))
    }
    
    func testXcodeProjectPathWithSpecialCharacters() throws {
        // Given
        let projectPath = "/Users/test/My-Project_Name (2024).xcodeproj"
        mockFileRepository.addExistingPath(projectPath)
        
        // When & Then
        let url = URL(fileURLWithPath: projectPath).standardizedFileURL
        XCTAssertEqual(url.pathExtension.lowercased(), "xcodeproj")
        XCTAssertTrue(mockFileRepository.exists(at: Path(url.path)))
    }
    
    func testInvalidXcodeProjectExtension() throws {
        // Given
        let projectPath = "/Users/test/MyProject.txt"
        mockFileRepository.addExistingPath(projectPath)
        
        // When & Then
        let url = URL(fileURLWithPath: projectPath).standardizedFileURL
        XCTAssertNotEqual(url.pathExtension.lowercased(), "xcodeproj")
    }
    
    func testNonExistentXcodeProject() throws {
        // Given
        let projectPath = "/Users/test/NonExistent.xcodeproj"
        // Don't add to mock repository
        
        // When & Then
        let url = URL(fileURLWithPath: projectPath).standardizedFileURL
        XCTAssertEqual(url.pathExtension.lowercased(), "xcodeproj")
        XCTAssertFalse(mockFileRepository.exists(at: Path(url.path)))
    }
    
    // MARK: - Configuration File Path Validation Tests
    
    func testValidYamlConfigurationPath() throws {
        // Given
        let configPath = "/Users/test/config.yaml"
        mockFileRepository.addExistingPath(configPath)
        
        // When & Then
        let url = URL(fileURLWithPath: configPath).standardizedFileURL
        XCTAssertEqual(url.pathExtension.lowercased(), "yaml")
        XCTAssertTrue(mockFileRepository.exists(at: Path(url.path)))
    }
    
    func testValidYmlConfigurationPath() throws {
        // Given
        let configPath = "/Users/test/config.yml"
        mockFileRepository.addExistingPath(configPath)
        
        // When & Then
        let url = URL(fileURLWithPath: configPath).standardizedFileURL
        XCTAssertEqual(url.pathExtension.lowercased(), "yml")
        XCTAssertTrue(mockFileRepository.exists(at: Path(url.path)))
    }
    
    func testConfigurationPathWithSpaces() throws {
        // Given
        let configPath = "/Users/test/my config file.yaml"
        mockFileRepository.addExistingPath(configPath)
        
        // When & Then
        let url = URL(fileURLWithPath: configPath).standardizedFileURL
        XCTAssertEqual(url.pathExtension.lowercased(), "yaml")
        XCTAssertTrue(mockFileRepository.exists(at: Path(url.path)))
    }
    
    func testInvalidConfigurationExtension() throws {
        // Given
        let configPath = "/Users/test/config.json"
        mockFileRepository.addExistingPath(configPath)
        
        // When & Then
        let url = URL(fileURLWithPath: configPath).standardizedFileURL
        let validExtensions = ["yaml", "yml"]
        XCTAssertFalse(validExtensions.contains(url.pathExtension.lowercased()))
    }
    
    // MARK: - URL Parsing Comparison Tests (Old vs New Approach)
    
    func testURLStringVsFileURLWithPathDifference() {
        // Given - path with spaces
        let pathWithSpaces = "/Users/test/My Project.xcodeproj"
        
        // When - comparing both approaches
        let urlFromString = URL(string: pathWithSpaces)
        let urlFromFilePath = URL(fileURLWithPath: pathWithSpaces)
        
        // Then - URL(string:) encodes spaces while URL(fileURLWithPath:) preserves them
        XCTAssertNotNil(urlFromString, "URL(string:) should create a URL")
        XCTAssertTrue(urlFromString!.absoluteString.contains("%20"), "URL(string:) should encode spaces")
        
        XCTAssertNotNil(urlFromFilePath, "URL(fileURLWithPath:) should create a URL")
        XCTAssertEqual(urlFromFilePath.path, pathWithSpaces, "URL(fileURLWithPath:) should preserve original path")
        
        // The key difference: URL(fileURLWithPath:) is designed for file paths
        XCTAssertTrue(urlFromFilePath.isFileURL, "URL(fileURLWithPath:) should create a file URL")
    }
    
    func testNewURLFilePathApproachWorksWithSpaces() {
        // Given - same path with spaces
        let pathWithSpaces = "/Users/test/My Project.xcodeproj"
        
        // When - using new approach (URL(fileURLWithPath:))
        let newApproachURL = URL(fileURLWithPath: pathWithSpaces).standardizedFileURL
        
        // Then - new approach works
        XCTAssertNotNil(newApproachURL)
        XCTAssertEqual(newApproachURL.pathExtension, "xcodeproj")
        XCTAssertTrue(newApproachURL.path.contains("My Project"))
    }
    
    func testPathNormalization() {
        // Given - path with redundant components
        let messyPath = "/Users/test/../test/./My Project.xcodeproj"
        
        // When
        let normalizedURL = URL(fileURLWithPath: messyPath).standardizedFileURL
        
        // Then - path should be normalized
        XCTAssertEqual(normalizedURL.pathExtension, "xcodeproj")
        XCTAssertFalse(normalizedURL.path.contains(".."))
        XCTAssertFalse(normalizedURL.path.contains("./"))
    }
    
    // MARK: - Edge Cases
    
    func testEmptyPath() {
        // Given
        let emptyPath = ""
        
        // When
        let url = URL(fileURLWithPath: emptyPath).standardizedFileURL
        
        // Then
        XCTAssertTrue(url.pathExtension.isEmpty)
    }
    
    func testPathWithOnlySpaces() {
        // Given
        let spacesPath = "   "
        
        // When
        let trimmedPath = spacesPath.trimmingCharacters(in: .whitespacesAndNewlines)
        let url = URL(fileURLWithPath: trimmedPath).standardizedFileURL
        
        // Then
        XCTAssertTrue(url.pathExtension.isEmpty)
        XCTAssertTrue(trimmedPath.isEmpty)
    }
    
    func testRelativePath() {
        // Given
        let relativePath = "./MyProject.xcodeproj"
        
        // When
        let url = URL(fileURLWithPath: relativePath).standardizedFileURL
        
        // Then
        XCTAssertEqual(url.pathExtension, "xcodeproj")
    }
    
    func testCaseInsensitiveExtension() {
        // Given
        let upperCasePath = "/Users/test/MyProject.XCODEPROJ"
        mockFileRepository.addExistingPath(upperCasePath)
        
        // When
        let url = URL(fileURLWithPath: upperCasePath).standardizedFileURL
        
        // Then
        XCTAssertEqual(url.pathExtension.lowercased(), "xcodeproj")
        XCTAssertTrue(mockFileRepository.exists(at: Path(url.path)))
    }
} 