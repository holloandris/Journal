//
//  Socket.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 08..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

protocol SocketDelegate: AnyObject {
    func socketDidConnect()
    func socketDidDisconnect()
    func socket(didReceiveMessage: String)
}

class Socket: NSObject, StreamDelegate {
    
    weak var delegate: SocketDelegate?
    
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    private var connected = false
    private var socketConnectionHandler: DispatchSourceRead!
    
    // MARK: - Connection methods
    
    func open(withPort port: Int) {
        let socketFD = socket(AF_INET, SOCK_STREAM, 0)
        var value: Int32 = 1
        setsockopt(socketFD, SOL_SOCKET, SO_REUSEADDR, &value, socklen_t(MemoryLayout<Int32>.stride))
        var address = createAnyAddress(withPort: port)
        _ = withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.bind(socketFD, $0, socklen_t(MemoryLayout<sockaddr>.stride))
            }
        }
        listen(socketFD, SOMAXCONN)
        socketConnectionHandler = DispatchSource.makeReadSource(fileDescriptor: socketFD, queue: DispatchQueue.global(qos: .default))
        socketConnectionHandler.setEventHandler { [weak self] in
            self?.handleConnection(forSocket: socketFD)
        }
        socketConnectionHandler.resume()
    }
    
    func open(withAddress address: String, port: Int) {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           address as CFString,
                                           UInt32(port),
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
        
        inputStream = nil
        outputStream = nil
    }
    
    // MARK: - Communication methods
    
    func sendMessage(_ message: String) {
        if connected {
            let data = message.data(using: .utf8)!
            _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
        }
    }
    
    // MARK: - StreamDelegate
    
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            internalLogDebug("Socket has bytes available")
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            internalLogDebug("End signal received on socket")
            connected = false
            delegate?.socketDidDisconnect()
        case Stream.Event.errorOccurred:
            internalLogError("Error happened on socket")
            connected = false
            delegate?.socketDidDisconnect()
        case Stream.Event.hasSpaceAvailable:
            internalLogDebug("Socket has space available")
            if !connected {
                connected = true
                delegate?.socketDidConnect()
            }
        default:
            internalLogDebug("Unknown event happened")
            break
        }
    }
    
    // MARK: - Private helper methods
    
    private func handleConnection(forSocket socket: Int32) {
        var address = sockaddr()
        var length = socklen_t(MemoryLayout<sockaddr>.stride)
        let childSocketFD = accept(socket, &address, &length)
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, childSocketFD, &readStream, &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.schedule(in: .main, forMode: .common)
        outputStream.schedule(in: .main, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: bufferSize)
            
            if numberOfBytesRead < 0 {
                if let _ = stream.streamError {
                    break
                }
            }
            
            if let message = String(bytesNoCopy: buffer,
                                    length: numberOfBytesRead,
                                    encoding: .utf8,
                                    freeWhenDone: true) {
                delegate?.socket(didReceiveMessage: message)
            }
        }
    }
    
    private func createAnyAddress(withPort port: Int) -> sockaddr_in {
        var addr = sockaddr_in()
        
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(port).bigEndian
        addr.sin_addr.s_addr = in_addr_t(INADDR_ANY).bigEndian
        
        return addr
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
