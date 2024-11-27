import SwiftUI

struct ExpandingCirclesView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                Circle()
                    .stroke(lineWidth: 5)
                    .fill(index % 2 == 0 ? Color.blue : Color.red)
                    .frame(width: animate ? CGFloat(50 + index * 50) : 50,
                           height: animate ? CGFloat(50 + index * 50) : 50)
                    .opacity(animate ? 0 : 1) // Gradual fade out as it expands
                    .animation(
                        .easeOut(duration: 2)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate.toggle()
        }
    }
}

struct ContentView: View {
    var body: some View {
        ExpandingCirclesView()
    }
}

struct ExpandingCirclesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpandingCirclesView()
    }
}
