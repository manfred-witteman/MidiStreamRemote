import SwiftUI

struct OverlayView: View {
    @Binding var showOverlay: Bool
    @Binding var source: SceneSource // Bind the specific SceneSource
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(source.sourceName)")
                .font(.largeTitle)
                .padding(.bottom, 5)
            Text("\(Int(source.level * 100))%") // Display level as percentage
                .font(.title2)
                .foregroundColor(.mint)
                .padding(.bottom, 20)
            
            // Bind the slider directly to source.level
            VerticalSlider(value: $source.level)
                .frame(width: 170, height: 400)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            showOverlay = false
        }
    }
}

#Preview {
    ContentView()
}
