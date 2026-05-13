import SwiftUI

// MARK: - FloatingActionButton

/// A premium glass-morphic floating action button with spring animation.
///
/// ```swift
/// FloatingActionButton(icon: "plus") {
///     showNewItem = true
/// }
/// ```
public struct FloatingActionButton: View {
    let icon: String
    let size: CGFloat
    let action: () -> Void
    
    /// - Parameters:
    ///   - icon: SF Symbol name for the button icon.
    ///   - size: The diameter of the button. Defaults to 56.
    ///   - action: The action to perform on tap.
    public init(icon: String, size: CGFloat = 56, action: @escaping () -> Void) {
        self.icon = icon; self.size = size; self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: size, height: size)
                .background { GlassSurface(level: .regular, cornerRadius: size / 2) }
                .clipShape(Circle())
                .elevationShadow(.floating)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - AsyncLoadingButton

/// A button that shows a loading spinner while an async task runs.
///
/// ```swift
/// AsyncLoadingButton("Save", isLoading: $isSaving) {
///     await saveData()
/// }
/// ```
public struct AsyncLoadingButton: View {
    let title: String
    @Binding var isLoading: Bool
    let action: () -> Void
    
    public init(_ title: String, isLoading: Binding<Bool>, action: @escaping () -> Void) {
        self.title = title; self._isLoading = isLoading; self.action = action
    }
    
    public var body: some View {
        Button(action: { if !isLoading { action() } }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().tint(.primary)
                }
                Text(isLoading ? "Loading…" : title)
                    .font(.headline)
            }
            .foregroundStyle(.primary)
        }
        .buttonStyle(.glass(level: isLoading ? .thin : .regular))
        .disabled(isLoading)
        .opacity(isLoading ? 0.7 : 1)
        .animation(DesignTokens.Motion.smooth, value: isLoading)
    }
}

// MARK: - IconButton

/// A compact glass icon-only button.
///
/// ```swift
/// IconButton("heart.fill", tint: .pink) { toggleFavorite() }
/// ```
public struct IconButton: View {
    let icon: String
    let tint: Color
    let size: CGFloat
    let action: () -> Void
    
    public init(_ icon: String, tint: Color = .primary, size: CGFloat = 44, action: @escaping () -> Void) {
        self.icon = icon; self.tint = tint; self.size = size; self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4))
                .foregroundStyle(tint)
                .frame(width: size, height: size)
                .background { GlassSurface(level: .thin, cornerRadius: size / 4) }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - SegmentedPill

/// A glass-morphic segmented control with matched geometry transitions.
///
/// ```swift
/// SegmentedPill(selection: $mode, options: ["List", "Grid", "Map"])
/// ```
public struct SegmentedPill: View {
    @Binding var selection: Int
    let options: [String]
    @Namespace private var ns
    
    public init(selection: Binding<Int>, options: [String]) {
        self._selection = selection; self.options = options
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(options.enumerated()), id: \.offset) { i, opt in
                Text(opt)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(selection == i ? .primary : .secondary)
                    .padding(.vertical, 8).padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background {
                        if selection == i {
                            GlassSurface(level: .thin, cornerRadius: DesignTokens.Radius.m)
                                .matchedGeometryEffect(id: "seg", in: ns)
                        }
                    }
                    .onTapGesture {
                        withAnimation(DesignTokens.Motion.snappy) { selection = i }
                    }
            }
        }
        .padding(4)
        .background { GlassSurface(level: .ultraThin, cornerRadius: DesignTokens.Radius.l) }
    }
}

// MARK: - GlassToggle (CheckboxToggleStyle + SwitchToggle)

/// A glass-morphic toggle switch with smooth animation.
///
/// ```swift
/// GlassToggle("Enable Notifications", isOn: $notificationsOn)
/// ```
public struct GlassToggle: View {
    let label: String
    @Binding var isOn: Bool
    
    public init(_ label: String, isOn: Binding<Bool>) {
        self.label = label; self._isOn = isOn
    }
    
    public var body: some View {
        HStack {
            Text(label).font(DesignTokens.Typography.body)
            Spacer()
            Capsule()
                .fill(isOn ? Color.accentColor.opacity(0.3) : Color.secondary.opacity(0.2))
                .frame(width: 50, height: 28)
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle()
                        .fill(.ultraThickMaterial)
                        .frame(width: 24, height: 24)
                        .padding(2)
                        .shadow(radius: 2)
                }
                .onTapGesture {
                    withAnimation(DesignTokens.Motion.snappy) { isOn.toggle() }
                }
        }
        .padding(.horizontal, DesignTokens.Spacing.m)
        .padding(.vertical, DesignTokens.Spacing.s)
        .background { GlassSurface(level: .ultraThin, cornerRadius: DesignTokens.Radius.m) }
    }
}

