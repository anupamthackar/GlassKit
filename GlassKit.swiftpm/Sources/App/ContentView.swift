import SwiftUI
import GlassKitCore

// MARK: - Extensions

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Theme Configuration Model

@Observable
final class ThemeConfigurator {
    var primaryColor: Color = .blue
    var secondaryColor: Color = .purple
    var tertiaryColor: Color = .cyan
    var isGlassEnabled: Bool = true
    
    var glassLevel: GlassMaterialLevel = .regular
    var cornerRadius: CGFloat = 16
    var isDarkMode: Bool = true
    var borderSpeed: Double = 2.0
    var borderEnabled: Bool = true
    var elevationLevel: DesignTokens.Elevation = .elevated
    
    var backgroundGradient: [Color] {
        isDarkMode
        ? [primaryColor.opacity(0.6), secondaryColor.opacity(0.4), .black]
        : [primaryColor.opacity(0.3), secondaryColor.opacity(0.2), .white]
    }
}

// MARK: - Root View

struct ContentView: View {
    @State private var config = ThemeConfigurator()
    @State private var selectedSection: DemoSection = .components
    @State private var searchText = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: config.backgroundGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.smooth, value: config.primaryColor)
            .animation(.smooth, value: config.secondaryColor)
            .animation(.smooth, value: config.tertiaryColor)
            .animation(.smooth, value: config.isDarkMode)

            VStack(spacing: 0) {
                // Header
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("GlassKit")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        Text("NovaUI Framework Catalog")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "cube.transparent.fill")
                        .font(.title)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(config.primaryColor)
                }
                .padding()

                if selectedSection == .components {
                    SearchBar(text: $searchText, placeholder: "Search 70+ components…")
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }

                // Content
                Group {
                    switch selectedSection {
                    case .configure:
                        ScrollView { ConfigureView(config: config).padding().padding(.bottom, 100) }
                    case .components:
                        ComponentsGalleryView(config: config, searchText: searchText)
                    case .code:
                        ScrollView { CodeGenView(config: config).padding().padding(.bottom, 100) }
                    }
                }

                Spacer(minLength: 0)
            }

            // Floating Tab Bar
            VStack {
                Spacer()
                FloatingTabBar(
                    selection: $selectedSection,
                    label: { $0.title },
                    icon: { $0.icon }
                )
                .padding(.bottom, DesignTokens.Spacing.m)
            }
        }
        .preferredColorScheme(config.isDarkMode ? .dark : .light)
        .environment(\.isGlassEnabled, config.isGlassEnabled)
    }
}

// MARK: - Navigation

enum DemoSection: String, CaseIterable, Identifiable {
    case configure, components, code
    var id: String { rawValue }

    var title: String { rawValue.capitalized }

    var icon: String {
        switch self {
        case .configure: return "slider.horizontal.3"
        case .components: return "square.stack.3d.up.fill"
        case .code: return "chevron.left.forwardslash.chevron.right"
        }
    }
}

