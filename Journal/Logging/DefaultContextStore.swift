//
//  DefaultContextStore.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 16..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class DefaultContextStore: ContextStore {
    
    private var storage = [String: AnyEncodable]()
    
    // MARK: - ContextStore
    
    public func setContext(_ context: LoggingContext, toValue value: Encodable) {
        storage[context.identifier] = AnyEncodable(value: value)
    }
    
    public func getContextValue(_ context: LoggingContext) -> Encodable {
        return storage[context.identifier] ?? ""
    }

}
