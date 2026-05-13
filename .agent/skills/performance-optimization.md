# Skill: Performance Optimization (NovaUI)

## Metrics
- **FPS**: Maintain 120 FPS on ProMotion displays.
- **Memory**: Minimize memory footprint of blur buffers.
- **Overdraw**: Reduce the number of overlapping transparent layers.

## Techniques
- **Drawing Group**: Use `.drawingGroup()` to flatten view hierarchies into a single GPU-rendered layer.
- **TimelineView**: Use for animations that don't need explicit state tracking.
- **Equatability**: Implement `Equatable` for views with complex rendering to skip body recalculations.
- **Material Sharing**: Use native materials where possible to benefit from OS-level optimizations.

## GPU Auditing
- Check for "Color Blended Layers" in Instruments.
- Monitor "GPU Utilization" during complex transitions.