// MARK: - 1. Configure (Theme Editor)
struct ConfigureView: View {
    @Bindable var config: ThemeConfigurator
    let presetColors: [(String, Color)] = [("Blue", .blue), ("Indigo", .indigo), ("Purple", .purple), ("Pink", .pink), ("Red", .red), ("Orange", .orange), ("Mint", .mint), ("Teal", .teal), ("Cyan", .cyan), ("Green", .green)]

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            SectionLabel("Theme Configuration", subtitle: "Global design tokens that affect all components.")
            GlassCard(cornerRadius: config.cornerRadius) {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Appearance", systemImage: "moon.circle.fill").font(.headline)
                    Toggle("Dark Mode", isOn: $config.isDarkMode).tint(config.primaryColor)
                    Toggle("Glass Effect", isOn: $config.isGlassEnabled).tint(config.primaryColor)
                }
            }
            GlassCard(cornerRadius: config.cornerRadius) {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Primary Color", systemImage: "paintpalette.fill").font(.headline)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 12) {
                        ForEach(presetColors, id: \.0) { name, color in
                            Circle().fill(color).frame(width: 44, height: 44).overlay { if config.primaryColor == color { Circle().stroke(.white, lineWidth: 3) } }
                                .onTapGesture { withAnimation(.snappy) { config.primaryColor = color } }
                        }
                    }
                }
            }
            GlassCard(cornerRadius: config.cornerRadius) {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Secondary Color", systemImage: "paintpalette.fill").font(.headline)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 12) {
                        ForEach(presetColors, id: \.0) { name, color in
                            Circle().fill(color).frame(width: 44, height: 44).overlay { if config.secondaryColor == color { Circle().stroke(.white, lineWidth: 3) } }
                                .onTapGesture { withAnimation(.snappy) { config.secondaryColor = color } }
                        }
                    }
                }
            }
            GlassCard(cornerRadius: config.cornerRadius) {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Tertiary Color", systemImage: "paintpalette.fill").font(.headline)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 5), spacing: 12) {
                        ForEach(presetColors, id: \.0) { name, color in
                            Circle().fill(color).frame(width: 44, height: 44).overlay { if config.tertiaryColor == color { Circle().stroke(.white, lineWidth: 3) } }
                                .onTapGesture { withAnimation(.snappy) { config.tertiaryColor = color } }
                        }
                    }
                }
            }
            GlassCard(cornerRadius: config.cornerRadius) {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Glass Material", systemImage: "cube.transparent").font(.headline)
                    Picker("Level", selection: $config.glassLevel) {
                        Text("Ultra Thin").tag(GlassMaterialLevel.ultraThin)
                        Text("Thin").tag(GlassMaterialLevel.thin)
                        Text("Regular").tag(GlassMaterialLevel.regular)
                        Text("Thick").tag(GlassMaterialLevel.thick)
                        Text("Ultra Thick").tag(GlassMaterialLevel.ultraThick)
                    }.pickerStyle(.segmented)
                }
            }
            GlassCard(cornerRadius: config.cornerRadius) {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Corner Radius: \(Int(config.cornerRadius))pt", systemImage: "square.on.square").font(.headline)
                    Slider(value: $config.cornerRadius, in: 0...32, step: 4).tint(config.primaryColor)
                }
            }
        }
    }
}

// MARK: - 3. Components Gallery

struct ComponentsGalleryView: View {
    @Bindable var config: ThemeConfigurator
    let searchText: String
    
    @State private var toggleVal = true
    @State private var sliderVal: CGFloat = 0.5
    @State private var rating = 3
    @State private var selectedTab = 0
    @State private var otpCode = "1234"
    @State private var tokens = ["SwiftUI", "Glass", "Nova"]
    @State private var amount = 42.0
    @State private var isExpanded = false
    @State private var showToast = false
    @State private var showSheet = false
    @State private var showCommand = false
    @State private var isOrbitalOpen = false
    
