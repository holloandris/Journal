//
//  DefaultContextStore.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 16..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class DefaultContextStore: ContextStore {
    
    public func setContext(_ context: LoggingContext, toValue value: Encodable) {
        
    }
    
    public func getContextValue(_ context: LoggingContext) -> Encodable {
        return ""
    }

}
