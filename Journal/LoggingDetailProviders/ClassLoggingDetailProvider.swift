//
//  ClassLoggingDetailProvider.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 11..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class ClassLoggingDetailProvider: LoggingDetailProvider {
    
    public var skipLevel: UInt = 2
    
    public let loggingDetailStringID = "Class"
    
    // MARK: - Lifecycle methods
    
    public init() {}
    
    // MARK: LoggingDetailProvider
    
    open func provideDetails() -> [String: AnyEncodable] {
        let stackSymbols = Thread.callStackSymbols
        if (stackSymbols.count > skipLevel) {
            if let callerClass = CallStackParser.classAndMethodForStackSymbol(stackSymbols[Int(skipLevel)], includeImmediateParentClass: true)?.0 {
                return [loggingDetailStringID: AnyEncodable(value: callerClass)]
            }
        }
        return [loggingDetailStringID: AnyEncodable(value: "Unavailable")]
    }
    
}
