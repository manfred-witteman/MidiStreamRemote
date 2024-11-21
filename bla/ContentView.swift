import SwiftUI

struct ContentView: View {
    private var gridItemLayout = [GridItem(.adaptive(minimum: 160))]
    @State private var previousSceneSources: [SceneSource] = []
    @State private var showOverlay: Bool = false
    @State private var selectedSource: SceneSource? = nil
    @State private var sceneSources: [SceneSource] = [
        SceneSource(id: 1, sourceName: "Slideshow Presentation", inputKind: "slideshow_v2", sceneItemEnabled: true, level: Double.random(in: 0...1)),
        SceneSource(id: 2, sourceName: "Vampire", inputKind: "ffmpeg_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
        SceneSource(id: 3, sourceName: "Microphone Input", inputKind: "sck_audio_capture", sceneItemEnabled: false, level: Double.random(in: 0...1)),
        SceneSource(id: 4, sourceName: "Color Overlay", inputKind: "color_source_v3", sceneItemEnabled: true, level: Double.random(in: 0...1)),
        SceneSource(id: 5, sourceName: "Logo Image", inputKind: "image_source", sceneItemEnabled: true, level: Double.random(in: 0...1)),
        SceneSource(id: 6, sourceName: "Overlay Text", inputKind: "text_ft2_source_v2", sceneItemEnabled: true, level: Double.random(in: 0...1)),
        SceneSource(id: 7, sourceName: "Webcam Feed", inputKind: "unknown", sceneItemEnabled: true, level: Double.random(in: 0...1)),
        SceneSource(id: 8, sourceName: "Slideshow Presentation", inputKind: "slideshow_v2", sceneItemEnabled: true, level: Double.random(in: 0...1))
    ]
    
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
                                .scaledToFill() // Image fills the space without stretching
                                //.frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped() // Ensures the image doesn't overflow the edges
                                .ignoresSafeArea()
                                .opacity(0.8)
                // Red overlay
                Color.red
                    .opacity(redOpacity) // Use the redOpacity state for dynamic opacity
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
                    .navigationTitle("Scene 1")
                    .navigationBarTitleDisplayMode(.automatic)
            
                    
                    
                    // Bottom Tab Bar positioned at the bottom, aligned with the grid
                    BottomTabBar(isRecording: $isRecording)
                        .padding(.vertical, 20) // Optional padding
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity) // Ensures the tab bar fills horizontally within the VStack
                        .zIndex(2) // Ensure it's on top of other content
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
                    .frame(maxWidth: .infinity, alignment: .top) // Ensures it's aligned to the top
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
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
