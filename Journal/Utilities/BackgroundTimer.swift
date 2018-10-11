//
//  BackgroundTimer.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 08..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

class BackgroundTimer {
    
    // MARK: - Public properties
    
    var eventHandler: (() -> Void)?
    
    // MARK: - Private properties
    
    private let timeInterval: TimeInterval
    private let queue: DispatchQueue
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource(queue: self.queue)
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    private enum State {
        case suspended
        case resumed
    }
    private var state: State = .suspended
    
    // MARK: - Lifecycle methods
    
    init(timeInterval: TimeInterval, queue: DispatchQueue) {
        self.timeInterval = timeInterval
        self.queue = queue
    }
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here
         https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
    
    // MARK: - Action methods
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    
}
