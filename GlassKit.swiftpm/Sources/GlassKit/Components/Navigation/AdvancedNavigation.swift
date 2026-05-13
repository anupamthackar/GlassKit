import SwiftUI

// MARK: - AdaptiveSidebar

/// A sidebar that collapses on mobile and remains visible on larger screens.
public struct AdaptiveSidebar<Sidebar: View, Detail: View>: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    let sidebar: Sidebar
    let detail: Detail
    
    public init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) {
        self.sidebar = sidebar()
        self.detail = detail()
    }
    
    public var body: some View {
        if sizeClass == .regular {
            HStack(spacing: 0) {
                sidebar
                    .frame(width: 280)
                    .background { GlassSurface(level: .thick, cornerRadius: 0) }
                Divider()
                detail
            }
        } else {
            NavigationStack {
                detail
                    .toolbar {
                        #if os(iOS)
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                // show sidebar in sheet or drawer
                            } label: {
                                Image(systemName: "sidebar.left")
                            }
                        }
                        #else
                        ToolbarItem(placement: .navigation) {
                            Button {
                                // show sidebar in sheet or drawer
                            } label: {
                                Image(systemName: "sidebar.left")
                            }
                        }
                        #endif
                    }
            }
        }
    }
}

// MARK: - HeroTransitionContainer

/// A container that simplifies matched geometry hero transitions.
public struct HeroTransitionContainer<Content: View>: View {
    let id: String
    let namespace: Namespace.ID
    let content: Content
    
    public init(id: String, namespace: Namespace.ID, @ViewBuilder content: () -> Content) {
        self.id = id
        self.namespace = namespace
        self.content = content()
    }
    
    public var body: some View {
        content
            .matchedGeometryEffect(id: id, in: namespace)
    }
}
