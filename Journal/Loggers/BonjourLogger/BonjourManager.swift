//
//  BonjourManager.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 07..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import Foundation

open class BonjourManager: NSObject {
    
    var handleMessageArrived: ((String) -> Void)?
    var handleConnectionStatusChanged: ((String) -> Void)?
    
    var connected = false
    
    private let serviceBrowser = NetServiceBrowser()
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    private var service: NetService!
    
    // MARK: - Lifecycle methods
    
    override init() {
        super.init()
        
        serviceBrowser.delegate = self
    }
    
    // MARK: - Action methods
    
    open func connectToClient() {
        serviceBrowser.searchForServices(ofType: "_journal._tcp", inDomain: "")
    }
    
    open func sendMessage(_ message: String) {
        let data = message.data(using: .utf8)!
        _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
    }
    
    // MARK: - Private helper methods
    
    private func createSocket(forAddress address: String) {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           address as CFString,
                                           9999,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.schedule(in: .main, forMode: .common)
        outputStream.schedule(in: .main, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
    
    private func closeSocket() {
        inputStream.close()
        outputStream.close()
    }
    
}

extension BonjourManager: NetServiceBrowserDelegate {
    public func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        self.service = service
        service.delegate = self
        service.resolve(withTimeout: 30)
    }
}

extension BonjourManager: NetServiceDelegate {
    public func netServiceDidResolveAddress(_ sender: NetService) {
        if let addressData = sender.addresses?.first {
            if let addressString = convert(address: addressData) {
                createSocket(forAddress: addressString)
            }
        }
    }
    
    private func convert(address: Data) -> String? {
        var result: String?
        if address.count >= MemoryLayout<sockaddr>.stride {
            address.withUnsafeBytes { (bytes: UnsafePointer<sockaddr>) in
                let socketAddress = bytes.pointee
                if socketAddress.sa_family == AF_INET {
                    if address.count == MemoryLayout<sockaddr_in>.stride {
                        bytes.withMemoryRebound(to:sockaddr_in.self, capacity:1) { (bytes: UnsafePointer<sockaddr_in>) in
                            var addr = bytes.pointee.sin_addr
                            let size = Int(INET_ADDRSTRLEN)
                            let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: size)
                            if let cString = inet_ntop(AF_INET, &addr, buffer, socklen_t(size)) {
                                result = String(cString:cString)
                            }
                        }
                    }
                }
                if socketAddress.sa_family == AF_INET6 {
                    if address.count == MemoryLayout<sockaddr_in6>.stride {
                        bytes.withMemoryRebound(to:sockaddr_in6.self, capacity:1) { (bytes: UnsafePointer<sockaddr_in6>) in
                            var addr = bytes.pointee.sin6_addr
                            let size = Int(INET6_ADDRSTRLEN)
                            let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: size)
                            if let cString = inet_ntop(AF_INET6, &addr, buffer, socklen_t(size)) {
                                result = String(cString:cString)
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
}

extension BonjourManager: StreamDelegate {
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            internalLogDebug("New message received on socket")
        case Stream.Event.endEncountered:
            connected = false
            internalLogDebug("End signal received on socket")
        case Stream.Event.errorOccurred:
            internalLogError("Error happened on socket")
        case Stream.Event.hasSpaceAvailable:
            connected = true
            internalLogDebug("Socket has space available")
        default:
            internalLogDebug("Unknown event happened")
            break
        }
    }
}
