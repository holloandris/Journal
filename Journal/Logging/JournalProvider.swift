//
//  JournalProvider.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import UIKit

class JournalProvider {
    
    let journal: JournalProtocol = Journal()
    
    static let shared = JournalProvider()
    
    private init() {}

}
