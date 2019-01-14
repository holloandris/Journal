//
//  LogzIOLogger.swift
//  Journal
//
//  Created by Andras Hollo on 2019. 01. 12..
//  Copyright © 2019. Andras Hollo. All rights reserved.
//

open class LogzIOLogger: Logger {

    private let endpoint: String
    private let token: String
    private let type: String
    private var logEntryQueue = ThreadSafeQueue<LogEntry>()
    private let backgroundSenderQueue = DispatchQueue(label: "JournalLogzIOSenderQueue")
    private let backgroundSenderTimer: BackgroundTimer
    
    // MARK: - Lifecycle methods
    
    public init(endpoint: String, token: String, type: String) {
        self.endpoint = endpoint
        self.token = token
        self.type = type
        backgroundSenderTimer = BackgroundTimer(timeInterval: 10.0, queue: backgroundSenderQueue)
        backgroundSenderTimer.eventHandler = { [weak self] in
            self?.sendLogEntries()
        }
        backgroundSenderTimer.resume()
    }
    
    // MARK: - Logger
    
    open func log(logEntry: LogEntry) {
        logEntryQueue.enqueue(logEntry)
    }

    // MARK: - Private helper methods
    
    private func sendLogEntries() {
        while let logEntry = logEntryQueue.dequeue() {
            if let jsonData = try? JSONEncoder().encode(logEntry) {
                let url = URL(string: String(format: "%@?token=%@&type=%@", endpoint, token, type))!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                    if let error = error {
                        internalLogError("Failed to upload json file to logz.io", error: error)
                        return
                    }
                    guard let response = response as? HTTPURLResponse,
                        (200...299).contains(response.statusCode) else {
                        if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                            internalLogError("Failed to upload json file to logz.io: \(json)")
                        } else {
                            internalLogError("Failed to upload json file to logz.io")
                        }
                        return
                    }
                    if let mimeType = response.mimeType,
                        mimeType == "application/json",
                        let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        internalLogDebug("Received response from logz.io: \(json)")
                    }
                }
                task.resume()
            }
        }
    }
    
}
