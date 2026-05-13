import SwiftUI

struct ComponentMetadata {
    let name: String
    let description: String
    let usage: String
}

func getComponentMetadata(for name: String) -> ComponentMetadata {
    switch name {
    case "GlassSurface":
        return ComponentMetadata(name: name, description: "A primitive view that provides a frosted glass effect using ultra-thin materials and an optional specular highlight.", usage: "GlassSurface(level: .thin)\n    .frame(height: 100)")
    case "MorphingShape":
        return ComponentMetadata(name: name, description: "An animatable shape that smoothly interpolates between two paths, providing dynamic liquid-like transitions.", usage: "MorphingShape(morphProgress: 0.5)\n    .fill(.blue)")
    case "DynamicRadius":
        return ComponentMetadata(name: name, description: "A shape allowing independent configuration of each corner radius, ideal for complex card layouts.", usage: "DynamicCornerRadius(topLeft: 20, bottomRight: 20)\n    .fill(.purple)")
    case "AnimatedBorder":
        return ComponentMetadata(name: name, description: "Applies a constantly moving, gradient-based border to a view for a high-end glowing effect.", usage: "Text(\"Content\")\n    .animatedBorder(colors: [.blue, .purple])")
    case "FloatingActionButton":
        return ComponentMetadata(name: name, description: "A primary call-to-action button that floats above the content, providing immediate access to a key action.", usage: "FloatingActionButton(icon: \"plus\") { \n    // Action \n}")
    case "IconButton":
        return ComponentMetadata(name: name, description: "A compact button containing only an icon, styled with a subtle glass effect.", usage: "IconButton(\"heart.fill\", tint: .red) { \n    // Action \n}")
    case "ReactionButton":
        return ComponentMetadata(name: name, description: "An interactive button designed for social reactions, complete with counting logic and scaling animations.", usage: "ReactionButton(emoji: \"🚀\", count: $count, isActive: $isActive)")
    case "SegmentedPill":
        return ComponentMetadata(name: name, description: "A modern, pill-shaped segmented control for navigating between tightly grouped categories.", usage: "SegmentedPill(selection: $tab, options: [\"A\", \"B\", \"C\"])")
    case "FatSlider":
        return ComponentMetadata(name: name, description: "An oversized, highly tactile slider with a glass styling that makes it easy to drag.", usage: "FatSlider(value: $sliderVal, tint: .blue)")
    case "StepSlider":
        return ComponentMetadata(name: name, description: "A discrete slider that snaps to predefined steps, perfect for ratings or ordinal selections.", usage: "StepSlider(value: $rating, steps: 5, labels: [\"1\", \"2\", \"3\", \"4\", \"5\"])")
    case "GlassCheckbox":
        return ComponentMetadata(name: name, description: "A custom toggle style that renders as a sleek, checkable box instead of a switch.", usage: "Toggle(\"Accept\", isOn: $toggleVal)\n    .toggleStyle(GlassCheckboxStyle())")
    case "GlassToggle":
        return ComponentMetadata(name: name, description: "A styled switch toggle utilizing glass effects to provide clear on/off states.", usage: "GlassToggle(\"Wi-Fi\", isOn: $toggleVal)")
    case "OTPInputField":
        return ComponentMetadata(name: name, description: "A specialized input field for one-time passwords, auto-advancing through fixed-width digit boxes.", usage: "OTPInputField(code: $code, length: 4)")
    case "TokenInputField":
        return ComponentMetadata(name: name, description: "An advanced input that turns typed text into removable tag tokens.", usage: "TokenInputField(tokens: $tokens)")
    case "CurrencyInput":
        return ComponentMetadata(name: name, description: "An input tailored for monetary values, automatically formatting input with currency symbols.", usage: "CurrencyInput(value: $amount)")
    case "ValidationTextField":
        return ComponentMetadata(name: name, description: "A text field with built-in regex validation and inline error message display.", usage: "ValidationTextField(\"Email\", text: $email, validation: .email, errorMessage: \"Invalid\")")
    case "FloatingLabelInput":
        return ComponentMetadata(name: name, description: "A text input where the placeholder animates into a floating label upon focus.", usage: "FloatingLabelInput(\"Username\", text: $username)")
    case "SecureInputField":
        return ComponentMetadata(name: name, description: "A password field that features an integrated eye toggle to reveal or obscure the text.", usage: "SecureInputField(\"Password\", text: $password)")
    case "RichTextEditor":
        return ComponentMetadata(name: name, description: "A multi-line text editor with a translucent glass background for extended writing.", usage: "RichTextEditor(text: $notes)")
    case "CocoaTextField":
        return ComponentMetadata(name: name, description: "A wrapper around native text fields for when deeper UIKit/AppKit integration is required.", usage: "CocoaTextField(\"Native Input\", text: $text)")
    case "InlineBanner":
        return ComponentMetadata(name: name, description: "A dismissible, semantic banner for displaying contextual alerts or status messages.", usage: "InlineBanner(title: \"Success\", message: \"Saved!\", type: .success)")
    case "ActivityRing":
        return ComponentMetadata(name: name, description: "A circular progress indicator similar to Apple Fitness rings.", usage: "ActivityRing(progress: 0.85, color: .green)")
    case "PulseLoader":
        return ComponentMetadata(name: name, description: "An indeterminate loading indicator that pulses organically.", usage: "PulseLoader(color: .blue)")
    case "OverlayToast":
        return ComponentMetadata(name: name, description: "A transient notification that appears temporarily overlaid on the interface.", usage: "view.overlay { OverlayToast(message: \"Done\", isPresented: $show) }")
    case "Snackbar":
        return ComponentMetadata(name: name, description: "A persistent or temporary message bar docked to the bottom of the screen.", usage: "Snackbar(message: \"Action completed\")")
    case "StatCard":
        return ComponentMetadata(name: name, description: "A dashboard-ready card displaying a key metric and its trend.", usage: "StatCard(title: \"Users\", value: \"1,284\", trend: \"+5%\")")
    case "ExpandableCard":
        return ComponentMetadata(name: name, description: "A container that can expand to reveal deeper secondary content.", usage: "ExpandableCard(title: \"Details\", isExpanded: $isExpanded) { ... }")
    case "BarChartContainer":
        return ComponentMetadata(name: name, description: "A stylized container for presenting array-based data as a bar chart.", usage: "BarChartContainer(data: [0.4, 0.7, 0.5])")
    case "TimelineView":
        return ComponentMetadata(name: name, description: "A chronological list view with a connecting timeline axis.", usage: "EventsTimelineView { Text(\"Event 1\") }")
    case "EventsTimelineView":
        return ComponentMetadata(name: name, description: "A chronological list view with a connecting timeline axis.", usage: "EventsTimelineView { Text(\"Event 1\") }")
    case "Accordion":
        return ComponentMetadata(name: name, description: "A collapsible section header that toggles content visibility.", usage: "Accordion(title: \"Advanced\") { ... }")
    case "InfiniteScrollView":
        return ComponentMetadata(name: name, description: "A scroll view designed to seamlessly load more content as the user nears the bottom.", usage: "InfiniteScrollView { ... }")
    case "VideoPlayerContainer":
        return ComponentMetadata(name: name, description: "A sleek wrapper for AVPlayer, styled seamlessly into the glass environment.", usage: "VideoPlayerContainer(url: videoURL)")
    case "ZoomableImageView":
        return ComponentMetadata(name: name, description: "An image viewer supporting pinch-to-zoom and panning interactions.", usage: "ZoomableImageView(imageName: \"photo\")")
    case "LivePhotoView":
        return ComponentMetadata(name: name, description: "A specialized viewer for playing Apple Live Photos.", usage: "LivePhotoView()")
    case "ConversationBubble":
        return ComponentMetadata(name: name, description: "A chat bubble component styled for user and AI message differentiation.", usage: "ConversationBubble(message: \"Hello\", isUser: true)")
    case "OrbitalMenu":
        return ComponentMetadata(name: name, description: "A radial menu that expands outward from a central focal point.", usage: "OrbitalMenu(isExpanded: $isOpen, items: [...])")
    case "VolumetricCard":
        return ComponentMetadata(name: name, description: "A 3D-aware card that shifts perspective based on user drag interactions.", usage: "VolumetricCard { ... }")
    case "SpotlightSearch":
        return ComponentMetadata(name: name, description: "A global search input designed to resemble Apple's Spotlight.", usage: "SpotlightSearch(isPresented: $show)")
    case "MarkdownRenderer":
        return ComponentMetadata(name: name, description: "A robust text view capable of parsing and rendering rich Markdown.", usage: "MarkdownRenderer(markdown: \"**Bold** text\")")
    case "DepthAwareContainer":
        return ComponentMetadata(name: name, description: "A spatial computing container that reacts to z-axis depth in VisionOS.", usage: "DepthAwareContainer { ... }")
    case "SpatialToolbar":
        return ComponentMetadata(name: name, description: "A floating, volumetric toolbar tailored for spatial computing environments.", usage: "SpatialToolbar()")
    case "CommandPalette":
        return ComponentMetadata(name: name, description: "A keyboard-driven command palette for power user navigation.", usage: "FloatingCommandPalette(isPresented: $show, commands: [...])")
    case "MorphingSheet":
        return ComponentMetadata(name: name, description: "A bottom sheet presentation that morphs smoothly from its origin element.", usage: "MorphingBottomSheet(isPresented: $show) { ... }")
    case "DetentSheetContainer":
        return ComponentMetadata(name: name, description: "A sheet utilizing SwiftUI detents to snap to multiple height levels.", usage: "DetentSheetContainer(isPresented: $show) { ... }")
    default:
        return ComponentMetadata(name: name, description: "No description available.", usage: "// No usage available.")
    }
}
