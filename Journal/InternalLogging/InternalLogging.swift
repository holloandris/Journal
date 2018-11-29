//
//  InternalLogging.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 07..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

enum InternalLogLevel: Int {
    case error = 5
    case warning = 4
    case info = 3
    case debug = 2
    case verbose = 1
}

let internalLogVerbosity = InternalLogLevel.verbose

func internalLog(level: InternalLogLevel, message: String) {
    #if DEBUG
    if internalLogVerbosity.rawValue <= level.rawValue {
        print(message)
    }
    #endif
}

func internalLogError(_ message: String) {
    internalLog(level: .error, message: "Error: "+message)
}

func internalLogWarn(_ message: String) {
    internalLog(level: .warning, message: "Warning: "+message)
}

func internalLogInfo(_ message: String) {
    internalLog(level: .info, message: "Info: "+message)
}

func internalLogDebug(_ message: String) {
    internalLog(level: .debug, message: "Debug: "+message)
}

func internalLogVerbose(_ message: String) {
    internalLog(level: .verbose, message: "Verbose: "+message)
}

