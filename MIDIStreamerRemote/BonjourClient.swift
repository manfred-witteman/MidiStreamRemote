import Foundation
import Network

class BonjourClient: NSObject, ObservableObject, NetServiceDelegate, NetServiceBrowserDelegate {
    @Published var services: [NetService] = []
    private var netServiceBrowser: NetServiceBrowser?
    private var connection: NWConnection?
    private var isConnected = false
    private var buffer = Data()
    private var receivedData = Data()
    
    @Published var commands: [OBSCommand] = []

    private let maxRetries = 3 // Maximum number of retry attempts
    private var currentRetries = 0 // Track the current retry count

    // Start browsing for services
    func startBrowsing() {
        netServiceBrowser = NetServiceBrowser()
        netServiceBrowser?.delegate = self
        netServiceBrowser?.searchForServices(ofType: "_myapp._tcp.", inDomain: "")
        print("Started browsing for services...")
    }

    // Stop browsing for services
    func stopBrowsing() {
        netServiceBrowser?.stop()
        netServiceBrowser = nil
        disconnect()
        print("Stopped browsing for services.")
    }

    // NetServiceBrowserDelegate methods
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        services.append(service)
        print("Found service: \(service.name)")
        service.resolve(withTimeout: 5.0)
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

        if let address = addresses.first {
            let ipAddress = address.withUnsafeBytes {
                ($0.baseAddress?.assumingMemoryBound(to: sockaddr_in.self).pointee.sin_addr).map { String(cString: inet_ntoa($0)) }
            }

            if let ipAddress = ipAddress, ipAddress != "127.0.0.1" && ipAddress != "0.0.0.0" {
                let port: UInt16 = 8080
                connectToService(at: ipAddress, port: port)
            } else {
                print("Invalid address resolved: \(ipAddress ?? ""). Cannot connect.")
            }
        }
    }

    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {
        print("Failed to resolve service \(sender.name): \(errorDict)")
    }

    private func receiveMessages() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024) { [weak self] data, context, isComplete, error in
            guard let self = self else { return }

            if let data = data {
                print("Received raw data: \(data.count) bytes")
                self.receivedData.append(data)

                if let message = String(data: data, encoding: .utf8) {
                    print("Received chunk: \(message)")
                }

                if let jsonString = String(data: self.receivedData, encoding: .utf8),
                   jsonString.trimmingCharacters(in: .whitespacesAndNewlines).hasSuffix("]") {
                    self.decodeReceivedData()
                }
            }

            if isComplete {
                print("Connection closed")
                self.disconnect()
            } else if error != nil {
                print("Error receiving data: \(error!)")
                self.disconnect()
            } else {
                self.receiveMessages()
            }
        }
    }

    private func decodeReceivedData() {
        do {
            let decodedCommands = try JSONDecoder().decode([OBSCommand].self, from: receivedData)
            DispatchQueue.main.async {
                self.commands = decodedCommands
                print("Successfully decoded commands: \(self.commands)")
            }
        } catch {
            print("Failed to decode received data: \(error)")
        }
        
        receivedData = Data()
    }

    private func disconnect() {
        if let connection = connection {
            connection.cancel()
            print("Disconnected from service")
        }
        self.connection = nil
        self.isConnected = false
    }

    private func connectToService(at host: String, port: UInt16) {
        disconnect()
        connection = NWConnection(host: NWEndpoint.Host(host), port: NWEndpoint.Port(rawValue: port)!, using: .tcp)

        connection?.stateUpdateHandler = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .ready:
                print("Connected to \(host) on port \(port)")
                self.isConnected = true
                self.currentRetries = 0 // Reset retry count on successful connection
                self.receiveMessages()
            case .failed(let error):
                print("Connection failed: \(error)")
                self.isConnected = false
                self.retryConnection() // Retry connecting
            case .waiting:
                print("Connection is waiting")
            case .cancelled:
                print("Connection cancelled")
                self.isConnected = false
            default:
                break
            }
        }

        connection?.start(queue: .main)
    }

    private func retryConnection() {
        if currentRetries < maxRetries {
            currentRetries += 1
            print("Retrying connection (\(currentRetries)/\(maxRetries))...")
            
            // Attempt to reconnect to the first available service in the list
            if let service = services.first {
                // Resolve the service again and connect
                service.resolve(withTimeout: 5.0)
            } else {
                print("No services available to retry connection.")
            }
        } else {
            print("Max retries reached. Unable to connect.")
            currentRetries = 0 // Reset retry counter for future connection attempts
        }
    }

    func sendCommand(_ command: OBSCommand) {
        guard isConnected else {
            print("Not connected to a service, retrying to connect...")
            retryConnection()
            return
        }

        do {
            let data = try JSONEncoder().encode(command)
            connection?.send(content: data, completion: .contentProcessed { error in
                if let error = error {
                    print("Failed to send command: \(error)")
                } else {
                    print("Command sent: \(command)")
                }
            })
        } catch {
            print("Failed to encode command to JSON: \(error)")
        }
    }

    func sendMessage(_ message: String) {
        guard isConnected else {
            print("Not connected to a service, retrying to connect...")
            retryConnection()
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
