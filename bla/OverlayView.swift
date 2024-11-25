import SwiftUI
import Combine // Add this import for `Cancellable` if needed

struct OverlayView: View {
    @Binding var showOverlay: Bool
    @Binding var source: SceneItem // Bind the specific SceneSource
    
    @State private var debounceTimer: DispatchWorkItem? = nil // Use DispatchWorkItem instead of Cancellable
    
    var body: some View {
        VStack {
            Text("\(source.sourceName)")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .lineLimit(1) // Ensures the text is confined to one line
                .minimumScaleFactor(0.5) // Shrinks the text to 50% of its original size if needed
                .padding(.bottom, 5)
                .padding(.horizontal, 10)
           
            Text("\(Int(source.level * 100))%") // Display level as percentage
                .font(.title2)
                .foregroundColor(source.getColor())
                .padding(.bottom, 40)
            
            // Bind the slider directly to source.level
            
            
            VerticalSlider(
                value: $source.level,
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
            
            Spacer()
        }
        .padding(.top, 130)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            showOverlay = false
        }
        // Listen for changes to 'level' and trigger API call with debounce
        .onChange(of: source.level) {
            debounceAPIRequest(for: source)
        }
    }
    
    func sendAPIRequest(for sceneSource: SceneItem) {
        // Send the API request here (log for testing)
        print("Sending API request for \(sceneSource.sourceName) with level \(sceneSource.level)")
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



#Preview {
    ContentView()
}
