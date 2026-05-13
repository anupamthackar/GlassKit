import SwiftUI

/// A protocol for components that support themeable styling via the environment.
public protocol GlassViewStyle: Sendable {
    associatedtype Content: View
    @ViewBuilder func makeBody(configuration: Configuration) -> Content
    
    typealias Configuration = GlassViewStyleConfiguration
}

public struct GlassViewStyleConfiguration {
    public let label: AnyView
    public let isPressed: Bool
}

/// A button style that supports the GlassKit design system tokens.
public struct NovaButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    
    let level: GlassMaterialLevel
    
    public init(level: GlassMaterialLevel = .regular) {
        self.level = level
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignTokens.Typography.headline)
            .padding(.horizontal, DesignTokens.Spacing.l)
            .padding(.vertical, DesignTokens.Spacing.m)
            .background {
                LiquidContainer(elevation: configuration.isPressed ? .base : .elevated) {
                    EmptyView()
                }
            }
            .scaleEffect(configuration.isPressed ? DesignTokens.Motion.pressScale : 1.0)
            .animation(DesignTokens.Motion.snappy, value: configuration.isPressed)
    }
}
