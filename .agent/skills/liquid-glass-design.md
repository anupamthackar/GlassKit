# Skill: Liquid Glass Design (NovaUI)

## Visual Principles
- **Refraction**: Use `.ultraThinMaterial` background with a subtle overlay to simulate light bending.
- **Specular Highlights**: Apply a top-leading white gradient stroke (0.5pt to 1pt) to simulate edge lighting.
- **Layered Depth**: Use `ZStack` with varying blur radii and offsets.
- **Vibrancy**: Ensure foreground text uses `.secondary` or `.tertiary` materials where appropriate to pull background colors through.

## Implementation Guide
1. **Base Layer**: `GlassSurface` with `regular` or `thin` material.
2. **Highlight Layer**: `strokeBorder` with a white-to-transparent linear gradient.
3. **Shadow Layer**: Use `DesignTokens.Elevation` shadow tokens for soft, deep shadows.
4. **Motion Layer**: Reactive hover/press scales (1.02x / 0.95x).

## Performance Constraints
- Always use `.drawingGroup()` for complex glass stacks.
- Avoid multiple heavy blurs in a single view hierarchy; prefer shared sampling.
