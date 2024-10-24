//
//  ServiceDelegate.swift
//  MIDIStreamerRemote
//
//  Created by manfred on 24/10/2024.
//


import Foundation

class ServiceDelegate: NSObject, NetServiceDelegate {
//    func netServiceDidResolveAddress(_ sender: NetService) {
//        guard let addresses = sender.addresses else { return }
//        for address in addresses {
//            // Extract the IP address or handle as needed
//            if let sockaddr = address.withUnsafeBytes({ $0.baseAddress?.assumingMemoryBound(to: sockaddr_in.self) }) {
//                let ipAddress = sockaddr.pointee.sin_addr
//                let addressString = String(cString: inet_ntoa(ipAddress))
//                print("Resolved address: \(addressString)")
//            }
//        }
//    }

    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("Failed to resolve service: \(errorDict)")
    }
}
