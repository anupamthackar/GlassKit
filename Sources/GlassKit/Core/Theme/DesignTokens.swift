import SwiftUI

/// Foundation tokens for the GlassKit (NovaUI) Design System.
public enum DesignTokens {
    
    /// Spacing hierarchy based on an 8pt grid system.
    /// Use these for consistent margins, padding, and stack spacing.
    public enum Spacing {
        /// 2pt spacing
        public static let xxs: CGFloat = 2
        /// 4pt spacing
        public static let xs: CGFloat = 4
        /// 8pt spacing
        public static let s: CGFloat = 8
        /// 12pt spacing
        public static let m: CGFloat = 12
        /// 16pt spacing
        public static let l: CGFloat = 16
        /// 20pt spacing
        public static let xl: CGFloat = 20
        /// 24pt spacing
        public static let xxl: CGFloat = 24
        /// 32pt spacing
        public static let xxxl: CGFloat = 32
        /// 48pt spacing
        public static let huge: CGFloat = 48
        /// 64pt spacing
        public static let massive: CGFloat = 64
    }
    
    /// Radius tokens for consistent corner rounding across the system.
    public enum Radius {
        /// No rounding (0pt)
        public static let none: CGFloat = 0
        /// Extra small rounding (4pt)
        public static let xs: CGFloat = 4
        /// Small rounding (8pt)
        public static let s: CGFloat = 8
        /// Medium rounding (12pt)
        public static let m: CGFloat = 12
        /// Large rounding (16pt)
        public static let l: CGFloat = 16
        /// Extra large rounding (24pt)
        public static let xl: CGFloat = 24
        /// Double extra large rounding (32pt)
        public static let xxl: CGFloat = 32
        /// Full circular rounding (999pt)
        public static let full: CGFloat = 999
    }
    
    /// Typography tokens using standard Apple Dynamic Type scales.
    public enum Typography {
        public static let hero = Font.system(size: 44, weight: .bold, design: .rounded)
        public static let titleLarge = Font.system(.title, design: .rounded).weight(.bold)
        public static let title = Font.system(.title2, design: .rounded).weight(.semibold)
        public static let headline = Font.system(.headline, design: .rounded)
        public static let body = Font.system(.body, design: .default)
        public static let callout = Font.system(.callout, design: .default)
        public static let caption = Font.system(.caption, design: .default)
    }
    
    /// Elevation and Depth tokens.
    public enum Elevation: Hashable {
        case base
        case elevated
        case floating
        case modal
        
        public var zIndex: Double {
            switch self {
            case .base: return 0
            case .elevated: return 10
            case .floating: return 50
            case .modal: return 100
            }
        }
        
        public var shadow: ShadowToken {
            switch self {
            case .base: return .none
            case .elevated: return ShadowToken(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            case .floating: return ShadowToken(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            case .modal: return ShadowToken(color: .black.opacity(0.2), radius: 40, x: 0, y: 20)
            }
        }
    }
    
    /// Motion tokens for centralized animation control.
    public enum Motion {
        public static let snappy = Animation.spring(response: 0.2, dampingFraction: 0.7, blendDuration: 0)
        public static let smooth = Animation.spring(response: 0.35, dampingFraction: 0.8, blendDuration: 0)
        public static let interactive = Animation.interactiveSpring(response: 0.15, dampingFraction: 0.8, blendDuration: 0)
        public static let responsive = Animation.spring(response: 0.25, dampingFraction: 0.75, blendDuration: 0)
        
        public static let pressScale: CGFloat = 0.95
        public static let hoverScale: CGFloat = 1.02
    }
    
    /// Opacity levels for overlays and glass effects.
    public enum Opacity {
        public static let glass: CGFloat = 0.4
        public static let secondary: CGFloat = 0.6
        public static let tertiary: CGFloat = 0.3
        public static let disabled: CGFloat = 0.2
    }
    
    /// Blur tokens for glass materials.
    public enum Blur {
        public static let ultraThin: CGFloat = 5
        public static let thin: CGFloat = 10
        public static let regular: CGFloat = 20
        public static let thick: CGFloat = 30
        public static let ultraThick: CGFloat = 40
    }
    
    /// Gradient tokens for premium backgrounds.
    public enum Gradients {
        public static let glassHighlight = LinearGradient(
            colors: [.white.opacity(0.5), .white.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let glassShadow = LinearGradient(
            colors: [.black.opacity(0.05), .clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

/// A structure to represent a shadow token.
public struct ShadowToken: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public static let none = ShadowToken(color: .clear, radius: 0, x: 0, y: 0)
}

/// Semantic Color Tokens.
public protocol ColorPalette: Sendable {
    var foregroundPrimary: Color { get }
    var foregroundSecondary: Color { get }
    var foregroundTertiary: Color { get }
    
    var backgroundPrimary: Color { get }
    var backgroundSecondary: Color { get }
    var backgroundElevated: Color { get }
    
    var surfaceGlass: Color { get }
    var surfaceInteractive: Color { get }
    var surfaceDestructive: Color { get }
    
    var outlinePrimary: Color { get }
    var outlineSecondary: Color { get }
    
    var accentPrimary: Color { get }
    var accentDanger: Color { get }
    
    var success: Color { get }
    var warning: Color { get }
    var info: Color { get }
}

/// Default implementation of the Liquid Glass Color Palette.
public struct DefaultColorPalette: ColorPalette {
    public init() {}
    
    public let foregroundPrimary = Color.primary
    public let foregroundSecondary = Color.secondary
    public let foregroundTertiary = Color.secondary.opacity(0.6)
    
    public let backgroundPrimary = Color.systemBackground
    public let backgroundSecondary = Color.secondarySystemBackground
    public let backgroundElevated = Color.tertiarySystemBackground
    
    public let surfaceGlass = Color.white.opacity(0.1)
    public let surfaceInteractive = Color.blue.opacity(0.1)
    public let surfaceDestructive = Color.red.opacity(0.1)
    
    public let accentPrimary = Color.blue
    public let accentDanger = Color.red
    
    public let success = Color.green
    public let warning = Color.orange
    public let info = Color.blue
    
    public let outlinePrimary = Color.primary.opacity(0.15)
    public let outlineSecondary = Color.primary.opacity(0.08)
}

#if canImport(UIKit)
import UIKit
extension Color {
    static let systemBackground = Color(uiColor: .systemBackground)
    static let secondarySystemBackground = Color(uiColor: .secondarySystemBackground)
    static let tertiarySystemBackground = Color(uiColor: .tertiarySystemBackground)
}
#elseif canImport(AppKit)
import AppKit
extension Color {
    static let systemBackground = Color(nsColor: .windowBackgroundColor)
    static let secondarySystemBackground = Color(nsColor: .controlBackgroundColor)
    static let tertiarySystemBackground = Color(nsColor: .underPageBackgroundColor)
}
#else
extension Color {
    static let systemBackground = Color.white
    static let secondarySystemBackground = Color.gray.opacity(0.1)
    static let tertiarySystemBackground = Color.gray.opacity(0.2)
}
#endif
