# GlassKit (NovaUI) — AI Agent System

Welcome to the **GlassKit** engineering ecosystem. This project is built to be managed and extended by specialized AI agents working in harmony with human architects.

## Core Architecture Principles
- **SOLID**: Strict adherence to single responsibility and modularity.
- **Protocol-Oriented**: Abstractions over concrete implementations.
- **Environment-Driven**: All styling and behavior must be injected via `Environment`.
- **Performance-First**: Optimized for GPU rendering and minimal body recalculations.

## Agent Roles & Responsibilities

### 🏗️ UI Architect Agent
- **Focus**: Scalable SwiftUI APIs, structural integrity, and pattern consistency.
- **Skill**: [swiftui-architecture.md](.agent/skills/swiftui-architecture.md)
- **Responsibility**: Designing new components and maintaining the framework core.

### 🎨 Design System Agent
- **Focus**: Design token integrity, Liquid Glass rendering, and visual harmony.
- **Skill**: [liquid-glass-design.md](.agent/skills/liquid-glass-design.md)
- **Responsibility**: Managing `DesignTokens`, materials, and theme resolution.

### ♿ Accessibility Agent
- **Focus**: WCAG 2.1 compliance, VoiceOver support, and inclusive design.
- **Skill**: [accessibility-audit.md](.agent/skills/accessibility-audit.md)
- **Responsibility**: Auditing components and ensuring AX5 support.

### ⚡ Performance Agent
- **Focus**: FPS optimization, memory management, and GPU overdraw.
- **Skill**: [performance-optimization.md](.agent/skills/performance-optimization.md)
- **Responsibility**: Profiling components and suggesting rendering optimizations.

### 🧪 Testing Agent
- **Focus**: Unit tests, snapshot tests, and regression testing.
- **Skill**: [testing-strategy.md](.agent/skills/testing-strategy.md)
- **Responsibility**: Generating and maintaining the test suite.

### 📚 Documentation Agent
- **Focus**: DocC, READMEs, and example applications.
- **Skill**: [documentation-writer.md](.agent/skills/documentation-writer.md)
- **Responsibility**: Keeping the framework documentation up to date.

## Component Workflow
1. **Define Tokens**: Add or update tokens in `DesignTokens`.
2. **Build Primitive**: Create the base rendering logic in `Materials`.
3. **Implement ViewStyle**: Create a modular style protocol if applicable.
4. **Create Component**: Build the public-facing view using the style.
5. **Add Preview**: Include comprehensive previews for light/dark modes.
6. **Accessibility Audit**: Run the AX agent to ensure compliance.
7. **Document**: Write DocC comments for all public members.

## Mandatory Rules
- **No Hardcoded Values**: Never use literal colors or sizes outside of `DesignTokens`.
- **Previews Mandatory**: Every public component must have a SwiftUI `#Preview`.
- **Environment Driven**: Components must respect `EnvironmentValues`.
- **Performance**: Avoid deep hierarchy nesting and expensive blurs in high-frequency views.
