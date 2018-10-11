//
//  Journal.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public protocol JournalProtocol {
    func add(logger: Logger)
    func addContext(_ context:LoggingContext)
    func getContext(contextName:String, value:String)
    func log(message:String, level: LogLevel, details: [String: AnyEncodable], error: Error?)
}

open class Journal: JournalProtocol {
    
    private let sessionID = UUID()
    
    private var loggers = [Logger]()
    private var contextStore = DefaultContextStore()
    
    // MARK: - Journal methods
    
    open func addContext(_ context:LoggingContext) {
        
    }
    
    open func getContext(contextName:String, value:String) {
        
    }
    
    // MARK: - Loggers
    
    open func add(logger: Logger) {
        loggers.append(logger)
        logger.setContextStore(contextStore)
    }
    
    // MARK: - Logging
    
    open func log(message:String, level: LogLevel, details: [String: AnyEncodable], error: Error?) {
        let logEntry = LogEntry(message: message, level: level, details: details)
        for logger in loggers {
            logger.log(logEntry: logEntry)
        }
    }

}
