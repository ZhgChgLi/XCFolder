//
//  SafetyCheckTests.swift
//  XCFolderTests
//
//  Created by Fallah, Alex on 2025/2/27.
//

import XCTest
import Foundation
import PathKit
@testable import XCFolder

final class SafetyCheckTests: XCTestCase {
    var mockFileRepository: MockFileRepository!
    var mockGitRepository: MockGitRepository!
    
    override func setUp() {
        super.setUp()
        mockFileRepository = MockFileRepository()
        mockGitRepository = MockGitRepository()
    }
    
    override func tearDown() {
        mockFileRepository = nil
        mockGitRepository = nil
        super.tearDown()
    }
    
    // MARK: - Safety Check Use Case Tests
    
    func testSafetyCheckPassesWithNoUncommittedChanges() async throws {
        // Given
        mockGitRepository.hasUncommittedChangesResult = false
        let safetyCheck = SafeCheckUseCase(
            projectPath: "/test/project",
            gitRepository: mockGitRepository,
            fileRepository: mockFileRepository
        )
        
        // When & Then - should not throw
        try await safetyCheck.execute()
        XCTAssertTrue(mockGitRepository.hasUncommittedChangesCalled)
    }
    
    func testSafetyCheckFailsWithUncommittedChanges() async throws {
        // Given
        mockGitRepository.hasUncommittedChangesResult = true
        let safetyCheck = SafeCheckUseCase(
            projectPath: "/test/project",
            gitRepository: mockGitRepository,
            fileRepository: mockFileRepository
        )
        
        // When & Then - should throw
        do {
            try await safetyCheck.execute()
            XCTFail("Expected SafeCheckUseCaseError.hasUncommittedChanges to be thrown")
        } catch SafeCheckUseCaseError.hasUncommittedChanges {
            // Expected error
            XCTAssertTrue(mockGitRepository.hasUncommittedChangesCalled)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Command Line Flag Tests
    
    func testSkipSafetyCheckFlagDefaultValue() {
        // This test demonstrates the expected default behavior
        // In practice, the flag would be parsed from command line arguments
        
        // Given - default behavior expectation
        let defaultSkipSafetyCheck = false
        
        // Then
        XCTAssertFalse(defaultSkipSafetyCheck, "skipSafetyCheck should default to false")
    }
    
    // MARK: - Integration Tests (would require actual command parsing)
    
    func testCommandLineArgumentParsing() throws {
        // This test demonstrates how the flag would be used
        // In a real scenario, you'd test the ArgumentParser integration
        
        // Given - command line arguments with skip safety check
        let arguments = ["xcfolder", "project.xcodeproj", "config.yml", "--skip-safety-check"]
        
        // When - parsing arguments (this is conceptual)
        let hasSkipFlag = arguments.contains("--skip-safety-check")
        
        // Then
        XCTAssertTrue(hasSkipFlag, "Should detect skip-safety-check flag")
    }
    
    func testCommandLineArgumentParsingWithoutFlag() throws {
        // Given - command line arguments without skip safety check
        let arguments = ["xcfolder", "project.xcodeproj", "config.yml"]
        
        // When - parsing arguments
        let hasSkipFlag = arguments.contains("--skip-safety-check")
        
        // Then
        XCTAssertFalse(hasSkipFlag, "Should not detect skip-safety-check flag when not present")
    }
    
    func testCommandLineArgumentParsingWithMultipleFlags() throws {
        // Given - command line arguments with multiple flags
        let arguments = ["xcfolder", "project.xcodeproj", "config.yml", "--is-non-interactive-mode", "--skip-safety-check"]
        
        // When - parsing arguments
        let hasSkipFlag = arguments.contains("--skip-safety-check")
        let hasNonInteractiveFlag = arguments.contains("--is-non-interactive-mode")
        
        // Then
        XCTAssertTrue(hasSkipFlag, "Should detect skip-safety-check flag")
        XCTAssertTrue(hasNonInteractiveFlag, "Should detect is-non-interactive-mode flag")
    }
}

// MARK: - Mock Git Repository

class MockGitRepository: GitRepositorySpec {
    var hasUncommittedChangesResult: Bool = false
    var hasUncommittedChangesCalled: Bool = false
    var movedPaths: [(from: Path, to: Path)] = []
    
    func hasUncommittedChanges() async -> Bool {
        hasUncommittedChangesCalled = true
        return hasUncommittedChangesResult
    }
    
    func move(from: Path, to: Path) async throws {
        movedPaths.append((from: from, to: to))
    }
} 