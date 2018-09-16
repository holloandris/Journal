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
        let logEntry = LogEntry(message: "Example message", level: .debug, details: ["Test": AnyEncodable(value: 6)])
        sut.serialize(logEntry: logEntry)
        do {
            wait(for: 1)
            let jsonLog = try String(contentsOf: serializationFileProviderMock.path, encoding: .utf8)
            let expectedFilePath = Bundle(for: type(of: self)).url(forResource: "json_log_test_single", withExtension: "log")
            let expectedLog = try String(contentsOf: expectedFilePath!, encoding: .utf8)
            XCTAssertEqual(expectedLog, jsonLog)
        } catch {
            XCTFail()
        }
    }
    
    func testMultipleJSONSerialization() {
        let logEntry = LogEntry(message: "Example message", level: .debug, details: ["Test": AnyEncodable(value: 6)])
        sut.serialize(logEntry: logEntry)
        let logEntry2 = LogEntry(message: "Example message 2", level: .debug, details: ["Test": AnyEncodable(value: 7)])
        sut.serialize(logEntry: logEntry2)
        do {
            wait(for: 1)
            let jsonLog = try String(contentsOf: serializationFileProviderMock.path, encoding: .utf8)
            let expectedFilePath = Bundle(for: type(of: self)).url(forResource: "json_log_test_multiple", withExtension: "log")
            let expectedLog = try String(contentsOf: expectedFilePath!, encoding: .utf8)
            XCTAssertEqual(expectedLog, jsonLog)
        } catch {
            XCTFail()
        }
    }
    
    private func removeTestLogFile() {
        do {
            try FileManager.default.removeItem(at: serializationFileProviderMock.path)
        } catch {
            
        }
    }
    
}
