//
//  BonjourLogger.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class BonjourLogger: Logger {
    
    private let bonjourManager = BonjourManager()
    private var logEntryQueue = ThreadSafeQueue<LogEntry>()
    private let backgroundSenderQueue = DispatchQueue(label: "JournalBonjourSenderQueue")
    private let backgroundSenderTimer: BackgroundTimer
    private var contextStore: ContextStore?
    
    // MARK: - Lifecycle methods
    
    public init() {
        bonjourManager.connectToClient()
        backgroundSenderTimer = BackgroundTimer(timeInterval: 0.1, queue: backgroundSenderQueue)
        backgroundSenderTimer.eventHandler = { [weak self] in
            self?.sendLogEntries()
        }
        backgroundSenderTimer.resume()
    }
    
    // MARK: - Logger
    
    open func log(logEntry: LogEntry) {
        logEntryQueue.enqueue(logEntry)
    }
    
    open func setContextStore(_ contextStore: ContextStore) {
        self.contextStore = contextStore
    }
    
    // MARK: - Private helper methods
    
    private func sendLogEntries() {
        if bonjourManager.connected {
            while let logEntry = logEntryQueue.dequeue() {
                if let jsonData = try? JSONEncoder().encode(logEntry) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        bonjourManager.sendMessage(jsonString)
                    }
                }
            }
        }
    }
    
}
