import SwiftUI
import UIKit

struct LampButton: View {
    @Binding var showOverlay: Bool
    @Binding var currentSceneIndex: Int
    @Binding var selectedSource: SceneItem?
    @Binding var sceneSource: SceneItem
    
    @EnvironmentObject var bonjourClient: BonjourClient // Access from the environment
    
    
    @EnvironmentObject var sceneStore: SceneStore  // Get the SceneStore using @EnvironmentObject
    
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var highlightColor: Color = .yellow
    
    var body: some View {
        Button(action: {
            selectedSource = sceneSource
            showOverlay.toggle()
            generateHapticFeedback()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(sceneSource.sceneItemEnabled ? Color.white : Color.black.opacity(0.2))
                    .frame(width: 170, height: 65)
                    .shadow(radius: sceneSource.sceneItemEnabled ? 5 : 0)
                
                HStack(spacing: 10) {
                    // Left half: Icon inside a circle
                    ZStack {
                        Circle()
                            .fill(sceneSource.sceneItemEnabled ? highlightColor : Color.black.opacity(0.3))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: sceneSource.sceneItemEnabled ? sceneSource.getIcon(filled: true) : sceneSource.getIcon(filled: false))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(sceneSource.sceneItemEnabled ? .white : highlightColor)
                    }
                    .onTapGesture {
                        // Toggle sceneItemEnabled and update the scene store
                        sceneSource.sceneItemEnabled.toggle()
                        sendAPIRequest(for: sceneSource)  // Send API request when toggling
                        generateHapticFeedback()
                    }
                    .padding(.leading, 15)
                    
                    // Main button for the overlay
                    Button(action: {
                        selectedSource = sceneSource
                        showOverlay.toggle()
                        generateHapticFeedback()
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(sceneSource.sourceName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(sceneSource.sceneItemEnabled ? .black : .white)
                                .lineLimit(1)
                            
                            Text(sceneSource.sceneItemEnabled ? "\(Int(sceneSource.level * 100))%" : "Uit")
                                .font(.caption)
                                .foregroundColor(sceneSource.sceneItemEnabled ? .gray : .white.opacity(0.7))
                        }
                    }
                    .padding(.trailing, 10)
                    
                    Spacer() // Push everything to the left within the button's frame
                }
                
            }
        }
    }
    
    func generateHapticFeedback() {
        hapticGenerator.impactOccurred() // Trigger the haptic feedback
    }
    
    func sendAPIRequest(for sceneSource: SceneItem) {
        let payload: [String: Any] = [
            "sceneItemEnabled": sceneSource.sceneItemEnabled,
            "level": sceneSource.level,
            "sourceName": sceneSource.sourceName
        ]
        
        // Correct key for the payload should be "data"
        let message: [String: Any] = [
            "type": "toggle",
            "data": payload  // Change 'payload' to 'data'
        ]
        
        bonjourClient.sendMessage(message)
    }
}
