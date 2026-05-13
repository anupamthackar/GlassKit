# Skill: SwiftUI Architecture (NovaUI)

## Patterns
- **Protocol-Oriented Styles**: Use `ButtonStyle`, `ToggleStyle`, etc., for all interactive elements.
- **Environment Keys**: Use `EnvironmentValues` for theme and capability injection.
- **View Modifiers**: Use extensions on `View` for composable behavior.
- **Preference Keys**: Use for bottom-up data flow (e.g., dynamic sizing).

## Best Practices
1. **Body Optimization**: Keep `body` small and focused.
2. **Equatability**: Use `Equatable` views to prevent unnecessary re-renders.
3. **Lazy Loading**: Use `LazyVStack` and `LazyHStack` for large collections.
4. **State Management**: Use `@State` for local state and `@Observable` (iOS 17+) for shared logic.

## Anti-Patterns to Avoid
- Monolithic views with hundreds of lines.
- Passing around huge binding objects when local state suffices.
- Direct UIKit manipulation unless bridged properly through `UIViewRepresentable`.
