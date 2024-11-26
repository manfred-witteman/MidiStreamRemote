import SwiftUI

struct BottomTabBar: View {
    @Binding var isRecording: Bool
    var canRewind: Bool // Add a property to indicate if rewind is allowed
    var canForward: Bool // Add a property to indicate if forward is allowed

    // Closure properties for dynamic actions
    var onRewind: () -> Void
    var onForward: () -> Void
    var onSimulateAPIUpdate: () -> Void // New closure for API update simulation

    // Haptic feedback generator
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // Haptic feedback trigger
    func triggerHapticFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }

    // Reusable button component
    @ViewBuilder
    private func TabButton(icon: String, label: String, color: Color = .white, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: {
            if !disabled {
                triggerHapticFeedback()
                action()
            }
        }) {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(disabled ? .gray : color)
                Text(label)
                    .font(.footnote)
                    .foregroundColor(disabled ? .gray : .white)
            }
        }
        .disabled(disabled) // Disable the button if needed
        .accessibilityLabel(Text(label))
        .accessibilityHint(Text("Tap to \(label)"))
    }

    var body: some View {
        HStack {
            Spacer()
            
            // Rewind button
            TabButton(icon: "backward.fill", label: "back", disabled: !canRewind) {
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
            TabButton(icon: "forward.fill", label: "next", disabled: !canForward) {
                onForward()
            }
            
            Spacer()
            
//            // Simulate API update button
//            TabButton(icon: "arrow.triangle.2.circlepath", label: "update") {
//                onSimulateAPIUpdate()
//            }
//            
//            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.7)) // Background color with transparency
        .cornerRadius(25)
        .shadow(radius: 10)
    }
}

