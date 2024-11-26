import SwiftUI
import Combine

struct OverlayView: View {
    @Binding var showOverlay: Bool
    @Binding var source: SceneItem // Bind the specific SceneSource
    
    @State private var debounceTimer: DispatchWorkItem? = nil // Use DispatchWorkItem instead of Cancellable
    
    var body: some View {
        VStack {
            sourceNameText
            sourceLevelText
            levelSlider
            Spacer()
        }
        .padding(.top, 130)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            showOverlay = false
        }
        .onChange(of: source.level) {
            debounceAPIRequest(for: source)
        }
    }
    
    private var sourceNameText: some View {
        Text("\(source.sourceName)")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .lineLimit(1) // Ensures the text is confined to one line
            .minimumScaleFactor(0.5) // Shrinks the text to 50% of its original size if needed
            .padding(.bottom, 5)
            .padding(.horizontal, 10)
    }
    
    private var sourceLevelText: some View {
        Text("\(Int((source.level ?? 0) * 100))%") // Display level as percentage, defaulting to 0 if nil
            .font(.title2)
            .foregroundColor(source.getColor())
            .padding(.bottom, 40)
    }
    
    private var levelSlider: some View {
        VerticalSlider(
            value: Binding(
                get: { source.level ?? 0 }, // Default to 0 if level is nil
                set: { newValue in source.level = newValue } // Set the value back to source.level
            ),
            icon: { value in
                if value > 0.5 {
                    return Image(systemName: source.getIcon(filled: true)) // Bright lamp
                } else {
                    return Image(systemName: source.getIcon(filled: false)) // Dim lamp
                }
            },
            iconColor: source.getColor()
        )
        .frame(width: 132, height: 400)
    }

    func sendAPIRequest(for sceneSource: SceneItem) {
        // Send the API request here (log for testing)
        print("Sending API request for \(sceneSource.sourceName) with level \(String(describing: sceneSource.level))")
    }
    
    private func debounceAPIRequest(for sceneSource: SceneItem) {
        // Cancel previous debounce timer if any
        debounceTimer?.cancel()
        
        // Start a new debounce timer with a delay of 0.5 seconds (adjustable)
        debounceTimer = DispatchWorkItem {
            sendAPIRequest(for: sceneSource) // Send the API request after the delay
        }
        
        // Schedule the work item on the main queue after the delay
        if let debounceTimer = debounceTimer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: debounceTimer)
        }
    }
}
