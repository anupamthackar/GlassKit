import SwiftUI

/// A premium glass-morphic button style with dynamic material levels and interaction logic.
///
/// Use this style to apply NovaUI's liquid glass aesthetic to any SwiftUI Button.
public struct GlassButtonStyle: ButtonStyle {
    /// The intensity of the glass material.
    let level: GlassMaterialLevel
    /// The corner radius of the button surface.
    let cornerRadius: CGFloat
    
    /// Initializes a new glass button style.
    /// - Parameters:
    ///   - level: The material level (e.g., .thin, .regular, .thick). Defaults to .regular.
    ///   - cornerRadius: The radius of the corners. Defaults to DesignTokens.Radius.m.
    public init(
        level: GlassMaterialLevel = .regular,
        cornerRadius: CGFloat = DesignTokens.Radius.m
    ) {
        self.level = level
        self.cornerRadius = cornerRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, DesignTokens.Spacing.l)
            .padding(.vertical, DesignTokens.Spacing.m)
            .background {
                ZStack {
                    GlassSurface(level: level, cornerRadius: cornerRadius, shadowEnabled: !configuration.isPressed)
                    
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.black.opacity(0.1))
                    }
                }
            }
            .scaleEffect(configuration.isPressed ? DesignTokens.Motion.pressScale : 1.0)
            .animation(DesignTokens.Motion.snappy, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == GlassButtonStyle {
    static var glass: GlassButtonStyle { GlassButtonStyle() }
    
    static func glass(
        level: GlassMaterialLevel = .regular,
        cornerRadius: CGFloat = DesignTokens.Radius.m
    ) -> GlassButtonStyle {
        GlassButtonStyle(level: level, cornerRadius: cornerRadius)
    }
}

/// A ready-to-use Glass Button component.
public struct GlassButton: View {
    let title: String
    let action: () -> Void
    let level: GlassMaterialLevel
    
    public init(
        _ title: String,
        level: GlassMaterialLevel = .regular,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.level = level
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .buttonStyle(.glass(level: level))
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            GlassButton("Interactive Glass") {
                print("Tapped!")
            }
            
            Button("Custom Label") {
                print("Custom tapped")
            }
            .buttonStyle(.glass(level: .ultraThin, cornerRadius: 20))
        }
    }
}
