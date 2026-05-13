import SwiftUI

/// A premium container that implements layered depth, dynamic lighting, and environment-aware styling.
///
/// LiquidContainer is the primary building block for elevated UI elements in the GlassKit design system.
/// It automatically handles Z-indexing and elevation-based shadows.
public struct LiquidContainer<Content: View>: View {
    /// The elevation level which determines shadow depth and Z-index.
    let elevation: DesignTokens.Elevation
    /// The corner radius of the container.
    let cornerRadius: CGFloat
    /// The inner content of the container.
    let content: Content
    
    @Environment(\.colorScheme) private var colorScheme
    
    /// Initializes a new LiquidContainer.
    /// - Parameters:
    ///   - elevation: The elevation level (.base, .elevated, .floating, .modal). Defaults to .base.
    ///   - cornerRadius: The corner radius. Defaults to DesignTokens.Radius.l.
    ///   - content: A view builder producing the container's content.
    public init(
        elevation: DesignTokens.Elevation = .base,
        cornerRadius: CGFloat = DesignTokens.Radius.l,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    public var body: some View {
        content
            .background {
                ZStack {
                    // Base Glass Layer
                    GlassSurface(
                        level: elevation == .base ? .thin : .regular,
                        cornerRadius: cornerRadius,
                        shadowEnabled: false
                    )
                    
                    // Inner Glow / Specular Reflection
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(colorScheme == .dark ? 0.2 : 0.5),
                                    .clear,
                                    .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            }
            .elevation(elevation)
            .zIndex(elevation.zIndex)
    }
}

/// Modifier for applying elevation shadow and logic.
public struct ElevationModifier: ViewModifier {
    let elevation: DesignTokens.Elevation
    
    public func body(content: Content) -> some View {
        let shadow = elevation.shadow
        return content
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
    }
}

public extension View {
    func elevation(_ elevation: DesignTokens.Elevation) -> some View {
        self.modifier(ElevationModifier(elevation: elevation))
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        
        VStack(spacing: 30) {
            LiquidContainer(elevation: .base) {
                Text("Base Level")
                    .padding()
            }
            
            LiquidContainer(elevation: .floating) {
                Text("Floating Level")
                    .padding()
            }
        }
    }
}
