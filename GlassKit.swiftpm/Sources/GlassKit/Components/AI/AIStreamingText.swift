import SwiftUI

/// A premium component that simulates real-time AI streaming text with a smooth character reveal and blinking cursor.
///
/// Use this component to display AI-generated content or system logs in a high-fidelity, interactive manner.
public struct AIStreamingText: View {
    /// The full text to be revealed.
    let text: String
    /// The speed of the character reveal (seconds per character). Defaults to 0.05.
    let speed: Double
    
    @State private var displayedText: String = ""
    @State private var cursorVisible: Bool = true
    @State private var currentIndex: Int = 0
    
    /// Initializes a new AIStreamingText component.
    /// - Parameters:
    ///   - text: The text to reveal.
    ///   - speed: The streaming speed.
    public init(_ text: String, speed: Double = 0.05) {
        self.text = text
        self.speed = speed
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Text(displayedText)
            
            if cursorVisible {
                Text("█")
                    .foregroundColor(.accentColor)
            }
        }
        .font(DesignTokens.Typography.body)
        .onAppear {
            startStreaming()
            startCursorBlink()
        }
    }
    
    private func startStreaming() {
        let characters = Array(text)
        currentIndex = 0
        displayedText = ""
        
        Task {
            for char in characters {
                try? await Task.sleep(for: .seconds(speed))
                await MainActor.run {
                    displayedText.append(char)
                    currentIndex += 1
                }
            }
            await MainActor.run {
                cursorVisible = false
            }
        }
    }
    
    private func startCursorBlink() {
        withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
            cursorVisible.toggle()
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AIStreamingText("Analyzing liquid glass surfaces for optimal GPU performance... Done.")
            .padding()
            .glassCard()
    }
}
