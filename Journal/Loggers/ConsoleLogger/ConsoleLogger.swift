//
//  ConsoleLogger.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 10..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class ConsoleLogger: Logger {
    
    private var contextStore: ContextStore?
    
    var format: String = "{Time} {Level} {Class} {Message}"
    
    // MARK: - Lifecycle methods
    
    public init() {
        
    }
    
    // MARK: - Logger
    
    open func log(logEntry: LogEntry) {
        print(replacePlaceholders(logEntry: logEntry))
    }
    
    open func setContextStore(_ contextStore: ContextStore) {
        self.contextStore = contextStore
    }
    
    // MARK: - Private helper methods
    
    private func replacePlaceholders(logEntry: LogEntry) -> String {
        let regex = try! NSRegularExpression(pattern: "\\{\\w+\\}", options: [])
        var formatNSString = (format as NSString)
        
        var fullRange = NSMakeRange(0, formatNSString.length)
        while regex.numberOfMatches(in: formatNSString as String, options: [], range: fullRange) > 0 {
            var firstChangeFlag = false
            regex.enumerateMatches(in: formatNSString as String,
                                   options: [],
                                   range: fullRange) { (result, _, _) in
                                    if (!firstChangeFlag) {
                                        firstChangeFlag = true
                                        let range = NSMakeRange(result!.range.location+1, result!.range.length-2)
                                        let match = formatNSString.substring(with: range)
                                        var value = ""
                                        if match == "Message" {
                                            value = logEntry.message
                                        } else if match == "Level" {
                                            value = logEntry.level.rawValue.uppercased()
                                        } else {
                                            if let anyValue = logEntry.details[match] {
                                                value = String(describing: anyValue)
                                                /*do {
                                                    let jsonData = try JSONEncoder().encode(anyValue)
                                                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                                                        value = jsonString
                                                    }
                                                } catch {
                                                    internalLogError("Failed to JSON encode the value during console logging: \(error)")
                                                }*/
                                            }
                                        }
                                        formatNSString = formatNSString.replacingCharacters(in: result!.range, with: value) as NSString
                                    }
            }
            fullRange = NSMakeRange(0, formatNSString.length)
        }
        
        return formatNSString as String
    }
    
}
