//
//  AppDelegate.swift
//  Journal-TestApp
//
//  Created by Andras Hollo on 2018. 10. 07..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import UIKit
import Journal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogging()
        
        return true
    }
    
    // MARK: - Private helper methods
    
    private func setupLogging() {
        // Setup Journal with Bonjour and JSON logger
        JournalProvider.shared.journal.add(logger: BonjourLogger())
        JournalProvider.shared.journal.add(logger: ConsoleLogger())
        JournalProvider.shared.journal.add(logger: JSONLogger())
        JournalProvider.shared.journal.add(loggingContextProvider: AppSessionLoggingContextProvider())
        JournalProvider.shared.journal.add(loggingDetailProvider: TimeLoggingDetailProvider())
        JournalProvider.shared.journal.add(loggingDetailProvider: ClassLoggingDetailProvider())
    }

}
