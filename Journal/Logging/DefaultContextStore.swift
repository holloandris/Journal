//
//  DefaultContextStore.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 16..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class DefaultContextStore: ContextStore {
    
    private var storage = [String: String]()
    
    // MARK: - ContextStore
    
    public func setContext(_ context: LoggingContext, toValue value: String) {
        storage[context.identifier] = value
    }
    
    public func getContextValue(_ context: LoggingContext) -> String {
        return storage[context.identifier] ?? ""
    }

}
