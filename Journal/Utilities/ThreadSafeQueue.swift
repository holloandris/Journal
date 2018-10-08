//
//  ThreadSafeQueue.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 08..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import Foundation

public class ThreadSafeQueue<T> {
    
    // MARK: - Private properties
    
    private var array = Array<T>()
    private let queue = DispatchQueue(label: "ThreadSafeQueueSynchronizationQueue")
    
    // MARK: - Public properties
    
    public var isEmpty: Bool {
        var result = false
        queue.sync {
            result = array.isEmpty
        }
        return result
    }
    
    // MARK: - Action methods
    
    public func enqueue(_ element: T) {
        queue.async { [weak self] in
            self?.array.append(element)
        }
    }
    
    public func dequeue() -> T? {
        var result: T?
        queue.sync {
            guard !array.isEmpty, let element = array.first else { return }
            result = element
            array.remove(at: 0)
        }
        return result
    }
    
    public func peek() -> T? {
        var result: T?
        queue.sync {
            result = array.first
        }
        return result
    }
    
}
