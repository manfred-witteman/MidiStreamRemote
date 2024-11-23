import SwiftUI

struct BottomTabBar: View {
    @Binding var isRecording: Bool
    
    // Closure properties for dynamic actions
    var onRewind: () -> Void
    var onForward: () -> Void

    // Haptic feedback generator
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // Haptic feedback trigger
    func triggerHapticFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }

    // Reusable button component
    @ViewBuilder
    private func TabButton(icon: String, label: String, color: Color = .white, action: @escaping () -> Void) -> some View {
        Button(action: {
            triggerHapticFeedback()
            action()
        }) {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(color)
                Text(label)
                    .font(.footnote)
                    .foregroundColor(.white)
            }
        }
        .accessibilityLabel(Text(label))
        .accessibilityHint(Text("Tap to \(label)"))
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            // Rewind button
            TabButton(icon: "backward.fill", label: "back") {
                onRewind()
            }
            
            Spacer()
            
            // Record button
            TabButton(
                icon: isRecording ? "pause.fill" : "record.circle.fill",
                label: isRecording ? "pause" : "record",
                color: isRecording ? .white : .red
            ) {
                isRecording.toggle()
            }
            
            Spacer()
            
            // Forward button
            TabButton(icon: "forward.fill", label: "next") {
                onForward()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.7)) // Background color with transparency
        .cornerRadius(25)
        .shadow(radius: 10)
    }
}