// MARK: - RadioButton

/// A glass-morphic radio button for single-choice selection.
///
/// ```swift
/// RadioButton("Option A", isSelected: selectedOption == "A") {
///     selectedOption = "A"
/// }
/// ```
public struct RadioButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    public init(_ label: String, isSelected: Bool, action: @escaping () -> Void) {
        self.label = label; self.isSelected = isSelected; self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Circle()
                    .stroke(isSelected ? Color.accentColor : .secondary, lineWidth: 2)
                    .frame(width: 22, height: 22)
                    .overlay {
                        if isSelected {
                            Circle().fill(Color.accentColor).frame(width: 12, height: 12)
                                .transition(.scale)
                        }
                    }
                Text(label).foregroundStyle(.primary)
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .animation(DesignTokens.Motion.snappy, value: isSelected)
    }
}

// MARK: - FatSlider

/// A large, thumb-heavy glass slider for bold controls.
///
/// ```swift
/// FatSlider(value: $volume, range: 0...100, tint: .green)
/// ```
public struct FatSlider: View {
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let tint: Color
    
    public init(value: Binding<CGFloat>, range: ClosedRange<CGFloat> = 0...1, tint: Color = .accentColor) {
        self._value = value; self.range = range; self.tint = tint
    }
    
    public var body: some View {
        GeometryReader { geo in
            let pct = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            ZStack(alignment: .leading) {
                Capsule().fill(.ultraThinMaterial).frame(height: 12)
                Capsule().fill(tint).frame(width: max(24, geo.size.width * pct), height: 12)
                Circle()
                    .fill(.ultraThickMaterial)
                    .frame(width: 28, height: 28)
                    .elevationShadow(.elevated)
                    .offset(x: max(0, min(geo.size.width - 28, geo.size.width * pct - 14)))
            }
            .gesture(DragGesture(minimumDistance: 0).onChanged { drag in
                let pct = max(0, min(1, drag.location.x / geo.size.width))
                value = range.lowerBound + (range.upperBound - range.lowerBound) * pct
            })
        }
        .frame(height: 28)
    }
}

// MARK: - StepSlider

/// A discrete-step slider with snapping behavior.
///
/// ```swift
/// StepSlider(value: $rating, steps: 5, labels: ["1","2","3","4","5"])
/// ```
public struct StepSlider: View {
    @Binding var value: Int
    let steps: Int
    let labels: [String]?
    
    public init(value: Binding<Int>, steps: Int, labels: [String]? = nil) {
        self._value = value; self.steps = steps; self.labels = labels
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<steps, id: \.self) { step in
                Button {
                    withAnimation(DesignTokens.Motion.snappy) { value = step }
                } label: {
                    VStack(spacing: 4) {
                        Circle()
                            .fill(step <= value ? Color.accentColor : Color.secondary.opacity(0.3))
                            .frame(width: step == value ? 20 : 12, height: step == value ? 20 : 12)
                        if let labels, step < labels.count {
                            Text(labels[step]).font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - ReactionButton

/// An animated emoji reaction button with a pop effect.
///
/// ```swift
/// ReactionButton(emoji: "❤️", count: 42, isActive: $liked)
/// ```
public struct ReactionButton: View {
    let emoji: String
    @Binding var count: Int
    @Binding var isActive: Bool
    
    public init(emoji: String, count: Binding<Int>, isActive: Binding<Bool>) {
        self.emoji = emoji; self._count = count; self._isActive = isActive
    }
    
    public var body: some View {
        Button {
            withAnimation(DesignTokens.Motion.snappy) {
                isActive.toggle()
                count += isActive ? 1 : -1
            }
        } label: {
            HStack(spacing: 6) {
                Text(emoji).font(.title3)
                Text("\(count)").font(.caption.monospacedDigit()).foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background { GlassSurface(level: isActive ? .regular : .ultraThin, cornerRadius: 20) }
            .scaleEffect(isActive ? 1.1 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ScaleButtonStyle (Shared)

/// A reusable button style that applies a spring scale effect on press.
public struct ScaleButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? DesignTokens.Motion.pressScale : 1.0)
            .animation(DesignTokens.Motion.snappy, value: configuration.isPressed)
    }
}
