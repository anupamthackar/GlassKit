import SwiftUI

// MARK: - PromptInputBar

/// A multi-line prompt input bar with an integrated send button and glass aesthetic.
///
/// ```swift
/// PromptInputBar(text: $prompt, onSend: { ... })
/// ```
public struct PromptInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    
    public init(text: Binding<String>, onSend: @escaping () -> Void) {
        self._text = text
        self.onSend = onSend
    }
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            AutoGrowingTextEditor(text: $text, placeholder: "Ask anything…", minHeight: 36, maxHeight: 120)
            
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(text.isEmpty ? Color.secondary.opacity(0.3) : Color.accentColor)
            }
            .buttonStyle(.plain)
            .disabled(text.isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background {
            GlassSurface(level: .thick, cornerRadius: DesignTokens.Radius.xl)
        }
    }
}

// MARK: - TypingIndicator

/// A subtle animated typing indicator for AI agents.
///
/// ```swift
/// TypingIndicator()
/// ```
public struct TypingIndicator: View {
    @State private var dot1 = false
    @State private var dot2 = false
    @State private var dot3 = false
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: 4) {
            Circle().fill(.secondary).frame(width: 4, height: 4).opacity(dot1 ? 1 : 0.3)
            Circle().fill(.secondary).frame(width: 4, height: 4).opacity(dot2 ? 1 : 0.3)
            Circle().fill(.secondary).frame(width: 4, height: 4).opacity(dot3 ? 1 : 0.3)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            GlassSurface(level: .ultraThin, cornerRadius: 16)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever().delay(0.0)) { dot1 = true }
            withAnimation(.easeInOut(duration: 0.6).repeatForever().delay(0.2)) { dot2 = true }
            withAnimation(.easeInOut(duration: 0.6).repeatForever().delay(0.4)) { dot3 = true }
        }
    }
}

// MARK: - ConversationBubble

/// A message bubble for chat interfaces with adaptive glass levels.
///
/// ```swift
/// ConversationBubble(message: "Hello!", isUser: true)
/// ```
public struct ConversationBubble: View {
    let message: String
    let isUser: Bool
    
    public init(message: String, isUser: Bool) {
        self.message = message
        self.isUser = isUser
    }
    
    public var body: some View {
        HStack {
            if isUser { Spacer() }
            
            Text(message)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background {
                    if isUser {
                        Color.accentColor.opacity(0.15)
                            .background(.ultraThinMaterial)
                            .clipShape(DynamicCornerRadius(topLeft: 20, topRight: 20, bottomLeft: 20, bottomRight: 4))
                    } else {
                        GlassSurface(level: .thin, cornerRadius: 0)
                            .clipShape(DynamicCornerRadius(topLeft: 20, topRight: 20, bottomLeft: 4, bottomRight: 20))
                    }
                }
            
            if !isUser { Spacer() }
        }
    }
}

// MARK: - VoiceWaveformView

/// A dynamic waveform view that reacts to audio input levels.
///
/// ```swift
/// VoiceWaveformView(levels: audioLevels)
/// ```
public struct VoiceWaveformView: View {
    let levels: [CGFloat]
    
    public init(levels: [CGFloat]) {
        self.levels = levels
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<levels.count, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(LinearGradient(colors: [.accentColor, .purple], startPoint: .top, endPoint: .bottom))
                    .frame(width: 3, height: max(4, levels[i] * 40))
            }
        }
        .frame(height: 50)
        .animation(.interactiveSpring, value: levels)
    }
}

// MARK: - SpotlightSearch

/// A centered spotlight-style search overlay for AI-powered discovery.
///
/// ```swift
/// SpotlightSearch(isPresented: $searching)
/// ```
public struct SpotlightSearch: View {
    @Binding var isPresented: Bool
    @State private var text = ""
    
    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    public var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                    .onTapGesture { withAnimation { isPresented = false } }
                
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(Color.accentColor)
                        TextField("Search anything with AI…", text: $text)
                            .font(.title3)
                    }
                    .padding(20)
                    .background {
                        GlassSurface(level: .thick, cornerRadius: DesignTokens.Radius.xl)
                    }
                    .elevationShadow(.modal)
                    .padding(.horizontal, 40)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
        }
    }
}
