//
//  BonjourManager.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 07..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import Foundation

class BonjourManager: BonjourBrowserDelegate, SocketDelegate {
    
    var handleMessageArrived: ((String) -> Void)?
    var handleConnectionStatusChanged: ((String) -> Void)?
    
    var connected = false
    
    private let bonjourBrowser = BonjourBrowser()
    private let socket = Socket()
    
    // MARK: - Lifecycle methods
    
    init() {
        bonjourBrowser.delegate = self
        socket.delegate = self
    }
    
    // MARK: - Action methods
    
    func connectToClient() {
        bonjourBrowser.connectToClient()
    }
    
    func sendMessage(_ message: String) {
        socket.sendMessage(message)
    }
    
    // MARK: - BonjourBrowserDelegate
    
    func bonjourBrowser(didFindServiceWithAddress address: String) {
        socket.open(withAddress: address, port: 9999)
    }
    
    // MARK: - SocketDelegate
    
    func socketDidConnect() {
        connected = true
    }
    
    func socketDidDisconnect() {
        connected = false
    }
    
    func socket(didReceiveMessage message: String) {
        
    }
    
}
