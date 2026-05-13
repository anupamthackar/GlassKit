import SwiftUI

// MARK: - AsyncImageView

/// A premium async image loader with glass skeleton and smooth transitions.
///
/// ```swift
/// AsyncImageView(url: URL(string: "..."))
/// ```
public struct AsyncImageView: View {
    let url: URL?
    let contentMode: ContentMode
    
    public init(url: URL?, contentMode: ContentMode = .fill) {
        self.url = url
        self.contentMode = contentMode
    }
    
    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                SkeletonLoader()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity.combined(with: .scale(scale: 1.05)))
            case .failure:
                ZStack {
                    Color.secondary.opacity(0.1)
                    Image(systemName: "photo")
                        .foregroundStyle(.tertiary)
                }
            @unknown default:
                EmptyView()
            }
        }
        .animation(DesignTokens.Motion.smooth, value: url)
    }
}

// MARK: - AudioVisualizer

/// A simple animated audio waveform visualizer.
///
/// ```swift
/// AudioVisualizer(isPlaying: true, color: .blue)
/// ```
public struct AudioVisualizer: View {
    let isPlaying: Bool
    let color: Color
    @State private var phase: CGFloat = 0
    
    public init(isPlaying: Bool, color: Color = .blue) {
        self.isPlaying = isPlaying
        self.color = color
    }
    
    public var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<8) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 4, height: isPlaying ? CGFloat.random(in: 10...30) : 4)
                    .animation(
                        isPlaying ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(Double(i) * 0.1) : .default,
                        value: isPlaying
                    )
            }
        }
    }
}

// MARK: - MediaControls

/// A glass-morphic control set for media playback.
///
/// ```swift
/// MediaControls(isPlaying: $playing, onNext: { ... }, onPrevious: { ... })
/// ```
public struct MediaControls: View {
    @Binding var isPlaying: Bool
    let onNext: () -> Void
    let onPrevious: () -> Void
    
    public init(isPlaying: Binding<Bool>, onNext: @escaping () -> Void, onPrevious: @escaping () -> Void) {
        self._isPlaying = isPlaying
        self.onNext = onNext
        self.onPrevious = onPrevious
    }
    
    public var body: some View {
        HStack(spacing: 24) {
            Button(action: onPrevious) {
                Image(systemName: "backward.fill")
            }
            
            Button {
                withAnimation(DesignTokens.Motion.snappy) {
                    isPlaying.toggle()
                }
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.title)
                    .frame(width: 64, height: 64)
                    .background {
                        GlassSurface(level: .regular, cornerRadius: 32)
                    }
            }
            
            Button(action: onNext) {
                Image(systemName: "forward.fill")
            }
        }
        .font(.title3)
        .foregroundStyle(.primary)
        .buttonStyle(.plain)
    }
}

// MARK: - ParallaxImage

/// An image that applies a parallax effect based on scrolling or movement.
///
/// ```swift
/// ParallaxImage(url: url)
///     .frame(height: 300)
/// ```
public struct ParallaxImage: View {
    let url: URL?
    
    public init(url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            AsyncImageView(url: url)
                .offset(y: minY > 0 ? -minY / 2 : 0)
                .scaleEffect(minY > 0 ? 1 + minY / 1000 : 1)
                .frame(width: geo.size.width, height: geo.size.height + (minY > 0 ? minY : 0))
        }
        .clipped()
    }
}
