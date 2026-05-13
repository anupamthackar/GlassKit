import SwiftUI
import GlassKit

@main
struct GlassKitCatalog: App {
    var body: some Scene {
        WindowGroup {
            CatalogView()
                .appTheme(DefaultTheme())
        }
    }
}

struct CatalogView: View {
    @State private var selectedTab: CatalogTab = .foundation
    
    var body: some View {
        ZStack {
            // Global Background
            LinearGradient(
                colors: [.indigo.opacity(0.8), .purple.opacity(0.8), .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("GlassKit")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                        Text("Component Catalog")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.title)
                        .symbolRenderingMode(.hierarchical)
                }
                .padding()
                
                // Content
                ScrollView {
                    VStack(spacing: DesignTokens.Spacing.xl) {
                        switch selectedTab {
                        case .foundation: FoundationView()
                        case .primitives: PrimitivesView()
                        case .buttons: ButtonsView()
                        case .inputs: InputsView()
                        case .navigation: NavigationView()
                        case .feedback: FeedbackView()
                        case .ai: AIView()
                        }
                    }
                    .padding()
                }
                
                // Tab Bar
                FloatingTabBar(
                    selection: $selectedTab,
                    label: { $0.rawValue.capitalized },
                    icon: { $0.icon }
                )
                .padding(.bottom, DesignTokens.Spacing.m)
            }
        }
    }
}

enum CatalogTab: String, CaseIterable, Identifiable {
    case foundation, primitives, buttons, inputs, navigation, feedback, ai
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .foundation: return "circle.grid.cross"
        case .primitives: return "cube.transparent"
        case .buttons: return "hand.tap.fill"
        case .inputs: return "text.cursor"
        case .navigation: return "safari"
        case .feedback: return "waveform"
        case .ai: return "sparkles"
        }
    }
}

// MARK: - Subviews

struct FoundationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader("Design Tokens")
            
            GlassCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Spacing System").font(.headline)
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        ForEach([2.0, 4.0, 8.0, 12.0, 16.0, 24.0, 32.0], id: \.self) { size in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.accentColor)
                                .frame(width: size, height: size)
                        }
                    }
                }
            }
            
            GlassCard {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Corner Radii").font(.headline)
                    HStack(spacing: 15) {
                        ForEach([DesignTokens.Radius.s, DesignTokens.Radius.m, DesignTokens.Radius.l, DesignTokens.Radius.xl], id: \.self) { radius in
                            RoundedRectangle(cornerRadius: radius)
                                .fill(.ultraThinMaterial)
                                .frame(width: 40, height: 40)
                                .overlay(Text("\(Int(radius))").font(.caption2))
                        }
                    }
                }
            }
        }
    }
}

struct PrimitivesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader("Primitives")
            
            VStack(spacing: 20) {
                LiquidContainer(elevation: .base) {
                    Text("Base Elevation")
                        .padding()
                }
                
                LiquidContainer(elevation: .elevated) {
                    Text("Elevated Surface")
                        .padding()
                }
                
                LiquidContainer(elevation: .floating) {
                    Text("Floating Glass")
                        .padding()
                }
            }
            
            Text("Animated Borders")
                .font(.headline)
                .padding(.top)
            
            HStack(spacing: 20) {
                Text("GPU Sync")
                    .padding()
                    .glassCard()
                    .animatedBorder(colors: [.blue, .purple])
                
                Text("Rainbow")
                    .padding()
                    .glassCard()
                    .animatedBorder(colors: [.red, .orange, .yellow, .green, .blue, .purple], speed: 1.0)
            }
        }
    }
}

struct ButtonsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader("Buttons & Interactions")
            
            VStack(spacing: 15) {
                GlassButton("Standard Glass") { print("Tapped") }
                
                GlassButton("Thick Material", level: .thick) { }
                
                GlassButton("Ultra Thin", level: .ultraThin) { }
                
                Button("Plain with Style") { }
                    .buttonStyle(.glass(level: .regular, cornerRadius: 30))
            }
        }
    }
}

struct InputsView: View {
    @State private var email = ""
    @State private var pass = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader("Input Controls")
            
            VStack(spacing: 25) {
                GlassTextField("Email Address", text: $email)
                GlassTextField("Password", text: $pass, isSecure: true)
            }
            .padding(.top, 20)
        }
    }
}

struct NavigationView: View {
    @State private var tab = CatalogTab.navigation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader("Navigation")
            
            Text("Floating Tab Bar (Standalone)")
                .font(.headline)
            
            FloatingTabBar(
                selection: $tab,
                label: { $0.rawValue.capitalized },
                icon: { $0.icon }
            )
        }
    }
}

struct FeedbackView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader("Feedback & Loading")
            
            VStack(spacing: 15) {
                SkeletonLoader(width: 300, height: 20)
                SkeletonLoader(width: 200, height: 20)
                SkeletonLoader(width: 300, height: 100)
            }
            
            Text("Shimmer Modifier")
                .font(.headline)
            
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 80, height: 80)
                .shimmer()
        }
    }
}

struct AIView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader("AI Components")
            
            AIStreamingText("Hello! I am the GlassKit Assistant. How can I help you build stunning liquid glass interfaces today?")
                .padding()
                .glassCard()
        }
    }
}

struct SectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.bottom, 5)
    }
}
