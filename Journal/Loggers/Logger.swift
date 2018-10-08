//
//  Logger.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public protocol Logger {
    func addContext(contextName:String)
    func setContext(contextName:String, value:String)
    func log(logEntry: LogEntry)
}
