import SwiftUI

struct ContentView: View {
    @ObservedObject var bonjourClient = BonjourClient()

    // Define the grid layout with 3 columns
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                GeometryReader { geometry in
                    let buttonSize = (geometry.size.width / 3) - 20 // Calculate size for 3 buttons with spacing

                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(bonjourClient.commands) { command in
                            Button(action: {
                                print("Button tapped for command: \(command.name)")
                                sendCommand(command) // Send the entire command object
                            }) {
                                Text(command.name)
                                    .frame(width: buttonSize, height: buttonSize) // Set both width and height to buttonSize
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .font(.headline)
                            }
                        }
                    }
                    .padding() // Add padding around the grid
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
