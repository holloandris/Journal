//
//  ConsoleLogger.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 10..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class ConsoleLogger: Logger {
    
    private var contextStore: ContextStore?
    
    // MARK: - Lifecycle methods
    
    public init() {
        
    }
    
    // MARK: - Logger
    
    open func log(logEntry: LogEntry) {
        print(logEntry.level.rawValue.capitalized + ": " + logEntry.message)
    }
    
    open func setContextStore(_ contextStore: ContextStore) {
        self.contextStore = contextStore
    }
    
}
