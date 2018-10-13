//
//  AppSessionLoggingContextProvider.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 11..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public enum AppSessionLoggingContext: String, LoggingContext {
    case appSession = "app_session"
    
    public var identifier: String {
        return self.rawValue
    }
}

open class AppSessionLoggingContextProvider: LoggingContextProvider {
    
    private var contextStore: ContextStore?
    
    private let sessionID = UUID()
    
    // MARK: - Lifecycle methods
    
    public init() {
        
    }
    
    // MARK: - LoggingContextProvider
    
    open func setContextStore(_ contextStore: ContextStore) {
        self.contextStore = contextStore
        contextStore.setContext(AppSessionLoggingContext.appSession, toValue: sessionID)
    }
    
}
