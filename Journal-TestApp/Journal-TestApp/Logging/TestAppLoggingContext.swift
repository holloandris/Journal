//
//  TestAppLoggingContext.swift
//  Journal-TestApp
//
//  Created by Andras Hollo on 2018. 10. 10..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import Foundation
import Journal

enum TestAppLoggingContext: String, LoggingContext {
    case loggedInUser = "logged_in_user"
    case playedSong = "played_song"
    
    var identifier: String {
        return self.rawValue
    }
}

