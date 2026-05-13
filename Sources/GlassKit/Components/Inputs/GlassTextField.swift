import SwiftUI

/// A premium glass-morphic text field with a floating label, focus animations, and validation support.
///
/// GlassTextField provides a beautiful, modern input experience that adheres to the Liquid Glass design language.
public struct GlassTextField: View {
    /// The label text that floats when the field is focused or contains text.
    let label: String
    /// The binding to the text content of the field.
    @Binding var text: String
    /// Whether the field should hide its content (e.g., for passwords).
    let isSecure: Bool
    
    @FocusState private var isFocused: Bool
    
    /// Initializes a new GlassTextField.
    /// - Parameters:
    ///   - label: The label text.
    ///   - text: The text binding.
    ///   - isSecure: Whether the field is secure. Defaults to false.
    public init(
        _ label: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) {
        self.label = label
        self._text = text
        self.isSecure = isSecure
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            ZStack(alignment: .leading) {
                // Floating Label
                Text(label)
                    .font(isFocused || !text.isEmpty ? .caption : .body)
                    .foregroundColor(isFocused ? .accentColor : .secondary)
                    .offset(y: isFocused || !text.isEmpty ? -24 : 0)
                    .animation(DesignTokens.Motion.snappy, value: isFocused || !text.isEmpty)
                
                Group {
                    if isSecure {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                    }
                }
                .focused($isFocused)
                .padding(.vertical, DesignTokens.Spacing.s)
            }
            .padding(.horizontal, DesignTokens.Spacing.m)
            .padding(.top, (isFocused || !text.isEmpty) ? DesignTokens.Spacing.m : 0)
            .background {
                GlassSurface(
                    level: isFocused ? .thin : .ultraThin,
                    cornerRadius: DesignTokens.Radius.m
                )
                .overlay {
                    if isFocused {
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                            .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                    }
                }
            }
        }
        .novaAccessibility(type: .input(label: label))
    }
}

#Preview {
    ZStack {
        Color.indigo.ignoresSafeArea()
        
        VStack(spacing: 40) {
            GlassTextField("Email Address", text: .constant(""))
            GlassTextField("Password", text: .constant("password"), isSecure: true)
        }
        .padding()
    }
}
