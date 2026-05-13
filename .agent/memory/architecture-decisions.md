# Architecture Decision Records (ADR)

## ADR 001: Environment-Driven Theming
- **Status**: Accepted
- **Context**: Need a way to inject style tokens without passing them through every initializer.
- **Decision**: Use SwiftUI `EnvironmentValues` with a `AppTheme` protocol.
- **Consequence**: Components must access tokens via `@Environment(\.theme)`.

## ADR 002: GPU Optimization via DrawingGroup
- **Status**: Accepted
- **Context**: Glass effects are expensive on low-end devices.
- **Decision**: Wrap complex glass primitives in `.drawingGroup()`.
- **Consequence**: Better FPS, but limited support for some nested interactive subviews (must be used carefully).
