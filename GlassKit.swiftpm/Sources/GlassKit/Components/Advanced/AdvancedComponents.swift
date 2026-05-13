import SwiftUI

// MARK: - GlassCheckboxStyle

/// A glass-morphic checkbox toggle style.
public struct GlassCheckboxStyle: ToggleStyle {
    public init() { }
    public func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(configuration.isOn ? Color.accentColor : .secondary, lineWidth: 2)
                        .frame(width: 24, height: 24)
                        .background {
                            if configuration.isOn {
                                Color.accentColor.opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    
                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.accentColor)
                    }
                }
                configuration.label
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ConfettiEmitter

/// A simple confetti particle emitter for celebration feedback.
public struct ConfettiEmitter: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var color: Color
        var rotation: Double
    }
    
    public var body: some View {
        ZStack {
            ForEach(particles) { p in
                Rectangle()
                    .fill(p.color)
                    .frame(width: 10, height: 10)
                    .position(x: p.x, y: p.y)
                    .rotationEffect(.degrees(p.rotation))
            }
        }
        .onAppear {
            for _ in 0..<50 {
                particles.append(Particle(
                    x: CGFloat.random(in: 0...400),
                    y: -20,
                    color: [.red, .blue, .green, .yellow, .purple].randomElement()!,
                    rotation: Double.random(in: 0...360)
                ))
            }
            
            withAnimation(.linear(duration: 3)) {
                for i in particles.indices {
                    particles[i].y = 800
                    particles[i].x += CGFloat.random(in: -100...100)
                    particles[i].rotation += 720
                }
            }
        }
    }
}

// MARK: - BarChartContainer

/// A simple glass-morphic bar chart container.
public struct BarChartContainer: View {
    let data: [Double]
    let colors: [Color]
    
    public init(data: [Double], colors: [Color] = [.blue, .purple]) {
        self.data = data
        self.colors = colors
    }
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(0..<data.count, id: \.self) { i in
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                    .frame(height: CGFloat(data[i] * 100))
                    .glassCard(level: .ultraThin, cornerRadius: 4, padding: 0)
            }
        }
        .frame(height: 120)
        .padding()
        .background {
            GlassSurface(level: .ultraThin, cornerRadius: DesignTokens.Radius.l)
        }
    }
}

// MARK: - CodeBlockView

/// A syntax-highlighted (simulated) code block view.
public struct CodeBlockView: View {
    let code: String
    let language: String
    
    public init(code: String, language: String) {
        self.code = code
        self.language = language
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(language.uppercased())
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "doc.on.doc")
                    .font(.caption2)
            }
            Divider()
            Text(code)
                .font(Font.system(.caption))
                .monospaced()
                .foregroundStyle(.primary)
        }
        .padding()
        .background {
            Color.black.opacity(0.3)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.m))
        }
    }
}

// MARK: - VolumetricCard (visionOS style)

/// A card that reacts to device motion or hover to show volume.
public struct VolumetricCard<Content: View>: View {
    let content: Content
    @State private var rotation = CGSize.zero
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding()
            .background {
                GlassSurface(level: .regular, cornerRadius: DesignTokens.Radius.xl)
            }
            .rotation3DEffect(.degrees(Double(rotation.width / 5)), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.degrees(Double(-rotation.height / 5)), axis: (x: 1, y: 0, z: 0))
            .gesture(
                DragGesture()
                    .onChanged { v in rotation = v.translation }
                    .onEnded { _ in withAnimation(.spring()) { rotation = .zero } }
            )
    }
}
