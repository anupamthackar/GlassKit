# GlassKit (NovaUI)

### Liquid Glass Design System for Apple Platforms

**GlassKit** is a production-grade SwiftUI component framework inspired by the "Liquid Glass" aesthetic. It provides a modular, token-driven architecture for building premium, high-performance applications across the Apple ecosystem. 

Whether you are a **beginner** looking to easily drop in beautiful, animated UI components, or a **pro developer** aiming to build scalable, themeable, and highly performant applications using SOLID principles, GlassKit provides the tools you need.

---

## 📦 What is this Swift Package?

GlassKit is distributed as a Swift Package Manager (SPM) library. It exposes:
- A sophisticated **Theme Engine** based on Design Tokens.
- **GlassMaterials** for high-performance, GPU-accelerated glass-morphic surfaces.
- A comprehensive suite of **UI Components** ranging from basic buttons to advanced AI and Vision components.

### 🎮 The `GlassKit.swiftpm` Demo App

To see GlassKit in action, this repository includes a standalone `GlassKit.swiftpm` project.

> **⚠️ IMPORTANT:** The `GlassKit.swiftpm` demo application acts as an interactive catalog for all available components and their usage. **It is configured to run specifically on macOS.** When opening `GlassKit.swiftpm` in Xcode or Swift Playgrounds, make sure to select **"My Mac"** as your run destination to build and run the interactive demo.

This demo app is the best place to learn how to use the framework, see live previews of the components, and experiment with light/dark modes and theme switching.

---

## ✨ Features

- **Liquid Glass Rendering**: High-performance glass-morphic surfaces with dynamic lighting, blur, and specular reflections.
- **Token-Driven Architecture**: Full control over colors, typography, spacing, and motion via a centralized environment-injected token system.
- **Modular & Extensible**: Protocol-oriented architecture ensuring components are isolated and easily customizable.
- **Accessibility-First**: Built-in support for Dynamic Type, VoiceOver, and high contrast modes.
- **GPU Optimized**: Uses `drawingGroup`, `TimelineView`, and custom shaders to maintain a smooth 120 FPS.
- **AI-Native Ecosystem**: Includes a built-in AI agent system (`.agent/`) for automated development, auditing, and maintenance.

---

## 🧩 Component Library

Here is the complete manifest of components available in GlassKit. This extensive library is designed to help you build any interface requirement with the Liquid Glass aesthetic:

### 🏗 Foundation
- `ThemeEngine`, `ThemeProvider`, `EnvironmentThemeKey`
- `ColorToken`, `TypographyToken`, `MotionToken`, `GlassMaterialToken`
- `AccessibilityEngine`, `AdaptiveLayoutEngine`

### 🧱 Primitives
- `GlassSurface`, `LiquidContainer`, `GlassCard`
- `AnimatedBorder`, `AdaptiveBlurView`, `DynamicCornerRadius`
- `MorphingShape`, `ElevationShadow`

### 👆 Buttons & Interactions
- `GlassButton`, `FloatingActionButton`, `AsyncLoadingButton`, `IconButton`
- `SegmentedPill`, `CheckboxToggleStyle`, `RadioButton`, `SwitchToggle`
- `FatSlider`, `StepSlider`, `ReactionButton`

### ⌨️ Inputs
- `CocoaTextField`, `SearchBar`, `FloatingLabelInput`, `OTPInputField`
- `ValidationTextField`, `SecureInputField`, `RichTextEditor`, `TokenInputField`
- `CurrencyInput`, `AutoGrowingTextEditor`

### 🧭 Navigation
- `FloatingTabBar`, `AdaptiveSidebar`, `LiquidNavigationBar`
- `MorphingBottomSheet`, `DetentSheetContainer`, `HeroTransitionContainer`
- `NavigationRail`, `FloatingCommandPalette`, `BreadcrumbNavigator`

### 💬 Feedback
- `GradientProgress`, `SkeletonLoader`, `OverlayToast`, `HUDIndicator`
- `Snackbar`, `InlineBanner`, `ActivityRing`, `PulseLoader`
- `ConfettiEmitter`, `ShimmerView`

### 📊 Data Display
- `GlassList`, `AdaptiveGrid`, `TimelineView`, `ExpandableCard`, `Accordion`
- `StatCard`, `CarouselView`, `ChartContainer`, `InfiniteScrollView`, `EmptyStateView`

### 🎥 Media
- `AsyncImageView`, `VideoPlayerContainer`, `AudioVisualizer`
- `MediaControls`, `ZoomableImageView`, `ParallaxImage`, `LivePhotoView`

### 🤖 AI Components
- `PromptInputBar`, `AIStreamingText`, `TypingIndicator`
- `ConversationBubble`, `MarkdownRenderer`, `CodeBlockView`
- `VoiceWaveformView`, `SpotlightSearch`

### 👓 VisionOS Components
- `SpatialGlassPanel`, `DepthAwareContainer`, `VolumetricCard`
- `OrbitalMenu`, `SpatialToolbar`

---

## 🚀 Installation

GlassKit supports Swift Package Manager. Add it to your project by adding this repository URL in Xcode:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/anupamthackar/GlassKit.git", from: "1.0.0")
]
```

## 🛠 Usage

### 1. Applying a Theme
Wrap your root application view with the `.appTheme()` modifier to inject the design tokens into the SwiftUI environment.

```swift
import GlassKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Inject the default Liquid Glass theme
                .appTheme(DefaultTheme()) 
        }
    }
}
```

### 2. Using Components
You can now use any GlassKit component anywhere in your app. They will automatically adapt to the injected theme and system color scheme.

```swift
import GlassKit

struct ContentView: View {
    @State private var username = ""

    var body: some View {
        ZStack {
            // A background to show off the glass effect
            Color.blue.ignoresSafeArea()
            
            LiquidContainer(elevation: .floating) {
                VStack(spacing: 24) {
                    Text("Welcome")
                        .font(DesignTokens.Typography.titleLarge)
                    
                    GlassTextField(
                        "Enter Username", 
                        text: $username, 
                        icon: "person.fill"
                    )
                    
                    GlassButton("Continue") {
                        print("Button Tapped")
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}
```

---

## 🏗 Architecture Principles

GlassKit follows a strictly modular structure defined in `AGENTS.md`:
1. **CoreTheme**: Design tokens and the theme engine (colors, typography, spacing).
2. **CoreAnimation**: Motion engine and standardized transition logic.
3. **GlassMaterials**: Liquid Glass primitive rendering logic.
4. **Components**: High-level, modular UI components utilizing the core layers.

## 🤖 AI Agent System

This project is built to be managed and extended by specialized AI agents working in harmony with human architects. Check out the `.agent/` directory and [AGENTS.md](AGENTS.md) to understand how to leverage the UI Architect, Design System, Accessibility, and Performance agents.

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
