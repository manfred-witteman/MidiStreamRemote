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
                                VStack {
                                    Spacer() // Add a spacer to push the content down

                                    // Display the icon as an SF Symbol
                                    if let iconName = command.icon {
                                        Image(systemName: iconName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50) // Make the icon larger
                                            .foregroundColor(.white)
                                    }

                                    // Add some padding between the icon and the text
                                    Spacer(minLength: 10)

                                    Text(command.name)
                                        .frame(maxWidth: buttonSize - 10) // Limit the width to force text wrapping
                                        .foregroundColor(.white)
                                        .font(.caption) // Use a smaller font size
                                        .lineLimit(2) // Allow up to 2 lines before truncating
                                        .multilineTextAlignment(.center) // Center the text
                                    
                                    Spacer() // Add a spacer below to improve centering
                                }
                                .padding() // Add padding around the content
                                .frame(width: buttonSize, height: buttonSize)
                                .background(setColor(type: command.controllerType))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding() // Add padding around the grid
                }
            }
            .navigationTitle("OBS Commands")
            .onAppear {
                bonjourClient.startBrowsing()
                // Add observers for app lifecycle notifications
                NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                    bonjourClient.startBrowsing()
                }
                
                NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                    bonjourClient.startBrowsing()
                }
            }
            .onDisappear {
                bonjourClient.stopBrowsing()
                // Remove observers when the view disappears
                NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
                NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
            }
        }
    }
    
    // Function to send the entire OBSCommand object
    func sendCommand(_ command: OBSCommand) {
        bonjourClient.sendCommand(command) // Send the command object using BonjourClient
    }
    
    func setColor(type: ControllerType) -> Color {
        switch type {
        case .none:
            return .red
        case .absolute:
            return .green
        case .relative:
            return .blue
        default:
            return .black
        }
    }
}
