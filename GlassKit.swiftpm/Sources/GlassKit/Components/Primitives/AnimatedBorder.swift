import SwiftUI

/// A GPU-optimized animated border that uses TimelineView for smooth motion.
public struct AnimatedBorder: View {
    let cornerRadius: CGFloat
    let colors: [Color]
    let lineWidth: CGFloat
    let speed: Double
    
    public init(
        cornerRadius: CGFloat = DesignTokens.Radius.m,
        colors: [Color] = [.blue, .purple, .blue],
        lineWidth: CGFloat = 2,
        speed: Double = 2.0
    ) {
        self.cornerRadius = cornerRadius
        self.colors = colors
        self.lineWidth = lineWidth
        self.speed = speed
    }
    
    public var body: some View {
        TimelineView(.animation) { timeline in
            let date = timeline.date.timeIntervalSinceReferenceDate
            let angle = Angle(radians: date * speed)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    AngularGradient(
                        colors: colors + colors,
                        center: .center,
                        angle: angle
                    ),
                    lineWidth: lineWidth
                )
        }
        .drawingGroup() // Optimize for GPU rendering
    }
}

public extension View {
    func animatedBorder(
        cornerRadius: CGFloat = DesignTokens.Radius.m,
        colors: [Color] = [.blue, .purple, .blue],
        lineWidth: CGFloat = 2,
        speed: Double = 2.0
    ) -> some View {
        self.overlay(
            AnimatedBorder(cornerRadius: cornerRadius, colors: colors, lineWidth: lineWidth, speed: speed)
        )
    }
}

#Preview {
    Text("Liquid Border")
        .padding()
        .glassCard()
        .animatedBorder()
}
