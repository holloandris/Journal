//
//  JSONLogSerializer.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 03..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public class JSONLogSerializer {
    
    private let serializationQueue = DispatchQueue(label: "JournalJSONSerializationQueue")
    private let serializationFileProvider: SerializationFileProvider
    
    init(serializationFileProvider: SerializationFileProvider) {
        self.serializationFileProvider = serializationFileProvider
    }
    
    public func serialize(logEntry: LogEntry) {
        serializationQueue.async { [weak self] in
            self?.writeToFile(logEntry: logEntry)
        }
    }
    
    private func writeToFile(logEntry: LogEntry) {
        do {
            var data = try JSONEncoder().encode(logEntry)
            data.append("\n".data(using: .utf8)!)
            let filePath = try serializationFileProvider.provideFile()
            if let fileHandle = try? FileHandle(forWritingTo: filePath) {
                defer {
                    fileHandle.closeFile()
                }
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
            }
            else {
                try data.write(to: filePath, options: .atomic)
            }
        }
        catch {
            // TODO: Error handling
        }
    }

}
