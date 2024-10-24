import SwiftUI

struct ContentView: View {
    @ObservedObject var bonjourClient = BonjourClient()

    var body: some View {
        NavigationView {
            List(bonjourClient.commands) { command in
                Button(action: {
                    // Handle button action for each command
                    print("Button tapped for command: \(command.name)")
                    // You can send a message or trigger an action here based on the command
                }) {
                    Text(command.name) // Display the command name
                }
            }
            .navigationTitle("OBS Commands")
            .onAppear {
                // Start browsing for services
                bonjourClient.startBrowsing()
            }
            .onDisappear {
                // Stop browsing for services
                bonjourClient.stopBrowsing()
            }
        }
    }
}
