import SwiftUI

// MARK: - FEEDBACK

public struct Snackbar: View {
    let message: String
    public init(message: String) { self.message = message }
    public var body: some View {
        Text(message)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(8)
    }
}

// MARK: - DATA DISPLAY

public struct EventsTimelineView<Content: View>: View {
    let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }
    public var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .padding(.leading, 20)
        .overlay(
            Rectangle().frame(width: 2).foregroundColor(.gray.opacity(0.3)),
            alignment: .leading
        )
    }
}

public struct Accordion<Content: View>: View {
    let title: String
    let content: Content
    @State private var isExpanded = false
    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    public var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            content.padding(.top, 8)
        } label: {
            Text(title).font(.headline)
        }
        .padding()
        .glassCard()
    }
}

public struct InfiniteScrollView<Content: View>: View {
    let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }
    public var body: some View {
        ScrollView { content }
    }
}

// MARK: - MEDIA

public struct VideoPlayerContainer: View {
    let url: URL?
    public init(url: URL?) { self.url = url }
    public var body: some View {
        ZStack {
            Rectangle().fill(.black.opacity(0.8))
            Image(systemName: "play.circle.fill").font(.largeTitle).foregroundColor(.white)
        }
        .glassCard()
    }
}

public struct ZoomableImageView: View {
    let imageName: String
    @State private var scale: CGFloat = 1.0
    public init(imageName: String) { self.imageName = imageName }
    public var body: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .gesture(MagnificationGesture().onChanged { val in scale = val })
            .glassCard()
    }
}

public struct LivePhotoView: View {
    public init() {}
    public var body: some View {
        Image(systemName: "livephoto.play")
            .font(.largeTitle)
            .padding()
            .glassCard()
    }
}

// MARK: - NAVIGATION



public struct DetentSheetContainer<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    public init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
    public var body: some View {
        Text("DetentSheetContainer Trigger")
            .sheet(isPresented: $isPresented) {
                content.presentationDetents([.medium, .large])
            }
    }
}

// MARK: - AI COMPONENTS



public struct MarkdownRenderer: View {
    let markdown: String
    public init(markdown: String) { self.markdown = markdown }
    public var body: some View {
        Text(markdown)
            .padding()
            .glassCard()
    }
}

// MARK: - VISIONOS



public struct SpatialToolbar: View {
    public init() {}
    public var body: some View {
        HStack {
            Button(action: {}) { Image(systemName: "cube") }
            Button(action: {}) { Image(systemName: "sphere") }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}
