import SwiftUI

struct ContentView: View {
    @StateObject private var bonjourClient = BonjourClient()
    @State private var messageToSend = ""

    var body: some View {
        VStack {
            NavigationView {
                List(bonjourClient.services, id: \.name) { service in
                    VStack(alignment: .leading) {
                        Text(service.name)
                        Text(service.type)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        bonjourClient.connectToService(service) // Connect to the service when tapped
                    }
                }
                .navigationTitle("Bonjour Services")
                .onAppear {
                    bonjourClient.startBrowsing()
                }
                .onDisappear {
                    bonjourClient.stopBrowsing()
                }
            }
            TextField("Enter message", text: $messageToSend)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Send Message") {
                bonjourClient.sendMessage(messageToSend)
                messageToSend = "" // Clear the input field after sending
            }
            .padding()
        }
    }
}

extension BonjourClient {
    func connectToService(_ service: NetService) {
        service.resolve(withTimeout: 5.0)
        // Setting the delegate should already happen in didFind service
    }
}
