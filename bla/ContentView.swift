import SwiftUI

struct ContentView: View {
    private var gridItemLayout = [GridItem(.adaptive(minimum: 160))]
    @State private var previousSceneSources: [SceneSource] = []
    @State private var showOverlay: Bool = false
    @State private var currentSceneIndex: Int = 0
    @State private var selectedSource: SceneSource? = nil
    @State private var sceneName: String = "Scene 1"
    
    // Load "Scene 1" directly as the initial data
    @State private var sceneSources: [SceneSource] = MockScenes.sceneList[0].sources
    
    @State private var isRecording: Bool = false
    @State private var redOpacity: Double = 0.0
    
    // Define the gradient colors dynamically
    @State private var backgroundGradientColors: [Color] = [.blue, .red]
    
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
                        LazyVGrid(columns: gridItemLayout, spacing: 8) {
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
                    .onChange(of: sceneSources) {
                        sceneSources.sort { $0.inputKind < $1.inputKind }
                    }
                    .onAppear {
                        sceneSources.sort { $0.inputKind < $1.inputKind }
                    }
                    .navigationTitle(sceneName)
                    .navigationBarTitleDisplayMode(.automatic)
                    
                    // Bottom Tab Bar positioned at the bottom, aligned with the grid
                    BottomTabBar(
                        isRecording: $isRecording,
                        onRewind: rewindScene,
                        onForward: forwardScene
                    )
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .zIndex(2)
                }
                .onChange(of: isRecording) {
                    handleRecordingChange(isRecording)
                }
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
    
    // Scene navigation logic
    private func rewindScene() {
        guard currentSceneIndex > 0 else { return }
        currentSceneIndex -= 1
        updateScene()
    }
    
    private func forwardScene() {
        guard currentSceneIndex < MockScenes.sceneList.count - 1 else { return }
        currentSceneIndex += 1
        updateScene()
    }
    
    private func updateScene() {
        let currentScene = MockScenes.sceneList[currentSceneIndex]
        sceneName = currentScene.sceneName
        sceneSources = currentScene.sources
    }
    
    func sendAPIRequest(for sceneSource: SceneSource) {
        print("Sending API request for \(sceneSource.sourceName) with level \(sceneSource.level)")
    }
    
    func sendAPIRequest(for sceneSources: [SceneSource]) {
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
