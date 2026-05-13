import SwiftUI

// MARK: - LiquidNavigationBar

/// A frosted glass navigation bar with dynamic title transitions.
///
/// ```swift
/// LiquidNavigationBar(title: "Dashboard", leadingIcon: "sidebar.left") {
///     IconButton("gearshape") { }
/// }
/// ```
public struct LiquidNavigationBar<Trailing: View>: View {
    let title: String
    let leadingIcon: String?
    let trailing: Trailing
    
    public init(title: String, leadingIcon: String? = nil, @ViewBuilder trailing: () -> Trailing) {
        self.title = title; self.leadingIcon = leadingIcon; self.trailing = trailing()
    }
    
    public var body: some View {
        HStack {
            if let leadingIcon {
                Image(systemName: leadingIcon).font(.title3).foregroundStyle(.secondary)
            }
            Text(title).font(DesignTokens.Typography.headline)
            Spacer()
            trailing
        }
        .padding(.horizontal).padding(.vertical, 12)
        .background { GlassSurface(level: .thick, cornerRadius: 0) }
    }
}

// MARK: - MorphingBottomSheet

/// A draggable bottom sheet with glass-morphic background and detent positions.
///
/// ```swift
/// MorphingBottomSheet(isPresented: $showSheet) {
///     Text("Sheet Content")
/// }
/// ```
public struct MorphingBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    @State private var offset: CGFloat = 0
    
    public init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented; self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geo in
            if isPresented {
                Color.black.opacity(0.3).ignoresSafeArea()
                    .onTapGesture { withAnimation(.spring) { isPresented = false } }
                
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 0) {
                        Capsule().fill(.secondary.opacity(0.5)).frame(width: 40, height: 5).padding(8)
                        content.padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background { GlassSurface(level: .thick, cornerRadius: DesignTokens.Radius.xl) }
                    .offset(y: offset)
                    .gesture(
                        DragGesture().onChanged { v in offset = max(0, v.translation.height) }
                            .onEnded { v in
                                if v.translation.height > 100 {
                                    withAnimation(.spring) { isPresented = false }
                                }
                                withAnimation(.spring) { offset = 0 }
                            }
                    )
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.spring, value: isPresented)
    }
}

// MARK: - NavigationRail

/// A vertical side navigation rail for iPad/Mac layouts.
///
/// ```swift
/// NavigationRail(selection: $tab, items: [
///     .init(icon: "house", label: "Home"),
///     .init(icon: "gear", label: "Settings"),
/// ])
/// ```
public struct NavigationRail: View {
    public struct Item: Identifiable {
        public let id = UUID()
        public let icon: String
        public let label: String
        public init(icon: String, label: String) { self.icon = icon; self.label = label }
    }
    
    @Binding var selection: Int
    let items: [Item]
    
    public init(selection: Binding<Int>, items: [Item]) {
        self._selection = selection; self.items = items
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.element.id) { i, item in
                Button {
                    withAnimation(DesignTokens.Motion.snappy) { selection = i }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: item.icon)
                            .font(.system(size: 20))
                            .frame(width: 44, height: 36)
                            .background {
                                if selection == i {
                                    GlassSurface(level: .thin, cornerRadius: DesignTokens.Radius.m)
                                }
                            }
                        Text(item.label).font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(selection == i ? .primary : .secondary)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(8)
        .background { GlassSurface(level: .regular, cornerRadius: DesignTokens.Radius.l) }
    }
}

// MARK: - BreadcrumbNavigator

/// A horizontal breadcrumb trail for hierarchical navigation.
///
/// ```swift
/// BreadcrumbNavigator(path: ["Home", "Settings", "Privacy"]) { tapped in
///     navigateTo(tapped)
/// }
/// ```
public struct BreadcrumbNavigator: View {
    let path: [String]
    let onSelect: (Int) -> Void
    
    public init(path: [String], onSelect: @escaping (Int) -> Void) {
        self.path = path; self.onSelect = onSelect
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(Array(path.enumerated()), id: \.offset) { i, item in
                    if i > 0 {
                        Image(systemName: "chevron.right").font(.caption2).foregroundStyle(.tertiary)
                    }
                    Button(item) { onSelect(i) }
                        .font(i == path.count - 1 ? .caption.bold() : .caption)
                        .foregroundStyle(i == path.count - 1 ? .primary : .secondary)
                        .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background { GlassSurface(level: .ultraThin, cornerRadius: DesignTokens.Radius.m) }
        }
    }
}

// MARK: - FloatingCommandPalette

/// A spotlight-style command palette with glass search bar.
///
/// ```swift
/// FloatingCommandPalette(isPresented: $showPalette, commands: commands) { cmd in
///     executeCommand(cmd)
/// }
/// ```
public struct FloatingCommandPalette: View {
    public struct Command: Identifiable {
        public let id = UUID()
        public let icon: String
        public let title: String
        public let subtitle: String
        public init(icon: String, title: String, subtitle: String = "") {
            self.icon = icon; self.title = title; self.subtitle = subtitle
        }
    }
    
    @Binding var isPresented: Bool
    let commands: [Command]
    let onSelect: (Command) -> Void
    @State private var query = ""
    
    public init(isPresented: Binding<Bool>, commands: [Command], onSelect: @escaping (Command) -> Void) {
        self._isPresented = isPresented; self.commands = commands; self.onSelect = onSelect
    }
    
    var filtered: [Command] {
        query.isEmpty ? commands : commands.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
    
    public var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                    .onTapGesture { withAnimation { isPresented = false } }
                
                VStack(spacing: 0) {
                    SearchBar(text: $query, placeholder: "Type a command…")
                    ScrollView {
                        LazyVStack(spacing: 2) {
                            ForEach(filtered) { cmd in
                                Button {
                                    onSelect(cmd)
                                    withAnimation { isPresented = false }
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: cmd.icon).frame(width: 24)
                                        VStack(alignment: .leading) {
                                            Text(cmd.title).font(.subheadline)
                                            if !cmd.subtitle.isEmpty {
                                                Text(cmd.subtitle).font(.caption).foregroundStyle(.secondary)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 12).padding(.vertical, 10)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }
                .padding()
                .background { GlassSurface(level: .thick, cornerRadius: DesignTokens.Radius.xl) }
                .frame(maxWidth: 500)
                .padding(.horizontal, 24)
                .elevationShadow(.modal)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
            .animation(.spring(response: 0.3), value: isPresented)
        }
    }
}
