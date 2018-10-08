//
//  SerializationFileProviderMock.swift
//  JournalTests
//
//  Created by Andras Hollo on 2018. 09. 15..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import Journal

class SerializationFileProviderMock: SerializationFileProvider {
    
    let path: URL
    
    init() {
        path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test_log.log")
    }
    
    func provideFileURL() throws -> URL {
        return path
    }
    
}
