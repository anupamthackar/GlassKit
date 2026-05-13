import SwiftUI

// MARK: - GlassList

/// A container that renders list items with glass backgrounds.
///
/// ```swift
/// GlassList {
///     ForEach(items) { item in
///         Text(item.name)
///             .glassListItem()
///     }
/// }
/// ```
public struct GlassList<Content: View>: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.s) {
                content
            }
            .padding()
        }
    }
}

public extension View {
    func glassListItem() -> some View {
        self.padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                GlassSurface(level: .ultraThin, cornerRadius: DesignTokens.Radius.m)
            }
    }
}

// MARK: - AdaptiveGrid

/// A grid that automatically adjusts the number of columns based on available width.
///
/// ```swift
/// AdaptiveGrid(items: data, minWidth: 150) { item in
///     StatCard(title: item.title, value: item.value)
/// }
/// ```
public struct AdaptiveGrid<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let minWidth: CGFloat
    let spacing: CGFloat
    let content: (Item) -> Content
    
    public init(items: [Item], minWidth: CGFloat = 160, spacing: CGFloat = 16, @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.minWidth = minWidth
        self.spacing = spacing
        self.content = content
    }
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: minWidth), spacing: spacing)]
    }
    
    public var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(items) { item in
                content(item)
            }
        }
    }
}

// MARK: - StatCard

/// A card for displaying high-level statistics and metrics.
///
/// ```swift
/// StatCard(title: "Revenue", value: "$12,400", trend: "+12%", trendColor: .green)
/// ```
public struct StatCard: View {
    let title: String
    let value: String
    let trend: String?
    let trendColor: Color
    
    public init(title: String, value: String, trend: String? = nil, trendColor: Color = .green) {
        self.title = title
        self.value = value
        self.trend = trend
        self.trendColor = trendColor
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2.weight(.bold))
            
            if let trend {
                Text(trend)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(trendColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(trendColor.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            GlassSurface(level: .thin, cornerRadius: DesignTokens.Radius.l)
        }
    }
}

// MARK: - ExpandableCard

/// A card that can be expanded to show additional details.
///
/// ```swift
/// ExpandableCard(title: "Project Details", isExpanded: $expanded) {
///     Text("More info here...")
/// }
/// ```
public struct ExpandableCard<Content: View>: View {
    let title: String
    @Binding var isExpanded: Bool
    let content: Content
    
    public init(title: String, isExpanded: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.title = title
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(DesignTokens.Motion.smooth) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding()
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                content
                    .padding([.horizontal, .bottom])
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background {
            GlassSurface(level: .thin, cornerRadius: DesignTokens.Radius.l)
        }
    }
}

// MARK: - CarouselView

/// A horizontal paging carousel for media or cards.
///
/// ```swift
/// CarouselView(items: data) { item in
///     ParallaxImage(url: item.url)
/// }
/// ```
public struct CarouselView<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content
    
    public init(items: [Item], @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self.content = content
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(items) { item in
                    content(item)
                        .frame(width: 300)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - EmptyStateView

/// A standard view for empty states with icon, title, and action.
///
/// ```swift
/// EmptyStateView(icon: "folder.badge.plus", title: "No Files", message: "Start by adding a new file.") {
///     Button("Add File") { ... }
/// }
/// ```
public struct EmptyStateView<Action: View>: View {
    let icon: String
    let title: String
    let message: String
    let action: Action
    
    public init(icon: String, title: String, message: String, @ViewBuilder action: () -> Action) {
        self.icon = icon
        self.title = title
        self.message = message
        self.action = action()
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            
            action
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
