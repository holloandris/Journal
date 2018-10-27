//
//  DefaultContextStore.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 16..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class DefaultContextStore: ContextStore {
    
    private var storage = [String: AnyCodable]()
    
    // MARK: - ContextStore
    
    public func setContext(_ context: LoggingContext, toValue value: Codable) {
        storage[context.identifier] = AnyCodable(value: value)
    }
    
    public func getContextValue(_ context: LoggingContext) -> Codable {
        return storage[context.identifier] ?? ""
    }

}
