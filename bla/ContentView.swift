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
        SceneSource(id: 7, sourceName: "Webcam Feed", inputKind: "unknown", sceneItemEnabled: true, level: Double.random(in: 0...1))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    .padding(.top, 100)
                    .opacity(showOverlay ? 0 : 1)
                }
                .navigationTitle("Scene 1: commercial break")
                .navigationBarTitleDisplayMode(.inline)
                
                if showOverlay, let selectedSourceIndex = sceneSources.firstIndex(where: { $0.id == selectedSource?.id }) {
                    OverlayView(
                        showOverlay: $showOverlay,
                        source: $sceneSources[selectedSourceIndex]
                    )
                    .transition(.opacity)
                    .zIndex(1)
                }
                    
            }
            .animation(.default.speed(1), value: showOverlay)
            .onAppear {
                previousSceneSources = sceneSources
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .red]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .ignoresSafeArea(edges: .all)
            .navigationBarHidden(showOverlay)
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
}


#Preview {
    ContentView()
}
