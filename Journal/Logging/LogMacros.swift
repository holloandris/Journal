//
//  LogMacros.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public func context(name: String, value: String) {
    
}

public func error(message: String, error: Error, details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .error, details: details ?? [:], error: error)
}

public func warning(message: String, details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .warning, details: details ?? [:], error: nil)
}

public func info(message: String, details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .info, details: details ?? [:], error: nil)
}

public func debug(message: String, details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .debug, details: details ?? [:], error: nil)
}

public func verbose(message: String, details: [String: String]? = nil) {
    JournalProvider.shared.journal.log(message: message, level: .verbose, details: details ?? [:], error: nil)
}
