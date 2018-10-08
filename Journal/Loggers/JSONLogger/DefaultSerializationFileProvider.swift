//
//  DefaultSerializationFileProvider.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 15..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

public enum DefaultSerializationFileProviderError: Error {
    case fileError
}

open class DefaultSerializationFileProvider: SerializationFileProvider {
    
    open func provideFileURL() throws -> URL {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filename = generateFilename()
            return documentDirectory.appendingPathComponent("journal_logs").appendingPathComponent(filename)
        } else {
            throw DefaultSerializationFileProviderError.fileError
        }
    }
    
    private func generateFilename() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm"
        let dateString = formatter.string(from: Date())
        return String(format: "log_%s.log", dateString)
    }
    
}
