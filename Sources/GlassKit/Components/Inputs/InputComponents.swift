import SwiftUI

// MARK: - SearchBar

/// A glass-morphic search bar with focus animations.
///
/// ```swift
/// SearchBar(text: $query, placeholder: "Search components…")
/// ```
public struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    @FocusState private var isFocused: Bool
    
    public init(text: Binding<String>, placeholder: String = "Search…") {
        self._text = text; self.placeholder = placeholder
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField(placeholder, text: $text).focused($isFocused)
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
        .background { GlassSurface(level: isFocused ? .thin : .ultraThin, cornerRadius: DesignTokens.Radius.l) }
        .overlay {
            if isFocused {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.l).stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
            }
        }
        .animation(DesignTokens.Motion.snappy, value: isFocused)
    }
}

// MARK: - OTPInputField

/// A one-time-password input field with individual digit cells.
///
/// ```swift
/// OTPInputField(code: $otpCode, length: 6)
/// ```
public struct OTPInputField: View {
    @Binding var code: String
    let length: Int
    @FocusState private var isFocused: Bool
    
    public init(code: Binding<String>, length: Int = 6) {
        self._code = code; self.length = length
    }
    
    public var body: some View {
        ZStack {
            TextField("", text: $code).focused($isFocused)
                #if canImport(UIKit)
                .keyboardType(.numberPad)
                #endif
                .frame(width: 0, height: 0).opacity(0)
            
            HStack(spacing: 8) {
                ForEach(0..<length, id: \.self) { i in
                    let char = i < code.count ? String(code[code.index(code.startIndex, offsetBy: i)]) : ""
                    Text(char)
                        .font(Font.system(size: 24, weight: .bold))
                        .monospaced()
                        .frame(width: 44, height: 54)
                        .background { GlassSurface(level: char.isEmpty ? .ultraThin : .thin, cornerRadius: DesignTokens.Radius.m) }
                        .overlay {
                            if i == code.count && isFocused {
                                RoundedRectangle(cornerRadius: DesignTokens.Radius.m).stroke(Color.accentColor, lineWidth: 2)
                            }
                        }
                }
            }
            .onTapGesture { isFocused = true }
        }
        .onChange(of: code) { _, new in
            if new.count > length { code = String(new.prefix(length)) }
        }
    }
}

// MARK: - ValidationTextField

/// A text field with inline validation feedback.
///
/// ```swift
/// ValidationTextField("Email", text: $email, validation: .email, errorMessage: "Invalid email")
/// ```
public struct ValidationTextField: View {
    let label: String
    @Binding var text: String
    let validation: ValidationType
    let errorMessage: String
    @State private var isValid = true
    @FocusState private var isFocused: Bool
    
    public enum ValidationType { case email, minLength(Int), custom((String) -> Bool) }
    
    public init(_ label: String, text: Binding<String>, validation: ValidationType, errorMessage: String) {
        self.label = label; self._text = text; self.validation = validation; self.errorMessage = errorMessage
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            GlassTextField(label, text: $text)
                .focused($isFocused)
            if !isValid && !text.isEmpty {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption).foregroundStyle(.red)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: text) { _, new in
            withAnimation(DesignTokens.Motion.snappy) { isValid = validate(new) }
        }
    }
    
    private func validate(_ value: String) -> Bool {
        switch validation {
        case .email: return value.contains("@") && value.contains(".")
        case .minLength(let n): return value.count >= n
        case .custom(let fn): return fn(value)
        }
    }
}

// MARK: - CurrencyInput

/// A formatted currency input field with locale-aware display.
///
/// ```swift
/// CurrencyInput(value: $amount, currencySymbol: "$")
/// ```
public struct CurrencyInput: View {
    @Binding var value: Double
    let currencySymbol: String
    @State private var text = ""
    
    public init(value: Binding<Double>, currencySymbol: String = "$") {
        self._value = value; self.currencySymbol = currencySymbol
    }
    
