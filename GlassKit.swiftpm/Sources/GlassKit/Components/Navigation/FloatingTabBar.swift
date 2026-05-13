import SwiftUI

/// A premium floating tab bar featuring glass-morphic backgrounds and matched geometry transitions.
///
/// Use this component for modern, tactile navigation in your application.
/// It automatically handles selection animations and background material transitions.
public struct FloatingTabBar<Tab: Hashable & CaseIterable & Identifiable>: View where Tab.AllCases: RandomAccessCollection {
    /// The currently selected tab.
    @Binding var selection: Tab
    /// A closure that returns the display label for a given tab.
    let label: (Tab) -> String
    /// A closure that returns the SF Symbol name for a given tab.
    let icon: (Tab) -> String
    
    @Namespace private var animation
    
    /// Initializes a new FloatingTabBar.
    /// - Parameters:
    ///   - selection: The selection binding.
    ///   - label: Label provider closure.
    ///   - icon: Icon provider closure.
    public init(
        selection: Binding<Tab>,
        label: @escaping (Tab) -> String,
        icon: @escaping (Tab) -> String
    ) {
        self._selection = selection
        self.label = label
        self.icon = icon
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases) { tab in
                Button {
                    withAnimation(DesignTokens.Motion.snappy) {
                        selection = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: icon(tab))
                            .font(.system(size: 20))
                        
                        Text(label(tab))
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(selection == tab ? .accentColor : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignTokens.Spacing.s)
                    .background {
                        if selection == tab {
                            GlassSurface(level: .thin, cornerRadius: DesignTokens.Radius.l)
                                .matchedGeometryEffect(id: "tab", in: animation)
                                .padding(4)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(DesignTokens.Spacing.xs)
        .background {
            GlassSurface(level: .thick, cornerRadius: DesignTokens.Radius.xl)
        }
        .padding(.horizontal)
    }
}

#Preview {
    enum MockTab: String, CaseIterable, Identifiable {
        case home, search, profile
        var id: String { rawValue }
    }
    
    return ZStack {
        Color.purple.ignoresSafeArea()
        
        VStack {
            Spacer()
            FloatingTabBar(
                selection: .constant(MockTab.home),
                label: { $0.rawValue.capitalized },
                icon: {
                    switch $0 {
                    case .home: return "house.fill"
                    case .search: return "magnifyingglass"
                    case .profile: return "person.fill"
                    }
                }
            )
        }
    }
}
