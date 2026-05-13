import SwiftUI

// MARK: - AdaptiveBlurView

/// A view that applies a configurable, platform-adaptive blur effect.
///
/// Use `AdaptiveBlurView` to wrap any content in a blur layer that automatically
/// adjusts its intensity based on the current color scheme.
///
/// ```swift
/// AdaptiveBlurView(intensity: .medium) {
///     Text("Blurred content behind me")
/// }
/// ```
public struct AdaptiveBlurView<Content: View>: View {
    /// The blur intensity preset.
    public enum Intensity: CGFloat, Sendable {
        case light = 5
        case medium = 15
        case heavy = 30
    }
    
    let intensity: Intensity
    let content: Content
    
    /// Creates an adaptive blur view.
    /// - Parameters:
    ///   - intensity: The blur intensity level. Defaults to `.medium`.
    ///   - content: The view to display behind the blur.
    public init(intensity: Intensity = .medium, @ViewBuilder content: () -> Content) {
        self.intensity = intensity
        self.content = content()
    }
    
    public var body: some View {
        content
            .blur(radius: intensity.rawValue)
            .overlay(.ultraThinMaterial.opacity(0.3))
    }
}

// MARK: - DynamicCornerRadius

/// A shape with independently configurable corner radii for each corner.
///
/// ```swift
/// DynamicCornerRadius(topLeft: 20, topRight: 20, bottomLeft: 8, bottomRight: 8)
///     .fill(.blue)
///     .frame(height: 100)
/// ```
public struct DynamicCornerRadius: Shape {
    public var topLeft: CGFloat
    public var topRight: CGFloat
    public var bottomLeft: CGFloat
    public var bottomRight: CGFloat
    
    public init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY), tangent2End: CGPoint(x: rect.maxX, y: rect.minY + topRight), radius: topRight)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY), tangent2End: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY), radius: bottomRight)
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY), tangent2End: CGPoint(x: rect.minX, y: rect.maxY - bottomLeft), radius: bottomLeft)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY), tangent2End: CGPoint(x: rect.minX + topLeft, y: rect.minY), radius: topLeft)
        path.closeSubpath()
        return path
    }
    
    public var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get { AnimatablePair(AnimatablePair(topLeft, topRight), AnimatablePair(bottomLeft, bottomRight)) }
        set {
            topLeft = newValue.first.first
            topRight = newValue.first.second
            bottomLeft = newValue.second.first
            bottomRight = newValue.second.second
        }
    }
}

// MARK: - MorphingShape

/// A shape that smoothly animates between circle and rounded rectangle.
///
/// ```swift
/// MorphingShape(morphProgress: isExpanded ? 1.0 : 0.0)
///     .fill(.purple)
///     .frame(width: 100, height: 100)
///     .animation(.spring, value: isExpanded)
/// ```
public struct MorphingShape: Shape {
    /// 0.0 = circle, 1.0 = rounded rectangle
    public var morphProgress: CGFloat
    
    public init(morphProgress: CGFloat = 0) {
        self.morphProgress = morphProgress
    }
    
    public var animatableData: CGFloat {
        get { morphProgress }
        set { morphProgress = newValue }
    }
    
    public func path(in rect: CGRect) -> Path {
        let minDim = min(rect.width, rect.height)
        let maxRadius = minDim / 2
        let minRadius = minDim * 0.2
        let radius = maxRadius - (maxRadius - minRadius) * morphProgress
        return Path(roundedRect: rect, cornerRadius: radius)
    }
}

// MARK: - ElevationShadow

/// A view modifier that applies token-based elevation shadows.
///
/// ```swift
/// Text("Elevated")
///     .padding()
///     .background(.ultraThinMaterial)
///     .elevationShadow(.floating)
/// ```
public struct ElevationShadowModifier: ViewModifier {
    let level: DesignTokens.Elevation
    
    public func body(content: Content) -> some View {
        let s = level.shadow
        content.shadow(color: s.color, radius: s.radius, x: s.x, y: s.y)
    }
}

public extension View {
    /// Applies a token-based elevation shadow.
    /// - Parameter level: The elevation level determining shadow depth.
    func elevationShadow(_ level: DesignTokens.Elevation) -> some View {
        modifier(ElevationShadowModifier(level: level))
    }
}

// MARK: - AdaptiveLayoutEngine

/// An engine that provides adaptive layout breakpoints for responsive design.
///
/// ```swift
/// AdaptiveLayoutEngine.LayoutContainer { sizeClass in
///     if sizeClass == .compact {
///         VStack { content }
///     } else {
///         HStack { content }
///     }
/// }
/// ```
public enum AdaptiveLayoutEngine {
    public enum SizeClass { case compact, regular, large }
    
    public struct LayoutContainer<Content: View>: View {
        @Environment(\.horizontalSizeClass) private var hSize
        let content: (SizeClass) -> Content
        
        public init(@ViewBuilder content: @escaping (SizeClass) -> Content) {
            self.content = content
        }
        
        public var body: some View {
            GeometryReader { geo in
                let sizeClass: SizeClass = geo.size.width < 500 ? .compact : (geo.size.width < 900 ? .regular : .large)
                content(sizeClass)
            }
        }
    }
}
