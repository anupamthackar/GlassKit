import SwiftUI

/// Defines the intensity of the glass material effect.
public enum GlassMaterialLevel: Sendable, Hashable {
    case ultraThin
    case thin
    case regular
    case thick
    case ultraThick
    
    var blurRadius: CGFloat {
        switch self {
        case .ultraThin: return 5
        case .thin: return 10
        case .regular: return 20
        case .thick: return 30
        case .ultraThick: return 40
        }
    }
    
    var opacity: CGFloat {
        switch self {
        case .ultraThin: return 0.1
        case .thin: return 0.2
        case .regular: return 0.3
        case .thick: return 0.5
        case .ultraThick: return 0.7
        }
    }
}

/// A primitive view that renders a glass-morphic surface.
public struct GlassSurface: View {
    @Environment(\.isGlassEnabled) private var isGlassEnabled
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.theme) private var theme
    
    let level: GlassMaterialLevel
    let cornerRadius: CGFloat
    let shadowEnabled: Bool
    
    public init(
        level: GlassMaterialLevel = .regular,
        cornerRadius: CGFloat = DesignTokens.Radius.m,
        shadowEnabled: Bool = true
    ) {
        self.level = level
        self.cornerRadius = cornerRadius
        self.shadowEnabled = shadowEnabled
    }
    
    public var body: some View {
        ZStack {
            if isGlassEnabled {
                // Background blur material
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(level.opacity)
                
                // Edge highlight (specular reflection)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .clear,
                                .black.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            } else {
                // Fallback solid color for normal theme mode
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(theme.colors.backgroundElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(theme.colors.outlinePrimary, lineWidth: 0.5)
                    )
            }
        }
        .background(
            ZStack {
                if shadowEnabled {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.black.opacity(0.1))
                        .blur(radius: 10)
                        .offset(y: 4)
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        
        VStack(spacing: 20) {
            GlassSurface(level: .ultraThin)
                .frame(width: 200, height: 100)
                .overlay(Text("Ultra Thin").foregroundColor(.white))
            
            GlassSurface(level: .regular)
                .frame(width: 200, height: 100)
                .overlay(Text("Regular").foregroundColor(.white))
            
            GlassSurface(level: .ultraThick)
                .frame(width: 200, height: 100)
                .overlay(Text("Ultra Thick").foregroundColor(.white))
        }
    }
}