    public var body: some View {
        HStack {
            Text(currencySymbol).font(.title2.weight(.semibold)).foregroundStyle(.secondary)
            TextField("0.00", text: $text)
                #if canImport(UIKit)
                .keyboardType(.decimalPad)
                #endif
                .font(Font.system(size: 28, weight: .bold))
                .monospaced()
                .onChange(of: text) { _, new in value = Double(new) ?? 0 }
        }
        .padding().background { GlassSurface(level: .thin, cornerRadius: DesignTokens.Radius.m) }
        .onAppear { text = value > 0 ? String(format: "%.2f", value) : "" }
    }
}

// MARK: - AutoGrowingTextEditor

/// A text editor that expands vertically to fit its content.
///
/// ```swift
/// AutoGrowingTextEditor(text: $notes, placeholder: "Write your notes…")
/// ```
public struct AutoGrowingTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let minHeight: CGFloat
    let maxHeight: CGFloat
    
    public init(text: Binding<String>, placeholder: String = "Type here…", minHeight: CGFloat = 44, maxHeight: CGFloat = 200) {
        self._text = text; self.placeholder = placeholder; self.minHeight = minHeight; self.maxHeight = maxHeight
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder).foregroundStyle(.tertiary).padding(.horizontal, 4).padding(.top, 8)
            }
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .frame(minHeight: minHeight, maxHeight: maxHeight)
        }
        .padding(DesignTokens.Spacing.s)
        .background { GlassSurface(level: .ultraThin, cornerRadius: DesignTokens.Radius.m) }
    }
}

// MARK: - TokenInputField

/// An input field that converts typed text into removable token chips.
///
/// ```swift
/// TokenInputField(tokens: $tags, placeholder: "Add tags…")
/// ```
public struct TokenInputField: View {
    @Binding var tokens: [String]
    let placeholder: String
    @State private var currentText = ""
    
    public init(tokens: Binding<[String]>, placeholder: String = "Add item…") {
        self._tokens = tokens; self.placeholder = placeholder
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FlowLayout(spacing: 6) {
                ForEach(tokens, id: \.self) { token in
                    HStack(spacing: 4) {
                        Text(token).font(.caption)
                        Button { withAnimation { tokens.removeAll { $0 == token } } } label: {
                            Image(systemName: "xmark.circle.fill").font(.caption2)
                        }
                    }
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background { GlassSurface(level: .thin, cornerRadius: 12) }
                }
            }
            TextField(placeholder, text: $currentText)
                .onSubmit {
                    guard !currentText.isEmpty else { return }
                    withAnimation { tokens.append(currentText) }
                    currentText = ""
                }
        }
        .padding(DesignTokens.Spacing.s)
        .background { GlassSurface(level: .ultraThin, cornerRadius: DesignTokens.Radius.m) }
    }
}

/// A simple flow layout for chips and tokens.
public struct FlowLayout: Layout {
    let spacing: CGFloat
    public init(spacing: CGFloat = 8) { self.spacing = spacing }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }
    
    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0; var y: CGFloat = 0; var rowHeight: CGFloat = 0
        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 { x = 0; y += rowHeight + spacing; rowHeight = 0 }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
        return (positions, CGSize(width: maxWidth, height: y + rowHeight))
    }
}

// MARK: - FloatingLabelInput
public struct FloatingLabelInput: View {
    let title: String
    @Binding var text: String
    
    public init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    public var body: some View {
        GlassTextField(title, text: $text)
    }
}

// MARK: - SecureInputField
public struct SecureInputField: View {
    let title: String
    @Binding var text: String
    @State private var isVisible = false
    
    public init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    public var body: some View {
        HStack {
            if isVisible {
                TextField(title, text: $text)
            } else {
                SecureField(title, text: $text)
            }
            Button { isVisible.toggle() } label: {
                Image(systemName: isVisible ? "eye.slash" : "eye")
            }
            .foregroundStyle(.secondary)
        }
        .padding()
        .glassCard()
    }
}

// MARK: - RichTextEditor
public struct RichTextEditor: View {
    @Binding var text: String
    public init(text: Binding<String>) { self._text = text }
    public var body: some View {
        TextEditor(text: $text)
            .scrollContentBackground(.hidden)
            .padding()
            .glassCard()
    }
}

// MARK: - CocoaTextField
public struct CocoaTextField: View {
    let title: String
    @Binding var text: String
    public init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    public var body: some View {
        GlassTextField(title, text: $text)
    }
}
