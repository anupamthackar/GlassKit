import SwiftUI
import AppleUIComponent

struct ContentView: View {
    var body: some View {
        ZStack {
            // Dynamic Background
            LinearGradient(
                colors: [.indigo, .purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: DesignTokens.Spacing.xxl) {
                // Header
                VStack(spacing: DesignTokens.Spacing.s) {
                    Text("NovaUI")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Liquid Glass Design System")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.top, DesignTokens.Spacing.massive)
                
                // Content Card
                GlassCard(level: .regular) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.l) {
                        Label("System Status", systemImage: "cpu")
                            .font(.headline)
                        
                        Text("All rendering systems are operational. GPU acceleration is active for glass surfaces.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Divider()
                            .background(Color.primary.opacity(0.1))
                        
                        HStack {
                            GlassButton("Rebuild Cache") {
                                print("Rebuilding...")
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "ellipsis.circle")
                                    .font(.title2)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(maxWidth: 400)
                .motionHoverEffect()
                
                Spacer()
            }
            .padding()
        }
        .appTheme(DefaultTheme())
    }
}

#Preview {
    ContentView()
}
