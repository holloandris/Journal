//
//  LoggingDetailProvider.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 11..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public protocol LoggingDetailProvider {
    var loggingDetailStringID: String { get }
    func provideDetails() -> [String: String]
}
