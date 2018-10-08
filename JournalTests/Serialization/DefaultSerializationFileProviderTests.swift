//
//  DefaultSerializationFileProviderTests.swift
//  JournalTests
//
//  Created by Andras Hollo on 2018. 09. 16..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import XCTest
@testable import Journal

class DefaultSerializationFileProviderTests: XCTestCase {
    
    private let sut = DefaultSerializationFileProvider()
    
    func testGeneratesFileURL() {
        // Given
        
        // When
        var fileURL: URL?
        do {
            fileURL = try sut.provideFileURL()
        } catch {
            XCTFail("File URL generation failed with error: \(error)")
        }
        
        // Then
        XCTAssertNotNil(fileURL)
    }
    
}
