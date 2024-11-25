import SwiftUI

struct ContentView: View {
    @StateObject private var sceneStore = SceneStore() // Use SceneStore for managing scenes
    @State private var previousSceneSources: [SceneItem] = []
    @State private var showOverlay: Bool = false
    @State private var currentSceneIndex: Int = 0
    @State private var selectedSource: SceneItem? = nil
    @State private var sceneName: String = "Scene 1"
    
    // Load "Scene 1" directly as the initial data
    @State private var sceneSources: [SceneItem] = MockScenes.sceneList[0].sources
    
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
                
                VStack {
                    // ScrollView content inside a container to align with the grid
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 8) {
                            ForEach($sceneSources, id: \.id) { $sceneSource in
                                LampButton(
                                    showOverlay: $showOverlay,
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
                    .onAppear {
                        updateScene() // Initialize the scene data
                    }
                    .navigationTitle(sceneName)
                    .navigationBarTitleDisplayMode(.automatic)
                    
                    // Bottom Tab Bar positioned at the bottom, aligned with the grid
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
                .onChange(of: isRecording) { handleRecordingChange($0) }
                .onChange(of: sceneStore.sceneList) { updateScene() } // React to changes in SceneStore
                .animation(.default.speed(1), value: showOverlay)
                .onAppear {
                    previousSceneSources = sceneSources
                }
                .ignoresSafeArea(edges: .all)
                .navigationBarHidden(showOverlay)
                
                // Overlay content when needed
                if showOverlay, let selectedSourceIndex = sceneSources.firstIndex(where: { $0.id == selectedSource?.id }) {
                    OverlayView(
                        showOverlay: $showOverlay,
                        source: $sceneSources[selectedSourceIndex]
                    )
                    .frame(maxWidth: .infinity, alignment: .top)
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
    }
    
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
        guard sceneStore.sceneList.indices.contains(currentSceneIndex) else { return }
        let currentScene = sceneStore.sceneList[currentSceneIndex]
        sceneName = currentScene.sceneName
        sceneSources = currentScene.sources
        
        // If a selectedSource exists, update it as well
        if let selectedSourceID = selectedSource?.id {
            selectedSource = sceneSources.first { $0.id == selectedSourceID }
        }
    }
    
    func sendAPIRequest(for sceneSource: SceneItem) {
        print("Sending API request for \(sceneSource.sourceName) with level \(sceneSource.level)")
    }
    
    func sendAPIRequest(for sceneSources: [SceneItem]) {
        for source in sceneSources {
            print("Sending API request for \(source.sourceName) with level \(source.level)")
        }
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


#Preview {
    ContentView()
}
