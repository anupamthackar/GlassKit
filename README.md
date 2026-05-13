# GlassKit (NovaUI)

### Liquid Glass Design System for Apple Platforms

GlassKit is a production-grade SwiftUI component framework inspired by the "Liquid Glass" aesthetic. It provides a modular, token-driven architecture for building premium, high-performance applications on iOS, macOS, visionOS, and more.

## ✨ Features

- **Liquid Glass Rendering**: High-performance glass-morphic surfaces with dynamic lighting and specular reflections.
- **Token-Driven**: Full control over colors, typography, spacing, and motion via a centralized token system.
- **Modular & Extensible**: Built using SOLID principles and protocol-oriented architecture.
- **Accessibility-First**: Built-in support for Dynamic Type, VoiceOver, and high contrast.
- **GPU Optimized**: Uses `drawingGroup`, `TimelineView`, and custom shaders for 120 FPS performance.
- **AI-Native**: Integrated with a specialized AI agent system for automated development and auditing.

## 🚀 Installation

GlassKit supports Swift Package Manager. Add it to your project:

```swift
.package(url: "...", from: "1.0.0")
```

## 🛠 Usage

### Applying a Theme

```swift
import GlassKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .appTheme(DefaultTheme())
        }
    }
}
```

### Using Components

```swift
import GlassKit

struct ContentView: View {
    var body: some View {
        LiquidContainer(elevation: .floating) {
            VStack {
                Text("Hello GlassKit")
                    .font(DesignTokens.Typography.titleLarge)
                
                GlassButton("Press Me") {
                    print("Button Tapped")
                }
            }
        }
    }
}
```

## 🏗 Architecture

GlassKit follows a strictly modular structure:
- **CoreTheme**: Design tokens and theme engine.
- **CoreAnimation**: Motion engine and transition logic.
- **GlassMaterials**: Liquid Glass primitive rendering logic.
- **Components**: High-level UI components (Buttons, Inputs, Cards, etc.).

## 🤖 AI Agent System

This project includes a built-in AI agent ecosystem in the `.agent/` directory. See [AGENTS.md](AGENTS.md) for details on how to use these agents to maintain and extend the framework.

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
