import SwiftUI

/// A GPU-optimized shimmer effect modifier.
public struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    ZStack {
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.3),
                                .init(color: .white.opacity(0.3), location: 0.5),
                                .init(color: .clear, location: 0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .rotationEffect(.degrees(30))
                        .offset(x: phase * geo.size.width * 2 - geo.size.width)
                    }
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

public extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}

/// A premium glass-morphic skeleton loader with an integrated GPU-optimized shimmer effect.
///
/// Use SkeletonLoader to represent content that is currently loading in a beautiful, non-intrusive way.
public struct SkeletonLoader: View {
    /// The width of the skeleton. If nil, it fills the available space.
    let width: CGFloat?
    /// The height of the skeleton. If nil, it fills the available space.
    let height: CGFloat?
    /// The corner radius of the skeleton block.
    let cornerRadius: CGFloat
    
    /// Initializes a new SkeletonLoader.
    /// - Parameters:
    ///   - width: Optional width.
    ///   - height: Optional height.
    ///   - cornerRadius: Corner radius. Defaults to DesignTokens.Radius.s.
    public init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = DesignTokens.Radius.s
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.ultraThinMaterial)
            .opacity(0.5)
            .frame(width: width, height: height)
            .shimmer()
    }
}

#Preview {
    VStack(spacing: 20) {
        SkeletonLoader(width: 200, height: 20)
        SkeletonLoader(width: 150, height: 20)
        SkeletonLoader(width: 250, height: 100)
    }
    .padding()
    .background(Color.blue)
}
