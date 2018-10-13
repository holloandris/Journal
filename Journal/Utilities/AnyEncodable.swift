//
//  AnyEncodable.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 15..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

// Type erasure
public struct AnyEncodable: Encodable, CustomStringConvertible {
    
    private let value: Encodable
    
    // MARK: - Lifecycle methods
    
    public init(value: Encodable) {
        self.value = value
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        return "\(value)"
    }
    
}
