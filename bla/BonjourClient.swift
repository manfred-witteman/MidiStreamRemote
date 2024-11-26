import Foundation
import Network

class BonjourClient: NSObject, ObservableObject, NetServiceDelegate, NetServiceBrowserDelegate {
    
    private var sceneStore: SceneStore
    init(sceneStore: SceneStore) {
        self.sceneStore = sceneStore
    }
    
    @Published var services: [NetService] = []
    @Published var isRecording: Bool = false
    @Published var virtualCameraActive: Bool = false
    
    
    @Published var isUserConnecting: Bool = true //false
    
    private var netServiceBrowser: NetServiceBrowser?
    private var connection: NWConnection?
    private var isConnected = false
    private var buffer = Data()
    
    private let maxRetries = 3 // Maximum retry attempts
    private var currentRetries = 0 // Current retry count
    
    
    
    
    
    
    // Start browsing for services
    func startBrowsing() {
        stopBrowsing() // Ensure no duplicate browsers are running
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
    
    // NetServiceBrowserDelegate: Found service
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        services.append(service)
        print("Found service: \(service.name)")
        service.resolve(withTimeout: 5.0) // Try resolving immediately
    }
    
    // NetServiceBrowserDelegate: Removed service
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        services.removeAll { $0.name == service.name }
        print("Removed service: \(service.name)")
    }
    
    // NetServiceDelegate: Service resolved successfully
    func netServiceDidResolveAddress(_ sender: NetService) {
        guard let addresses = sender.addresses,
              let addressData = addresses.first,
              let host = addressData.toHostString() else {
            print("Failed to resolve service: \(sender.name). No valid address found.")
            return
        }
        let port = UInt16(sender.port)
        print("Resolved service: \(sender.name) at \(host):\(port)")
        
        // Only connect if the user initiated the connection
        if isUserConnecting {
            connectToService(at: host, port: port)
            isUserConnecting = false // Reset the flag
        } else {
            print("Service resolved automatically, waiting for user to connect.")
        }
    }
    
    // NetServiceDelegate: Failed to resolve service
    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {
        print("Failed to resolve service \(sender.name): \(errorDict)")
    }
    
    // Establish connection to a service
    private func connectToService(at host: String, port: UInt16) {
        disconnect() // Clean up previous connections
        connection = NWConnection(host: NWEndpoint.Host(host), port: NWEndpoint.Port(rawValue: port)!, using: .tcp)
        
        connection?.stateUpdateHandler = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .ready:
                print("Connected to \(host):\(port)")
                self.isConnected = true
                self.currentRetries = 0 // Reset retries
                self.receiveMessages()
            case .failed(let error):
                print("Connection failed: \(error.localizedDescription)")
                self.retryConnection()
            case .waiting:
                print("Connection is waiting.")
            case .cancelled:
                print("Connection cancelled.")
                self.isConnected = false
            default:
                break
            }
        }
        
        connection?.start(queue: .main)
    }
    
    // Disconnect from the current connection
    private func disconnect() {
        connection?.cancel()
        connection = nil
        isConnected = false
        print("Disconnected from service.")
    }
    
    func connectToService(_ service: NetService) {
        isUserConnecting = true // Set flag before resolving service
        service.resolve(withTimeout: 5.0)
    }
    
    // Retry connecting to the first available service
    private func retryConnection() {
        if currentRetries < maxRetries {
            currentRetries += 1
            print("Retrying connection (\(currentRetries)/\(maxRetries))...")
            if let service = services.first {
                service.resolve(withTimeout: 5.0)
            } else {
                print("No services available to retry connection.")
            }
        } else {
            print("Max retries reached. Unable to connect.")
            currentRetries = 0 // Reset retry counter for future attempts
        }
    }
    
    // Send a message to the connected service
    func sendMessage(_ jsonObject: [String: Any]) {
        guard isConnected else {
            print("Not connected to a service. Retrying connection...")
            retryConnection()
            return
        }
        
        // Convert the JSON object into Data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            
            // Send the data over the connection
            connection?.send(content: jsonData, completion: .contentProcessed { error in
                if let error = error {
                    print("Failed to send message: \(error.localizedDescription)")
                } else {
                    print("Message sent: \(jsonObject)")
                }
            })
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
        }
    }
    
    // Receive and process incoming messages
    private func receiveMessages() {
        connection?.receive(minimumIncompleteLength: 0, maximumLength: 8192) { [weak self] data, context, isComplete, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error receiving data: \(error.localizedDescription)")
                self.disconnect()
                return
            }
            
            if let data = data {
                self.buffer.append(data)
                self.processBuffer()
            }
            
            if isComplete {
                print("Connection closed by the remote service.")
                self.disconnect()
            } else {
                self.receiveMessages()
            }
        }
    }
    
    // Process buffered data using newline as the message delimiter
    
    private func processBuffer() {
        do {
            // Try to deserialize the messageData into a JSON object
            if let jsonObject = try JSONSerialization.jsonObject(with: buffer, options: []) as? [String: Any] {
                print("Received JSON object: \(jsonObject)")
                processJSONData(jsonObject)
            } else {
                print("Received data is not a valid JSON object.")
            }
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
        }
    }
    
    func processJSONData(_ jsonObject: [String: Any]) {
        // Extract the type from the JSON object
        if let type = jsonObject["type"] as? String {
            switch type {
            case "overview":
                handleOverviewType(jsonObject)
            case "anotherType":  // Example: Handle another type of response
                handleAnotherType(jsonObject)
            default:
                print("Unknown type: \(type)")
            }
        } else {
            print("No 'type' found in the JSON object.")
        }
    }
    
    // Function to handle the 'overview' type
    func handleOverviewType(_ jsonObject: [String: Any]) {
        // Extract the 'data' key, which is an array of scenes
        if let scenes = jsonObject["data"] as? [[String: Any]] {
            var apiResponses: [APIResponse] = []
            
            for scene in scenes {
                // Extract scene data
                if let sceneName = scene["sceneName"] as? String,
                   let sceneIndex = scene["sceneIndex"] as? Int, let sceneOrder = scene["sceneOrder"] as? Int{
                    
                    
                    var sceneItems: [SceneItem] = []
                    
                    // Extract sources (an array of source data)
                    if let sources = scene["sources"] as? [[String: Any]] {
                        print("Found sources: \(sources)")  // Debugging line to check sources content
                        
                        for source in sources {
                            print("Parsing source: \(source)")  // Debugging line to check each source
                            
                            // Explicitly print each key-value pair for debugging
                            for (key, value) in source {
                                print("Key: \(key), Value: \(value)")  // Print the key and its value to understand the data structure
                            }
                            
                            // Safe unwrapping of the source's properties
                            if let sourceId = source["id"] as? Int,
                               let sourceName = source["sourceName"] as? String,
                               let inputKind = source["inputKind"] as? String,
                               let sceneItemEnabled = source["sceneItemEnabled"] as? Int,
                               let level = source["level"] as? Double {
                                
                                // Create a SceneItem with safe unwrapped values
                                let sceneItem = SceneItem(
                                    id: sourceId,
                                    sourceName: sourceName,
                                    inputKind: inputKind,
                                    sceneItemEnabled: sceneItemEnabled == 1,  // Convert 1/0 to Bool
                                    level: level
                                )
                                
                                sceneItems.append(sceneItem)
                            } else {
                                // Print the source that failed to parse
                                print("Failed to decode source, missing or incorrect keys: \(source)")
                            }
                        }
                    } else {
                        print("No sources found in scene: \(scene)")  // Debugging line if sources is nil or empty
                    }
                    
                    // Create an APIResponse object for this scene
                    let apiResponse = APIResponse(sceneIndex: sceneIndex,
                                                  sceneOrder: sceneOrder,
                                                  sceneName: sceneName,
                                                  sources: sceneItems)
                    apiResponses.append(apiResponse)
                } else {
                    print("Failed to decode scene data: \(scene)")  // Debugging line for missing sceneName or sceneIndex
                }
            }
            
            // Now `apiResponses` contains all the parsed APIResponse objects
            print("Parsed API responses: \(apiResponses)")
            
            // Update the scene store with the newly parsed data
            sceneStore.updateSceneData(apiResponses)
            
        } else {
            print("'data' is missing or not an array in the 'overview' type JSON.")
        }
    }
    
    
    // Call this method when data is received from the server
    func didReceiveData(_ jsonData: Data) {
        sceneStore.loadData(from: jsonData)
    }
    
    // Function to handle another type of response (just as an example)
    func handleAnotherType(_ jsonObject: [String: Any]) {
        // Handle a different type of response (this can be extended based on your use case)
        print("Handling another type of JSON response")
    }
    
    
    
    
    
    
}


// Helper extension to extract host string from sockaddr data
private extension Data {
    func toHostString() -> String? {
        return withUnsafeBytes {
            guard let sockaddr = $0.baseAddress?.assumingMemoryBound(to: sockaddr.self) else { return nil }
            if sockaddr.pointee.sa_family == sa_family_t(AF_INET) {
                var addr = sockaddr.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { $0.pointee }
                return String(cString: inet_ntoa(addr.sin_addr))
            } else if sockaddr.pointee.sa_family == sa_family_t(AF_INET6) {
                var addr = sockaddr.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) { $0.pointee }
                var buffer = [CChar](repeating: 0, count: Int(INET6_ADDRSTRLEN))
                return buffer.withUnsafeMutableBufferPointer {
                    inet_ntop(AF_INET6, &addr.sin6_addr, $0.baseAddress, socklen_t($0.count))
                }.flatMap { String(cString: $0) }
            }
            return nil
        }
    }
}
