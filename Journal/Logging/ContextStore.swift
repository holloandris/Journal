//
//  ContextStore.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public protocol ContextStore {
    var contexts: [String: String] { get }
    func setContext(_ context: LoggingContext, toValue value: String)
}
