//
//  JSONLogSerializer.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

open class JSONLogSerializer {
    
    private let serializationQueue = DispatchQueue(label: "JournalJSONSerializationQueue")
    private let serializationFileProvider: SerializationFileProvider
    
    init(serializationFileProvider: SerializationFileProvider) {
        self.serializationFileProvider = serializationFileProvider
    }
    
    open func serialize(logEntry: LogEntry) {
        serializationQueue.async { [weak self] in
            self?.writeToFile(logEntry: logEntry)
        }
    }
    
    private func writeToFile(logEntry: LogEntry) {
        do {
            var data = try JSONEncoder().encode(logEntry)
            data.append("\n".data(using: .utf8)!)
            let fileURL = try serializationFileProvider.provideFileURL()
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                defer {
                    fileHandle.closeFile()
                }
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
            }
            else {
                try data.write(to: fileURL, options: .atomic)
            }
        }
        catch {
            // TODO: Error handling
        }
    }

}
