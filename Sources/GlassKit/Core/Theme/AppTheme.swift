import SwiftUI

/// The root theme protocol for AppleUIComponent (NovaUI).
public protocol AppTheme: Sendable {
    var colors: ColorPalette { get }
    var spacing: DesignTokens.Spacing.Type { get }
    var radius: DesignTokens.Radius.Type { get }
}

/// A default concrete implementation of AppTheme.
public struct DefaultTheme: AppTheme {
    public let colors: ColorPalette = DefaultColorPalette()
    public let spacing = DesignTokens.Spacing.self
    public let radius = DesignTokens.Radius.self
    
    public init() {}
}

/// Environment key for the theme.
public struct ThemeKey: EnvironmentKey {
    public static let defaultValue: AppTheme = DefaultTheme()
}

public extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
    
    var isGlassEnabled: Bool {
        get { self[GlassEnabledKey.self] }
        set { self[GlassEnabledKey.self] = newValue }
    }
}

public struct GlassEnabledKey: EnvironmentKey {
    public static let defaultValue: Bool = true
}


/// View modifier to provide a theme to a view hierarchy.
public struct ThemeProvider: ViewModifier {
    let theme: AppTheme
    
    public init(theme: AppTheme) {
        self.theme = theme
    }
    
    public func body(content: Content) -> some View {
        content
            .environment(\.theme, theme)
    }
}

public extension View {
    /// Applies a specific theme to the view hierarchy.
    func appTheme(_ theme: AppTheme) -> some View {
        self.modifier(ThemeProvider(theme: theme))
    }
}
