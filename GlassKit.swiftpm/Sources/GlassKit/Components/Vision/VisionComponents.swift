import SwiftUI

// MARK: - SpatialGlassPanel

/// A panel that leverages depth and hover effects typical of visionOS.
///
/// ```swift
/// SpatialGlassPanel {
///     Text("Immersive Content")
/// }
/// ```
public struct SpatialGlassPanel<Content: View>: View {
    let content: Content
    @State private var isHovering = false
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(24)
            .background {
                GlassSurface(level: isHovering ? .thick : .regular, cornerRadius: DesignTokens.Radius.xxl)
            }
            .scaleEffect(isHovering ? 1.02 : 1.0)
            .elevationShadow(isHovering ? .floating : .elevated)
            .onHover { hovering in
                withAnimation(DesignTokens.Motion.smooth) {
                    isHovering = hovering
                }
            }
    }
}

// MARK: - DepthAwareContainer

/// A container that offsets its content along the Z-axis based on interaction.
///
/// ```swift
/// DepthAwareContainer(depth: 20) {
///     Text("Floating Layer")
/// }
/// ```
public struct DepthAwareContainer<Content: View>: View {
    let depth: CGFloat
    let content: Content
    
    public init(depth: CGFloat = 10, @ViewBuilder content: () -> Content) {
        self.depth = depth
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            // Shadow layer
            content
                .opacity(0)
                .elevationShadow(.floating)
                .offset(y: depth)
            
            content
                .background {
                    GlassSurface(level: .thin, cornerRadius: DesignTokens.Radius.l)
                }
        }
    }
}

// MARK: - OrbitalMenu

/// A circular menu that expands around a central button.
///
/// ```swift
/// OrbitalMenu(isExpanded: $open, items: [
///     .init(icon: "pencil", action: { ... }),
///     .init(icon: "trash", action: { ... })
/// ])
/// ```
public struct OrbitalMenu: View {
    public struct MenuItem: Identifiable {
        public let id = UUID()
        public let icon: String
        public let action: () -> Void
        public init(icon: String, action: @escaping () -> Void) {
            self.icon = icon; self.action = action
        }
    }
    
    @Binding var isExpanded: Bool
    let items: [MenuItem]
    
    public init(isExpanded: Binding<Bool>, items: [MenuItem]) {
        self._isExpanded = isExpanded
        self.items = items
    }
    
    public var body: some View {
        ZStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { i, item in
                Button(action: item.action) {
                    Image(systemName: item.icon)
                        .font(.title2)
                        .frame(width: 50, height: 50)
                        .background {
                            GlassSurface(level: .thick, cornerRadius: 25)
                        }
                }
                .offset(x: isExpanded ? cos(CGFloat(i) * .pi / CGFloat(items.count - 1)) * 100 : 0,
                        y: isExpanded ? -sin(CGFloat(i) * .pi / CGFloat(items.count - 1)) * 100 : 0)
                .opacity(isExpanded ? 1 : 0)
                .buttonStyle(.plain)
            }
            
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isExpanded.toggle()
                }
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                    .frame(width: 64, height: 64)
                    .background {
                        GlassSurface(level: .ultraThick, cornerRadius: 32)
                    }
            }
            .buttonStyle(.plain)
        }
    }
}
