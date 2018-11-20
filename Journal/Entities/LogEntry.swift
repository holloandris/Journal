//
//  LogEntry.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 15..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public struct LogEntry: Codable {
    public let message: String
    public let level: LogLevel
    public let details: [String: String]
    init(message: String,
         level: LogLevel,
         details: [String: String]) {
        self.message = message
        self.level = level
        self.details = details
    }
}
