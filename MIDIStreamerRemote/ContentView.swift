import SwiftUI

struct ContentView: View {
    @ObservedObject var bonjourClient = BonjourClient()

    var body: some View {
        NavigationView {
            List(bonjourClient.commands) { command in
                Button(action: {
                    print("Button tapped for command: \(command.name)")
                    sendCommand(command) // Send the entire command object
                }) {
                    Text(command.name) // Display the command name
                }
            }
            .navigationTitle("OBS Commands")
            .onAppear {
                bonjourClient.startBrowsing()
            }
            .onDisappear {
                bonjourClient.stopBrowsing()
            }
        }
    }
    
    // Function to send the entire OBSCommand object
    func sendCommand(_ command: OBSCommand) {
        bonjourClient.sendCommand(command) // Send the command object using BonjourClient
    }
}
