import SwiftUI

struct BottomTabBar: View {
    // Binding to the isRecording state from ContentView
    @Binding var isRecording: Bool
    
    // Create an instance of the haptic feedback generator
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // A function to trigger haptic feedback
    func triggerHapticFeedback() {
        feedbackGenerator.prepare() // Preload the haptic feedback
        feedbackGenerator.impactOccurred() // Trigger the haptic feedback
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            // First button (e.g., "Home" icon)
            Button(action: {
                triggerHapticFeedback() // Trigger haptic feedback on tap
                print("Rewind tab tapped")
                // Add your action here
            }) {
                VStack {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Text("back")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            // Second button (Record button with toggle state)
            Button(action: {
                triggerHapticFeedback() // Trigger haptic feedback on tap
                // Toggle the recording state
                isRecording.toggle()
                print(isRecording ? "Recording started" : "Recording stopped")
                // Add any additional action here (e.g., start/stop recording)
            }) {
                VStack {
                    // Change the image based on the recording state
                    Image(systemName: isRecording ? "pause.fill" : "record.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isRecording ? .white : .red)
                    Text(isRecording ? "pause" : "record")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            // Third button (e.g., "Settings" icon)
            Button(action: {
                triggerHapticFeedback() // Trigger haptic feedback on tap
                print("Forward tab tapped")
                // Add your action here
            }) {
                VStack {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Text("next")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.7)) // Background color with transparency
        .cornerRadius(25)
        .shadow(radius: 10)
    }
}
