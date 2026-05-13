import SwiftUI

/// A centralized motion engine for consistent animations across the framework.
public struct MotionEngine {
    
    /// Returns the appropriate animation based on the motion intent.
    public static func animation(for intent: MotionIntent) -> Animation {
        switch intent {
        case .standard: return DesignTokens.Motion.smooth
        case .interaction: return DesignTokens.Motion.interactive
        case .feedback: return DesignTokens.Motion.snappy
        }
    }
    
    public enum MotionIntent {
        case standard
        case interaction
        case feedback
    }
}

public extension View {
    /// Applies a motion-reactive hover effect to a view.
    func motionHoverEffect() -> some View {
        self.modifier(MotionHoverModifier())
    }
}

private struct MotionHoverModifier: ViewModifier {
    @State private var isHovered = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovered ? DesignTokens.Motion.hoverScale : 1.0)
            .animation(MotionEngine.animation(for: .interaction), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}
