import SwiftUI

/// A container view that provides a glass-morphic background for its content.
public struct GlassCard<Content: View>: View {
    let level: GlassMaterialLevel
    let cornerRadius: CGFloat
    let padding: CGFloat
    let content: Content
    
    public init(
        level: GlassMaterialLevel = .regular,
        cornerRadius: CGFloat = DesignTokens.Radius.l,
        padding: CGFloat = DesignTokens.Spacing.l,
        @ViewBuilder content: () -> Content
    ) {
        self.level = level
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(padding)
            .background {
                GlassSurface(level: level, cornerRadius: cornerRadius)
            }
    }
}

public extension View {
    /// Wraps the view in a glass-morphic card.
    func glassCard(
        level: GlassMaterialLevel = .regular,
        cornerRadius: CGFloat = DesignTokens.Radius.l,
        padding: CGFloat = DesignTokens.Spacing.l
    ) -> some View {
        GlassCard(level: level, cornerRadius: cornerRadius, padding: padding) {
            self
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        Circle()
            .fill(Color.orange)
            .frame(width: 150, height: 150)
            .blur(radius: 50)
            .offset(x: 50, y: -50)
        
        VStack {
            GlassCard(level: .thin) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("NovaUI Glass Card")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Liquid glass design system for professional Apple platform applications.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    GlassButton("Get Started") {
                        print("Started")
                    }
                    .padding(.top, 10)
                }
            }
            .frame(width: 300)
        }
    }
}
