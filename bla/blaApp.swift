import SwiftUI

@main
struct blaApp: App {
    @StateObject private var sceneStore = SceneStore()  // Initialize the SceneStore
    @StateObject private var bonjourClient: BonjourClient  // Declare the BonjourClient
    
    @State private var showServiceDialog = true
    
    // Initialize bonjourClient with the sceneStore
    init() {
        let store = SceneStore()
        _sceneStore = StateObject(wrappedValue: store)  // Initialize the SceneStore here
        _bonjourClient = StateObject(wrappedValue: BonjourClient(sceneStore: store))  // Pass sceneStore to BonjourClient
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()  // ContentView will have access to bonjourClient via the environment
                .onAppear {
                    bonjourClient.startBrowsing()  // Start browsing when ContentView appears
                }
//                .sheet(isPresented: $showServiceDialog) {
//                    // Show the service selection dialog if needed
//                    ServiceSelectionDialog(bonjourClient: bonjourClient, isPresented: $showServiceDialog)
//                }
                .environmentObject(bonjourClient)  // Inject bonjourClient into the environment
                .environmentObject(sceneStore)
        }
    }
}
