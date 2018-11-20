//
//  JSONLogSerializerTests.swift
//  JournalTests
//
//  Created by Andras Hollo on 2018. 09. 15..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import XCTest
@testable import Journal

class JSONLogSerializerTests: XCTestCase {
    
    private var serializationFileProviderMock: SerializationFileProviderMock!
    private var sut: JSONLogSerializer!
    
    override func setUp() {
        super.setUp()
        
        serializationFileProviderMock = SerializationFileProviderMock()
        sut = JSONLogSerializer(serializationFileProvider: serializationFileProviderMock)
    }
    
    override func tearDown() {
        removeTestLogFile()
        
        super.tearDown()
    }
    
    func testJSONSerialization() {
        // Given
        let logEntry = LogEntry(message: "Example message", level: .debug, details: ["Test": "6"])
        
        // When
        sut.serialize(logEntry: logEntry)
        
        // Then
        do {
            wait(for: 1)
            let jsonLog = try String(contentsOf: serializationFileProviderMock.path, encoding: .utf8)
            let expectedFilePath = Bundle(for: type(of: self)).url(forResource: "json_log_test_single", withExtension: "log")
            let expectedLog = try String(contentsOf: expectedFilePath!, encoding: .utf8)
            XCTAssertEqual(jsonLog, expectedLog)
        } catch {
            XCTFail("JSON serialization failed with error: \(error)")
        }
    }
    
    func testMultipleJSONSerialization() {
        // Given
        let logEntry = LogEntry(message: "Example message", level: .debug, details: ["Test": "6"])
        let logEntry2 = LogEntry(message: "Example message 2", level: .debug, details: ["Test": "7"])
        
        // When
        sut.serialize(logEntry: logEntry)
        sut.serialize(logEntry: logEntry2)
        
        // THen
        do {
            wait(for: 1)
            let jsonLog = try String(contentsOf: serializationFileProviderMock.path, encoding: .utf8)
            let expectedFilePath = Bundle(for: type(of: self)).url(forResource: "json_log_test_multiple", withExtension: "log")
            let expectedLog = try String(contentsOf: expectedFilePath!, encoding: .utf8)
            XCTAssertEqual(jsonLog, expectedLog)
        } catch {
            XCTFail("JSON serialization failed with error: \(error)")
        }
    }
    
    private func removeTestLogFile() {
        do {
            try FileManager.default.removeItem(at: serializationFileProviderMock.path)
        } catch {
            XCTFail("Failed to remove test log file with error: \(error)")
        }
    }
    
}