    @State private var selectedComponent: String? = "GlassSurface"
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedComponent) {
                Section("Primitives") {
                    Text("GlassSurface").tag("GlassSurface")
                    Text("MorphingShape").tag("MorphingShape")
                    Text("DynamicRadius").tag("DynamicRadius")
                    Text("AnimatedBorder").tag("AnimatedBorder")
                }
                Section("Buttons & Interaction") {
                    Text("FloatingActionButton").tag("FloatingActionButton")
                    Text("IconButton").tag("IconButton")
                    Text("ReactionButton").tag("ReactionButton")
                    Text("SegmentedPill").tag("SegmentedPill")
                    Text("FatSlider").tag("FatSlider")
                    Text("StepSlider").tag("StepSlider")
                    Text("GlassCheckbox").tag("GlassCheckbox")
                    Text("GlassToggle").tag("GlassToggle")
                }
                Section("Inputs") {
                    Text("OTPInputField").tag("OTPInputField")
                    Text("TokenInputField").tag("TokenInputField")
                    Text("CurrencyInput").tag("CurrencyInput")
                    Text("ValidationTextField").tag("ValidationTextField")
                    Text("FloatingLabelInput").tag("FloatingLabelInput")
                    Text("SecureInputField").tag("SecureInputField")
                    Text("RichTextEditor").tag("RichTextEditor")
                    Text("CocoaTextField").tag("CocoaTextField")
                }
                Section("Feedback") {
                    Text("InlineBanner").tag("InlineBanner")
                    Text("ActivityRing").tag("ActivityRing")
                    Text("PulseLoader").tag("PulseLoader")
                    Text("OverlayToast").tag("OverlayToast")
                    Text("Snackbar").tag("Snackbar")
                }
                Section("Data Display") {
                    Text("StatCard").tag("StatCard")
                    Text("ExpandableCard").tag("ExpandableCard")
                    Text("BarChartContainer").tag("BarChartContainer")
                    Text("EventsTimelineView").tag("EventsTimelineView")
                    Text("Accordion").tag("Accordion")
                    Text("InfiniteScrollView").tag("InfiniteScrollView")
                }
                Section("Media") {
                    Text("VideoPlayerContainer").tag("VideoPlayerContainer")
                    Text("ZoomableImageView").tag("ZoomableImageView")
                    Text("LivePhotoView").tag("LivePhotoView")
                }
                Section("AI & Vision") {
                    Text("ConversationBubble").tag("ConversationBubble")
                    Text("OrbitalMenu").tag("OrbitalMenu")
                    Text("VolumetricCard").tag("VolumetricCard")
                    Text("SpotlightSearch").tag("SpotlightSearch")
                    Text("MarkdownRenderer").tag("MarkdownRenderer")
                    Text("DepthAwareContainer").tag("DepthAwareContainer")
                    Text("SpatialToolbar").tag("SpatialToolbar")
                }
                Section("Navigation & Overlays") {
                    Text("CommandPalette").tag("CommandPalette")
                    Text("MorphingSheet").tag("MorphingSheet")
                    Text("DetentSheetContainer").tag("DetentSheetContainer")
                }
            }
            .navigationTitle("Components")
        } detail: {
            if let selected = selectedComponent {
                componentDetail(for: selected)
            } else {
                Text("Select a component")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.bottom, 80)
    }
    
    @ViewBuilder
    func componentDetail(for name: String) -> some View {
        let meta = getComponentMetadata(for: name)
        
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Quick Help Overview Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(name)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text("Overview")
                        .font(.headline)
                        .foregroundStyle(config.primaryColor)
                        .padding(.top, 8)
                    
                    Text(meta.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)
                }
                
                // Live Preview Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Live Preview")
                        .font(.headline)
                        .foregroundStyle(config.primaryColor)
                    
                    VStack {
                        componentPreview(for: name)
                            .padding(40)
                    }
                    .frame(maxWidth: .infinity)
                    .background(config.isDarkMode ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .strokeBorder(.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                
                // Usage Example Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Usage")
                        .font(.headline)
                        .foregroundStyle(config.primaryColor)
                    
                    CodeBlockView(code: meta.usage, language: "swift")
                }
            }
            .padding(32)
        }
    }
    
    @ViewBuilder
    func componentPreview(for name: String) -> some View {
        switch name {
        case "GlassSurface":
            GlassSurface(level: .thin).frame(width: 200, height: 100)
        case "MorphingShape":
            MorphingShape(morphProgress: 0.5).fill(config.primaryColor).frame(width: 100, height: 100)
        case "DynamicRadius":
            DynamicCornerRadius(topLeft: 20, bottomRight: 20).fill(.purple.opacity(0.3)).frame(width: 150, height: 100)
        case "AnimatedBorder":
            Text("Moving Gradient").padding().glassCard().animatedBorder(colors: [config.primaryColor, .purple])
            
        case "FloatingActionButton":
            FloatingActionButton(icon: "plus") { }
        case "IconButton":
            IconButton("heart.fill", tint: .red) { }
        case "ReactionButton":
            ReactionButton(emoji: "🚀", count: .constant(99), isActive: .constant(true))
        case "SegmentedPill":
            SegmentedPill(selection: $selectedTab, options: ["Light", "Dark", "Auto"])
        case "FatSlider":
            FatSlider(value: $sliderVal, tint: config.primaryColor).padding()
        case "StepSlider":
            StepSlider(value: $rating, steps: 5, labels: ["1", "2", "3", "4", "5"]).padding()
        case "GlassCheckbox":
            Toggle("Checkbox Style", isOn: $toggleVal).toggleStyle(GlassCheckboxStyle()).padding()
        case "GlassToggle":
            GlassToggle("Switch Style", isOn: $toggleVal).padding()
            
        case "OTPInputField":
            OTPInputField(code: $otpCode, length: 4)
        case "TokenInputField":
            TokenInputField(tokens: $tokens).padding()
        case "CurrencyInput":
            CurrencyInput(value: $amount).padding()
        case "ValidationTextField":
            ValidationTextField("Email", text: .constant("test@glass.kit"), validation: .email, errorMessage: "Valid email required").padding()
        case "FloatingLabelInput":
            FloatingLabelInput("Username", text: .constant("")).padding()
        case "SecureInputField":
            SecureInputField("Password", text: .constant("")).padding()
        case "RichTextEditor":
            RichTextEditor(text: .constant("Some rich text...")).frame(height: 200).padding()
        case "CocoaTextField":
            CocoaTextField("Cocoa Input", text: .constant("")).padding()
            
        case "InlineBanner":
            InlineBanner(title: "Ready to go!", message: "Your environment is fully configured.", type: .success).padding()
        case "ActivityRing":
            ActivityRing(progress: 0.85, color: .green).frame(width: 100, height: 100)
        case "PulseLoader":
            PulseLoader(color: .blue)
        case "OverlayToast":
            Button("Show Toast") { showToast = true }.buttonStyle(.glass(level: .thin))
                .overlay { OverlayToast(message: "Component Created", isPresented: $showToast) }
        case "Snackbar":
            Snackbar(message: "Operation completed successfully.").padding()
            
        case "StatCard":
            StatCard(title: "Active Users", value: "1,284", trend: "+5%").padding()
        case "ExpandableCard":
            ExpandableCard(title: "More Details", isExpanded: $isExpanded) {
                Text("This content is revealed with a smooth animation and glass transition.")
            }.padding()
        case "BarChartContainer":
            BarChartContainer(data: [0.4, 0.7, 0.5, 0.9, 0.3]).padding()
        case "EventsTimelineView":
            EventsTimelineView {
                Text("Event 1")
                Text("Event 2")
            }.padding()
        case "Accordion":
            Accordion(title: "Settings") { Text("Various settings options...") }.padding()
        case "InfiniteScrollView":
            InfiniteScrollView { Text("Infinite content...") }.padding()
            
        case "VideoPlayerContainer":
            VideoPlayerContainer(url: nil).frame(height: 200).padding()
        case "ZoomableImageView":
            ZoomableImageView(imageName: "photo").frame(height: 200).padding()
        case "LivePhotoView":
            LivePhotoView().padding()
            
        case "ConversationBubble":
            VStack(spacing: 20) {
                ConversationBubble(message: "How does the OrbitalMenu work?", isUser: true)
                ConversationBubble(message: "It expands items in a circular pattern around a focal point.", isUser: false)
            }.padding()
        case "OrbitalMenu":
            OrbitalMenu(isExpanded: $isOrbitalOpen, items: [
                .init(icon: "camera") { },
                .init(icon: "photo") { },
                .init(icon: "video") { }
            ]).frame(height: 300)
        case "VolumetricCard":
            VolumetricCard {
                Text("3D Interactive Card (Drag Me)")
                    .font(.headline)
                    .frame(width: 250, height: 150)
            }
        case "SpotlightSearch":
            SpotlightSearch(isPresented: .constant(true)).padding()
        case "MarkdownRenderer":
            MarkdownRenderer(markdown: "**Bold** and *Italic* text").padding()
        case "DepthAwareContainer":
            DepthAwareContainer { Text("Depth Aware") }.padding()
        case "SpatialToolbar":
            SpatialToolbar().padding()
            
        case "CommandPalette":
            Button("Open Command Palette (⌘K)") { showCommand = true }.buttonStyle(.glass)
                .overlay {
                    FloatingCommandPalette(isPresented: $showCommand, commands: [
                        .init(icon: "doc", title: "New Document", subtitle: "Create a glass document"),
                        .init(icon: "magnifyingglass", title: "Find in Files")
                    ]) { _ in }
                }
        case "MorphingSheet":
            MorphingBottomSheet(isPresented: $showSheet) {
                Text("Morphing Sheet Content").padding()
            }
        case "DetentSheetContainer":
            DetentSheetContainer(isPresented: $showSheet) {
                Text("Detent Sheet Content").padding()
            }
            
        default:
            Text("Component Preview Not Found")
        }
    }
}

