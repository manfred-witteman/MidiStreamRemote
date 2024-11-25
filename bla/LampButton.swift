import SwiftUI
import UIKit // Import UIKit for haptic feedback

struct LampButton: View {
    @Binding var showOverlay: Bool
    @Binding var selectedSource: SceneItem?
    @Binding var sceneSource: SceneItem

    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // Add a parameter for the customizable color
    var highlightColor: Color = .yellow

    var body: some View {
        Button(action: {
            // When tapping anywhere except the icon, show the overlay and set selected source
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
                    // Left half: Icon inside a circle, anchored to the left edge
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
                    .animation(.easeInOut(duration: 0.1), value: sceneSource.sceneItemEnabled)
                    .padding(.leading, 15)
                    .onTapGesture {
                        // When tapping on the circle, toggle the sceneItemEnabled state
                        sceneSource.sceneItemEnabled.toggle()
                        sendAPIRequest(for: sceneSource) // Send API request when toggling
                        generateHapticFeedback()
                    }

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
                   
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                .padding(.trailing, 10)
            }
        }
    }

    func generateHapticFeedback() {
        hapticGenerator.impactOccurred() // Trigger the haptic feedback
    }

    func sendAPIRequest(for sceneSource: SceneItem) {
        // Send the API request here (log for testing)
        print("Sending API request for \(sceneSource.sourceName) because the state is toggled")
    }
}
