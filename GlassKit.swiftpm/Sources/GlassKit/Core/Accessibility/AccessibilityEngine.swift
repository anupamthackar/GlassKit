import SwiftUI

/// A centralized engine for handling accessibility preferences and logic.
public struct AccessibilityEngine {
    
    /// Provides semantic accessibility labels for glass components.
    public static func label(for type: ComponentType) -> String {
        switch type {
        case .button(let title): return title
        case .card: return "Glass card container"
        case .input(let label): return "\(label) input field"
        }
    }
    
    public enum ComponentType {
        case button(title: String)
        case card
        case input(label: String)
    }
}

public extension View {
    /// Applies standard accessibility traits for a NovaUI glass component.
    func novaAccessibility(type: AccessibilityEngine.ComponentType) -> some View {
        self.accessibilityElement(children: .combine)
            .accessibilityLabel(AccessibilityEngine.label(for: type))
    }
}
