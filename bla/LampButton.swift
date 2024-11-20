import SwiftUI
import UIKit // Import UIKit for haptic feedback

import SwiftUI
import UIKit // Import UIKit for haptic feedback

// LampButton that accepts individual SceneSource with Binding
struct LampButton: View {
    @Binding var showOverlay: Bool
    @Binding var selectedSource: SceneSource?
    @Binding var sceneSource: SceneSource

    private let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

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
                            .fill(sceneSource.sceneItemEnabled ? Color.yellow : Color.black.opacity(0.3))
                            .frame(width: 40, height: 40)

                        Image(systemName: getIcon(for: sceneSource))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(sceneSource.sceneItemEnabled ? .white : .yellow)
                    }
                    .padding(.leading, 15)
                    .onTapGesture {
                        // When tapping on the circle, toggle the sceneItemEnabled state
                        sceneSource.sceneItemEnabled.toggle()
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
        .animation(.easeInOut, value: sceneSource.sceneItemEnabled)
    }

//    func sendAPIRequest(for sceneSource: SceneSource) {
//        // Send the API request here (log for testing)
//        print("Sending API request for \(sceneSource.sourceName) with level \(sceneSource.level)")
//    }

  
    func getIcon(for item: SceneSource) -> String {
        switch item.inputKind {
        case "slideshow_v2":
            return "photo.stack"
        case "ffmpeg_source":
            return "waveform"
        case "sck_audio_capture":
            return "microphone"
        case "color_source_v3":
            return "paintpalette.fill"
        case "image_source":
            return "photo"
        case "text_ft2_source_v2":
            return "textformat.characters.dottedunderline"
        default:
            return "camera.metering.unknown"
        }
    }

    func generateHapticFeedback() {
        hapticGenerator.impactOccurred() // Trigger the haptic feedback
    }
}
