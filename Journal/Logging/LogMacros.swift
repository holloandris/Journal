//
//  LogMacros.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public func context(name: String, value: String) {
    
}

public func error(_ message: String, _ error: Error, _ details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .error, details: details ?? [:], error: error)
}

public func warning(_ message: String, _ details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .warning, details: details ?? [:], error: nil)
}

public func info(_ message: String, _ details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .info, details: details ?? [:], error: nil)
}

public func debug(_ message: String, _ details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .debug, details: details ?? [:], error: nil)
}

public func verbose(_ message: String, _ details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .verbose, details: details ?? [:], error: nil)
}
