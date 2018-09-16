//
//  LogEntry.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 15..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public struct LogEntry: Encodable {
    private let message: String
    private let level: LogLevel
    private let details: [String: AnyEncodable]
    init(message: String,
         level: LogLevel,
         details: [String: AnyEncodable]) {
        self.message = message
        self.level = level
        self.details = details
    }
}
