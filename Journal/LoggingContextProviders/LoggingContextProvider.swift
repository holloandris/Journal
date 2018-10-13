//
//  LoggingContextProvider.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 11..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import Foundation

public protocol LoggingContextProvider {
    func setContextStore(_ contextStore: ContextStore)
}
