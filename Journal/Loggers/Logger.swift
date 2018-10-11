//
//  Logger.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public protocol Logger {
    func log(logEntry: LogEntry)
    func setContextStore(_ contextStore: ContextStore)
}
