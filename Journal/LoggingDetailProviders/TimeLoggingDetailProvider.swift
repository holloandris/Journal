//
//  TimeLoggingDetailProvider.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 12..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class TimeLoggingDetailProvider: LoggingDetailProvider {
    
    public let loggingDetailStringID = "Time"
    
    public var dateFormatter: DateFormatter
    
    // MARK: - Lifecycle methods
    
    public init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    // MARK: LoggingDetailProvider
    
    open func provideDetails() -> [String: String] {
        let dateString = dateFormatter.string(from: Date())
        return [loggingDetailStringID: dateString]
    }
    
}
