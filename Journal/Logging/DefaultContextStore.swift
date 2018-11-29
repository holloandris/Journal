//
//  DefaultContextStore.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 16..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class DefaultContextStore: ContextStore {
    
    private var storage = [String: String]()
    
    public var contexts: [String: String] {
        return storage
    }
    
    // MARK: - ContextStore
    
    public func setContext(_ context: LoggingContext, toValue value: String) {
        if value.isEmpty {
            storage.removeValue(forKey: context.identifier)
        } else {
            storage[context.identifier] = value
        }
    }

}
