//
//  Journal.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public protocol JournalProtocol {
    func addContext(_ context:LoggingContext)
    func getContext(contextName:String, value:String)
    func log(message:String, level: LogLevel, details: [String: Any], error: Error?)
}

public class Journal: JournalProtocol {
    
    private let sessionID = UUID()
    
    public func addContext(_ context:LoggingContext) {
        
    }
    
    public func getContext(contextName:String, value:String) {
        
    }
    
    public func log(message:String, level: LogLevel, details: [String: Any], error: Error?) {
        var logEntry = [String: Any]()
        logEntry["message"] = message
        logEntry["level"] = level
        logEntry["details"] = details
    }

}
