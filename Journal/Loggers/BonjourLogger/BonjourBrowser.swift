//
//  BonjourBrowser.swift
//  Journal
//
//  Created by Andras Hollo on 2018. 10. 08..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

protocol BonjourBrowserDelegate: AnyObject {
    func bonjourBrowser(didFindServiceWithAddress: String)
}

class BonjourBrowser: NSObject, NetServiceBrowserDelegate, NetServiceDelegate {
    
    private let serviceBrowser = NetServiceBrowser()
    private var service: NetService!
    
    weak var delegate: BonjourBrowserDelegate?
    
    // MARK: - Lifecycle methods
    
    override init() {
        super.init()
        
        serviceBrowser.delegate = self
    }
    
    // MARK: - Action methods
    
    open func connectToClient() {
        serviceBrowser.searchForServices(ofType: "_journal._tcp", inDomain: "")
    }
    
    // MARK: - NetServiceBrowserDelegate
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        self.service = service
        service.delegate = self
        service.resolve(withTimeout: 30)
    }
    
    // MARK: - NetServiceDelegate
    
    public func netServiceDidResolveAddress(_ sender: NetService) {
        if let addressData = sender.addresses?.first {
            if let addressString = convert(address: addressData) {
                delegate?.bonjourBrowser(didFindServiceWithAddress: addressString)
            }
        }
    }
    
    // MARK: - Private helper methods
    
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
