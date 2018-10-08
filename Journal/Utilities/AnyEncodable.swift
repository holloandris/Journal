//
//  AnyEncodable.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 09. 15..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import UIKit

// Type erasure
public struct AnyEncodable: Encodable {
    private let value: Encodable
    public init(value: Encodable) {
        self.value = value
    }
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