// MARK: - Helper Views

struct CategorySection<Content: View>: View {
    let title: String
    let content: Content
    init(_ title: String, @ViewBuilder content: () -> Content) { self.title = title; self.content = content() }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title).font(.title2.bold()).foregroundStyle(.primary)
            content
        }
    }
}

struct CompItem: Identifiable {
    let id = UUID()
    let name: String
    let content: AnyView
    init(_ name: String, content: AnyView) { self.name = name; self.content = content }
}

// MARK: - CodeGenView [Remains similar]
struct CodeGenView: View {
    @Bindable var config: ThemeConfigurator
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionLabel("Implementation Guide", subtitle: "Start building with the NovaUI primitives.")
            CodeBlockView(code: """
            import GlassKit
            
            // 1. Define your theme
            let myTheme = DefaultTheme()
            
            // 2. Apply it to your view
            ContentView()
                .appTheme(myTheme)
                
            // 3. Use glass components
            GlassButton("Hello") { }
            """, language: "swift")
        }
    }
}

// MARK: - Component Helpers

struct SectionLabel: View {
    let title: String
    let subtitle: String?
    
    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct ComponentCard<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(_ title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            GlassSurface(level: .ultraThin, cornerRadius: DesignTokens.Radius.l)
        }
    }
}
