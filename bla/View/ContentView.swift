import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sceneStore: SceneStore
    
    @State private var previousSceneSources: [SceneItem] = []
    @State private var showOverlay: Bool = false
    @State private var currentSceneIndex: Int = 0
    @State private var selectedSource: SceneItem? = nil
    
    @State private var sceneName: String = "Scene 1"
    @EnvironmentObject var bonjourClient: BonjourClient // Access from the environment
    
   
    
    
    // Load "Scene 1" directly as the initial data
    @State private var sceneSources: [SceneItem] = []//MockScenes.sceneList[0].sources
    
    @State private var isRecording: Bool = false
    @State private var redOpacity: Double = 0.0
    
    var body: some View {
        NavigationView {
            
            GeometryReader { geometry in
                
                
                // Background Image
                Image("tv")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .ignoresSafeArea()
                    .opacity(0.8)
                
                // Red overlay
                Color.red
                    .opacity(redOpacity)
                    .ignoresSafeArea()
                ZStack {
                    
                    
                    VStack {
                        if sceneStore.isLoading {
                            // Show progress spinner if loading
                            VStack {
                                Spacer()
                                ProgressView("Loading Scenes")
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        } else {
                            // Show content when loading is complete
                            sceneGrid()
                            bottomTabBar()
                        }
                    }
                    .onChange(of: isRecording) { handleRecordingChange($0) }
                    //.onChange(of: sceneStore.sceneList) { updateScene() }
                    
                    .onChange(of: sceneStore.isLoading) { isLoading in
                        print("onChange - isLoading updated: \(isLoading)")
                    }
                    
                    .onChange(of: sceneStore.sceneList) { newScenes in
                        if !newScenes.isEmpty {
                            print("Non-empty sceneList detected: \(newScenes.count) items")
                            sceneStore.isLoading = false  // Hide the spinner once data is available
                            
                            // Update the sceneSources based on the newScenes and currentSceneIndex
                            if sceneStore.sceneList.indices.contains(currentSceneIndex) {
                                let currentScene = sceneStore.sceneList[currentSceneIndex]
                                sceneSources = currentScene.sources
                                sceneName = currentScene.sceneName
                                print("Scene sources updated: \(sceneSources.count) items")
                                print("onChange - sceneList updated. New count: \(newScenes.count)")
                            }
                            updateScene()
                        }
                    }
                    
                    
                    // React to changes in SceneStore
                    .animation(.default.speed(1), value: showOverlay)
                    .onAppear {
                        print("onAppear triggered. isLoading = \(sceneStore.isLoading), sceneList = \(sceneStore.sceneList.count)")
                          
                        //previousSceneSources = sceneSources
                    }
                    .ignoresSafeArea(edges: .all)
                    .navigationBarHidden(showOverlay)
                    
                    // Overlay content when needed
                    overlayView()
                }
                .environmentObject(sceneStore)  // Inject the SceneStore as an EnvironmentObject
            }
        }
    }
    
    // MARK: - View Components
    
    private func backgroundView() -> some View {
        VStack {
            // Background Image
            Image("tv")
                .resizable()
                .scaledToFill()
                .clipped()
                .ignoresSafeArea()
                .opacity(0.8)
            
            // Red overlay
            Color.red
                .opacity(redOpacity)
                .ignoresSafeArea()
        }
    }
    
    private func sceneGrid() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 8) {
                ForEach($sceneSources, id: \.id) { $sceneSource in
                    LampButton(
                        showOverlay: $showOverlay,
                        currentSceneIndex: $currentSceneIndex,
                        selectedSource: $selectedSource,
                        sceneSource: $sceneSource,
                        highlightColor: sceneSource.getColor()
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 160)
            .opacity(showOverlay ? 0 : 1)
        }
//        .onAppear {
//            updateScene() // Initialize the scene data << just disabled this
//        }
        .navigationTitle(sceneName)
        .navigationBarTitleDisplayMode(.automatic)
    }
    
    private func bottomTabBar() -> some View {
        BottomTabBar(
            isRecording: $isRecording,
                canRewind: currentSceneIndex > 0,
                canForward: currentSceneIndex < sceneStore.sceneList.count - 1,
            onRewind: rewindScene,
            onForward: forwardScene,
            onSimulateAPIUpdate: simulateAPIUpdate // Add simulation action
        )
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .zIndex(2)
    }
    
    private func overlayView() -> some View {
        if showOverlay, let selectedSourceIndex = sceneSources.firstIndex(where: { $0.id == selectedSource?.id }) {
            return AnyView(
                OverlayView(
                    showOverlay: $showOverlay,
                    source: $sceneSources[selectedSourceIndex]
                )
                .frame(maxWidth: .infinity, alignment: .top)
                .transition(.opacity)
                .zIndex(1)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    // MARK: - Logic and API Simulation
    
    private func simulateAPIUpdate() {
        let simulatedResponse = APIResponse(
            sceneIndex: 0, // Assuming you want to update "Scene 1"
            sceneName: "Scene 1",
            sources: [
                SceneItem(id: 1, sourceName: "Slideshow Presentation", inputKind: "slideshow_v2", sceneItemEnabled: false, level: Double.random(in: 0...1))
            ]
        )
        sceneStore.sceneList[simulatedResponse.sceneIndex] = simulatedResponse
    }
    
    private func simulateDynamicAPIUpdate(sceneIndex: Int, changedItem: SceneItem) {
        // Simulate a delay to mimic a real API response
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                // Ensure the scene index is valid
                guard sceneStore.sceneList.indices.contains(sceneIndex) else {
                    print("Scene index \(sceneIndex) is out of bounds")
                    return
                }
                
                // Get the scene to update
                var currentScene = sceneStore.sceneList[sceneIndex]
                
                // Find the SceneItem to update within the scene's sources
                if let itemIndex = currentScene.sources.firstIndex(where: { $0.id == changedItem.id }) {
                    currentScene.sources[itemIndex] = changedItem
                    
                    // Reassign the updated scene back to the scene list
                    sceneStore.sceneList[sceneIndex] = currentScene
                    print("Updated SceneItem \(changedItem.sourceName) in Scene \(currentScene.sceneName)")
                } else {
                    print("SceneItem with id \(changedItem.id) not found in Scene \(currentScene.sceneName)")
                }
            }
        }
    }
    
    // Scene navigation logic
    private func rewindScene() {
        guard currentSceneIndex > 0 else { return }
        currentSceneIndex -= 1
        updateScene()
    }
    
    private func forwardScene() {
        guard currentSceneIndex < sceneStore.sceneList.count - 1 else { return }
        currentSceneIndex += 1
        updateScene()
    }
    
    private func updateScene() {
        
        print("Updating scene...")
        guard sceneStore.sceneList.indices.contains(currentSceneIndex) else {
            print("updateScene - Invalid scene index \(currentSceneIndex)")
            return
        }
        let currentScene = sceneStore.sceneList[currentSceneIndex]
        sceneName = currentScene.sceneName
        sceneSources = currentScene.sources
        print("updateScene - sceneName: \(sceneName), sources count: \(sceneSources.count)")
    }
    
    private func handleRecordingChange(_ isRecording: Bool) {
        if isRecording {
            // Start pulsating animation
            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                redOpacity = 0.8
            }
        } else {
            // Stop pulsating animation
            withAnimation {
                redOpacity = 0.0
            }
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        // Create a mock sceneStore (you can use MockScenes or a mock object)
        let mockSceneStore = SceneStore()
        
        // Create a mock BonjourClient with the mock sceneStore
        let mockBonjourClient = BonjourClient(sceneStore: mockSceneStore)
        
        // Return the ContentView with the mock BonjourClient injected as an environment object
        return ContentView()
            .environmentObject(mockBonjourClient)
            .environmentObject(mockSceneStore) // Don't forget to inject the mock sceneStore as well
    }
}
