import SwiftUI

// MARK: - GradientProgress

/// A progress bar with a customizable gradient and glass background.
///
/// ```swift
/// GradientProgress(value: 0.7, colors: [.blue, .purple])
/// ```
public struct GradientProgress: View {
    let value: Double
    let colors: [Color]
    
    public init(value: Double, colors: [Color] = [.blue, .cyan]) {
        self.value = value
        self.colors = colors
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.ultraThinMaterial)
                    .frame(height: 8)
                
                Capsule()
                    .fill(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                    .frame(width: geo.size.width * CGFloat(min(max(value, 0), 1)), height: 8)
                    .animation(DesignTokens.Motion.smooth, value: value)
            }
        }
        .frame(height: 8)
    }
}

// MARK: - OverlayToast

/// A self-dismissing toast message that overlays content.
///
/// ```swift
/// OverlayToast(message: "Settings Saved", isPresented: $showToast)
/// ```
public struct OverlayToast: View {
    let message: String
    @Binding var isPresented: Bool
    let icon: String?
    
    public init(message: String, isPresented: Binding<Bool>, icon: String? = "checkmark.circle.fill") {
        self.message = message
        self._isPresented = isPresented
        self.icon = icon
    }
    
    public var body: some View {
        if isPresented {
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    if let icon {
                        Image(systemName: icon)
                            .foregroundStyle(Color.accentColor)
                    }
                    Text(message)
                        .font(.subheadline.weight(.medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background {
                    GlassSurface(level: .thick, cornerRadius: DesignTokens.Radius.full)
                }
                .elevationShadow(.floating)
                .padding(.bottom, 50)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(DesignTokens.Motion.smooth) {
                        isPresented = false
                    }
                }
            }
            .animation(DesignTokens.Motion.smooth, value: isPresented)
        }
    }
}

// MARK: - HUDIndicator

/// A centered HUD-style indicator for high-priority feedback.
///
/// ```swift
/// HUDIndicator(message: "Volume", icon: "speaker.wave.3.fill", value: 0.8)
/// ```
public struct HUDIndicator: View {
    let message: String
    let icon: String
    let value: Double?
    
    public init(message: String, icon: String, value: Double? = nil) {
        self.message = message
        self.icon = icon
        self.value = value
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(.primary)
            
            Text(message)
                .font(.headline)
            
            if let value {
                GradientProgress(value: value)
                    .frame(width: 120)
            }
        }
        .padding(32)
        .background {
            GlassSurface(level: .ultraThick, cornerRadius: DesignTokens.Radius.xl)
        }
        .elevationShadow(.modal)
    }
}

// MARK: - ActivityRing

/// A circular progress ring with a liquid glass aesthetic.
///
/// ```swift
/// ActivityRing(progress: 0.6, color: .orange)
/// ```
public struct ActivityRing: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    
    public init(progress: Double, color: Color = .blue, lineWidth: CGFloat = 8) {
        self.progress = progress
        self.color = color
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(.ultraThinMaterial, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(
                    AngularGradient(
                        colors: [color, color.opacity(0.5)],
                        center: .center,
                        angle: .degrees(-90)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(DesignTokens.Motion.smooth, value: progress)
        }
    }
}

// MARK: - PulseLoader

/// A pulsating ripple effect for active states or background tasks.
///
/// ```swift
/// PulseLoader(color: .blue)
/// ```
public struct PulseLoader: View {
    let color: Color
    @State private var animate = false
    
    public init(color: Color = .blue) {
        self.color = color
    }
    
    public var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(color.opacity(0.5), lineWidth: 2)
                    .scaleEffect(animate ? 2.0 : 1.0)
                    .opacity(animate ? 0 : 0.5)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: false)
                        .delay(Double(i) * 0.5),
                        value: animate
                    )
            }
            
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
        }
        .onAppear { animate = true }
    }
}

// MARK: - InlineBanner

/// A banner for contextual feedback within a view.
///
/// ```swift
/// InlineBanner(title: "Warning", message: "Low disk space", type: .warning)
/// ```
public struct InlineBanner: View {
    public enum BannerType {
        case info, success, warning, error
        
        var color: Color {
            switch self {
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.octagon.fill"
            }
        }
    }
    
    let title: String
    let message: String
    let type: BannerType
    
    public init(title: String, message: String, type: BannerType = .info) {
        self.title = title
        self.message = message
        self.type = type
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: type.icon)
                .font(.title3)
                .foregroundStyle(type.color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background {
            GlassSurface(level: .ultraThin, cornerRadius: DesignTokens.Radius.m)
        }
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(type.color)
                .frame(width: 4)
                .clipShape(DynamicCornerRadius(topLeft: 12, bottomLeft: 12))
        }
    }
}
