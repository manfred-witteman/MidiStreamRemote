import Foundation
import Network

class BonjourClient: NSObject, ObservableObject, NetServiceDelegate, NetServiceBrowserDelegate {
    @Published var services: [NetService] = []
    private var netServiceBrowser: NetServiceBrowser?
    private var connection: NWConnection?
    private var isConnected = false  // Track connection state

    // Start browsing for services
    func startBrowsing() {
        netServiceBrowser = NetServiceBrowser()
        netServiceBrowser?.delegate = self // Set the delegate
        netServiceBrowser?.searchForServices(ofType: "_myapp._tcp.", inDomain: "")
        print("Started browsing for services...")
    }

    // Stop browsing for services
    func stopBrowsing() {
        netServiceBrowser?.stop()
        netServiceBrowser = nil
        disconnect()  // Optionally disconnect when stopping browsing
        print("Stopped browsing for services.")
    }

    // NetServiceBrowserDelegate methods
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self // Set the service delegate
        services.append(service)
        print("Found service: \(service.name)")
        service.resolve(withTimeout: 5.0) // Attempt to resolve the service
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        services.removeAll { $0.name == service.name }
        print("Removed service: \(service.name)")
    }

    // NetServiceDelegate methods
    func netServiceDidResolveAddress(_ sender: NetService) {
        print("Resolved service: \(sender)")
        guard let addresses = sender.addresses else {
            print("No addresses resolved for service: \(sender.name)")
            return
        }

        // Assuming you want to connect to the first resolved address
        if let address = addresses.first {
            let ipAddress = address.withUnsafeBytes {
                ($0.baseAddress?.assumingMemoryBound(to: sockaddr_in.self).pointee.sin_addr).map { String(cString: inet_ntoa($0)) }
            }

            // Ensure valid IP Address before connecting
            if let ipAddress = ipAddress, ipAddress != "127.0.0.1" && ipAddress != "0.0.0.0" {
                let port: UInt16 = 8080 // Ensure this matches the service's port
                connectToService(at: ipAddress, port: port)
            } else {
                print("Invalid address resolved: \(ipAddress ?? ""). Cannot connect.")
            }
        }
    }

    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {
        print("Failed to resolve service \(sender.name): \(errorDict)")
    }

    private func connectToService(at host: String, port: UInt16) {
        disconnect() // Ensure previous connection is terminated
        connection = NWConnection(host: NWEndpoint.Host(host), port: NWEndpoint.Port(rawValue: port)!, using: .tcp)

        connection?.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                print("Connected to \(host) on port \(port)")
                self?.isConnected = true
                self?.receiveMessages()
            case .failed(let error):
                print("Connection failed: \(error)")
                self?.isConnected = false
            case .waiting:
                print("Connection is waiting")
            case .cancelled:
                print("Connection cancelled")
                self?.isConnected = false
            default:
                break
            }
        }

        // Start the connection
        connection?.start(queue: .main)
    }

    private func receiveMessages() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024) { [weak self] data, context, isComplete, error in
            if let data = data {
                let message = String(data: data, encoding: .utf8) ?? "Unknown message"
                print("Received: \(message)")
            }
            if isComplete {
                print("Connection closed")
                self?.disconnect() // Optionally disconnect on completion
            } else {
                self?.receiveMessages() // Continue receiving messages
            }
        }
    }

    private func disconnect() {
        connection?.cancel()
        connection = nil
        isConnected = false
        print("Disconnected from service")
    }

    func sendMessage(_ message: String) {
        guard isConnected else {
            print("Not connected to a service, unable to send message.")
            return
        }

        let data = message.data(using: .utf8)
        connection?.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                print("Failed to send message: \(error)")
            } else {
                print("Message sent: \(message)")
            }
        })
    }
}
