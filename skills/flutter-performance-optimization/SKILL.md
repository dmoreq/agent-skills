---
name: flutter-performance-optimization
description: Optimize Flutter rendering, scrolling, memory usage, and CPU frame budgets (16ms at 60fps / 8ms at 120fps) by minimizing widget rebuilds, avoiding saveLayer/Opacity/Clip pitfalls, using lazy Sliver/ListView builders, sizing image caches, and offloading work to background Isolates. Use when fixing UI jank, dropped frames, slow list scrolling, high memory consumption, or auditing Flutter performance.
risk: safe
source: local
date_added: "2026-10-29"
---
# Flutter Performance Optimization

## Summary

Keep build and raster frame times well below 8ms each (16ms total for 60Hz, 8ms total for 120Hz ProMotion displays) by following official Flutter performance engineering rules: control `build()` cost, eliminate unnecessary `saveLayer()` allocations, virtualize scrollable lists, size decoded images in memory, and move heavy compute to background isolates.

## When to Use

- Auditing or fixing dropped frames, scroll jank, or slow animations in a Flutter app
- Building long or complex scrollable feeds (`ListView.builder`, `CustomScrollView`, `SliverList`)
- Optimizing image memory footprint and asset pre-caching (`precacheImage`, `cacheWidth`)
- Offloading heavy JSON parsing, cryptography, image compression, or sorting to `Isolate.run`
- Profiling rendering bottlenecks in `--profile` mode using Flutter DevTools

## Steps

### 1. Control `build()` Cost and Localize Rebuilds

Ensure `build()` methods are pure, fast, and scoped to the smallest possible subtree:

- Never run synchronous file I/O, heavy sorting/filtering, regex compilation, or object allocation inside `build()`.
- Push `setState()`, `ListenableBuilder`, `Consumer`, or `BlocBuilder` down to the exact leaf widget that changes rather than wrapping an entire `Scaffold`.
- Pass static subtrees via the `child` parameter of `AnimatedBuilder`, `ValueListenableBuilder`, `ListenableBuilder`, and `TweenAnimationBuilder` so the subtree is built once and reused on every animation tick.
- Mark all stateless widget constructors `const` and apply `const` at call sites so Flutter short-circuits element rebuild traversal via identity check (`identical(oldWidget, newWidget)`).
- Never override `operator ==` on `Widget` subclasses (it degrades rebuild performance to $O(N^2)$ across the tree and de-optimizes compiler static dispatch).

### 2. Eliminate Expensive `saveLayer()`, `Opacity`, and `Clip` Operations

Prevent offscreen GPU buffer switches on mobile devices:

- **Avoid wrapping widgets in `Opacity` when simpler alternatives exist**:
  - For single shapes, icons, or text without overlapping children, use a semitransparent color directly (`color.withValues(alpha: 0.5)`).
  - For images, pass `color: Colors.white.withValues(alpha: 0.5)` and `colorBlendMode: BlendMode.modulate`.
  - For fade animations, always use `AnimatedOpacity` or `FadeTransition` (or `FadeInImage`), never an `Opacity` widget driven by `setState()`.
- **Minimize clipping**:
  - For rounded rectangles on containers or cards, set `decoration: BoxDecoration(borderRadius: ...)` rather than wrapping in `ClipRRect`.
  - Never animate a `ClipPath` or `ClipRRect` on every frame if the asset can be pre-clipped.
- **Audit `saveLayer()` triggers**: Watch out for `ShaderMask`, `ColorFilter`, `BackdropFilter`, and `Text` with `overflowShader`. Isolate frequently repainted animations (such as a spinning indicator or custom canvas) from static backgrounds using a surgical `RepaintBoundary`.

### 3. Virtualize Grids and Lists (Avoid Intrinsic Passes)

Render large lists with $O(1)$ startup cost:

- Always use lazy builders (`ListView.builder`, `ListView.separated`, `GridView.builder`, `SliverList.builder`) instead of passing a concrete `children: [...]` list when items exceed what fits on a single screen.
- Specify `itemExtent` or `prototypeItem` on `ListView.builder` whenever list items have uniform height; this lets the scroll view calculate scroll offset and scrollbar thumb size in $O(1)$ without laying out offscreen children.
- Avoid `IntrinsicHeight` and `IntrinsicWidth` inside scrollable list items or large grids; intrinsic passes force a double layout pass across children. Fix cell heights upfront or align via standard flex constraints instead.
- Use `StringBuffer` instead of `+` concatenation when assembling strings inside loops.

### 4. Right-Size Decoded Images and Pre-Cache Critical Assets

Prevent out-of-memory (OOM) crashes from decoding 4K photos into small thumbnails:

- Specify `cacheWidth` (or `cacheHeight`) on `Image.network`, `Image.asset`, and `ResizeImage` matching `displayWidth * MediaQuery.devicePixelRatioOf(context)` so the engine decodes only the pixels actually rendered.
- Preload hero or onboarding images before transition using `precacheImage(AssetImage('...'), context)` in `didChangeDependencies()`.

### 5. Offload CPU-Intensive Work to Isolates

Keep the UI isolate free for 120Hz frame scheduling:

- Any synchronous computation taking **> 4ms** (large JSON decoding, CSV export, encryption, image manipulation, fuzzy search over thousands of rows) must run on a worker isolate using `await Isolate.run(() => heavyWork(input))`.
- See `references/performance-checklist.md` for `Isolate.run`, `RepaintBoundary`, and `AnimatedBuilder` optimization examples.

### 6. Measure in Profile Mode (Never Debug Mode)

Always verify performance fixes on a physical device in `--profile` mode (`flutter run --profile`), because `--debug` mode enables assertions and JIT overhead that skew frame timings:

```bash
flutter analyze
flutter test
```

## Gotchas

- **`ShrinkWrap: true` inside nested scrollables**: Setting `shrinkWrap: true` on an inner `ListView` disables lazy virtualization and forces Flutter to build and measure every single item immediately. Replace nested `SingleChildScrollView` + `ListView(shrinkWrap: true)` with a single `CustomScrollView` containing multiple `SliverList` / `SliverToBoxAdapter` children.
- **Overusing `RepaintBoundary`**: Wrapping every list item in `RepaintBoundary` allocates separate GPU textures for each row and increases memory pressure. Add `RepaintBoundary` only when DevTools (`debugRepaintRainbowEnabled = true`) confirms a complex static subtree is being repainted unnecessarily by an adjacent animation.

## Related Skills
- Use **flutter-ui-responsive-a11y** when widget composition affects rebuild scope or layout cost.
- Use **flutter-state-management** when provider selectors or listener scoping control rebuilds.
- Use **flutter-testing-verification** when performance regressions need golden or frame-time tests.
- Use **flutter-codegen-release** when generated code or release builds affect runtime performance.
