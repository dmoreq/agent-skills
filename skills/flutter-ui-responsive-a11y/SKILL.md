---
name: flutter-ui-responsive-a11y
description: Build adaptive, responsive, accessible, and localized Flutter UI components using small const Widget classes, Material 3 theming, window breakpoints, layout constraint rules, Semantics, and ARB localization. Use when creating screens or widgets, fixing RenderFlex overflow or unbounded height layout errors, designing for mobile/tablet/desktop/foldables, implementing dark mode themes, or adding accessibility and RTL i18n support.
risk: safe
source: local
date_added: "2026-10-29"
---
# Flutter UI Composition, Responsive Design, Accessibility, and Localization

## Summary

Compose clean, maintainable Flutter widgets that adapt gracefully across phone, tablet, desktop, and web viewports while respecting Material 3 theming, accessibility (`Semantics` + dynamic font scaling), and RTL internationalization.

## When to Use

- Building new screens, forms, lists, dialogs, or custom design system components
- Fixing layout exceptions (`RenderFlex overflowed`, `Vertical viewport was given unbounded height`, `Incorrect use of ParentDataWidget`)
- Adapting layouts for mobile, tablet, desktop, and foldable screens
- Setting up `ThemeData`, `ColorScheme`, and custom `ThemeExtension` tokens
- Adding localization (`gen-l10n` / `.arb`) or auditing WCAG accessibility and RTL support

## Steps

### 1. Compose Small `const` Widgets (Never `_buildX()` Helper Methods)

Structure widget trees for readability and surgical rebuilds:

- Extract subtrees into dedicated `StatelessWidget` classes with `const` constructors and `super.key` instead of private `_buildHeader()` methods. When a parent rebuilds, Flutter skips rebuilding `const` child widgets entirely, whereas helper functions execute every time.
- Keep `build()` methods under 60-80 lines by extracting logical visual sections into named widget classes.
- Use `ValueKey(item.id)` on stateful or reorderable list items so the Element tree matches state to the right widget when items are inserted, removed, or reordered.

### 2. Follow Flutter's Layout Constraint Rule and Fix Overflows

Remember the fundamental layout rule: **Constraints go down. Sizes go up. Parent sets position.**

- **Prevent horizontal/vertical `RenderFlex overflowed`**:
  - Wrap variable-length `Text` inside a `Row` with `Expanded` or `Flexible`.
  - Allow long forms or dialogs to scroll when the soft keyboard opens or text scaling is 200% by wrapping content in `SingleChildScrollView` or `CustomScrollView`.
  - Replace fixed `height: 200` on cards containing text with `ConstrainedBox(constraints: const BoxConstraints(minHeight: 200))` so large accessibility fonts can expand vertically without clipping.
- **Prevent `Vertical viewport was given unbounded height`**:
  - Never place a `ListView`, `GridView`, or `PageView` directly inside a `Column` or `SingleChildScrollView` without bounding its height via `Expanded`, `Flexible`, or replacing the outer `Column` with a `CustomScrollView` + `SliverList`.
- **Use lightweight single-purpose widgets**: Prefer `Padding`, `Align`, `SizedBox`, `ColoredBox`, and `DecoratedBox` over a heavy `Container` when only one property is needed.

### 3. Build Adaptive and Responsive Layouts by Breakpoints (Not Platform)

Adapt layouts to available space and input capabilities rather than checking `Platform.isIOS` or `Platform.isAndroid`:

- Use `MediaQuery.sizeOf(context)` (never `MediaQuery.of(context).size`, which rebuilds on every keyboard/inset animation frame) for window-level breakpoint decisions.
- Use `LayoutBuilder` when a component's layout depends on its parent's local constraints rather than the full window.
- Apply Material 3 window size classes:
  - **Compact (`width < 600`)**: Single-column layout, bottom `NavigationBar`, full-width sheets.
  - **Medium (`600 <= width < 840`)**: Two-column grid or constrained max-width (`ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720))`), `NavigationRail`.
  - **Expanded (`width >= 840`)**: List-detail two-pane split view, extended `NavigationRail` or side navigation drawer.
- Preserve user state (scroll offset, selected item, text input) across window resizes or orientation changes by sharing the same ViewModel and `GlobalKey` / `PageStorageKey` where needed.

### 4. Enforce Theme Tokens and Handle All 4 UI States

Never hardcode hex colors (`Color(0xFF...)`) or raw text styles inline inside feature screens:

- Derive colors from `Theme.of(context).colorScheme` (`ColorScheme.fromSeed`) and typography from `Theme.of(context).textTheme`.
- Define custom brand tokens (spacing, custom semantic colors, radii) in a `ThemeExtension<T>` (see `references/adaptive-and-theme-examples.md`).
- Design every data-driven screen to handle all 4 states explicitly: **Loading** (skeleton or adaptive progress indicator), **Empty** (illustration/message + primary CTA), **Error** (human-readable failure message + retry button), and **Content**.

### 5. Build in Accessibility (a11y) and RTL Localization (i18n) from Day One

- **Accessibility**:
  - Ensure all interactive tap targets are at least `48x48` logical pixels.
  - Provide `tooltip` on every `IconButton` and `semanticLabel` on meaningful icons/images (`excludeFromSemantics: true` on purely decorative images).
  - Wrap custom composite cards (e.g., an item row with title, subtitle, and price) in `MergeSemantics` or `Semantics(button: true, label: ...)` so TalkBack/VoiceOver reads them as a single coherent element.
  - Never clamp `MediaQuery.textScalerOf(context)` to `1.0`; test layouts at `2.0x` text scale.
- **Localization & RTL**:
  - Store all user-facing strings in `.arb` files (`lib/l10n/app_en.arb`, `app_vi.arb`) using `flutter_localizations` and `generate: true` in `pubspec.yaml`.
  - Always use directional geometry (`EdgeInsetsDirectional.only(start: 16, end: 8)`, `AlignmentDirectional.centerStart`, `BorderRadiusDirectional`) instead of `left`/`right` so Arabic/Hebrew RTL layouts mirror automatically.

### 6. Verify UI and Layout

```bash
flutter analyze
flutter test
```

## Gotchas

- **Using `MediaQuery.of(context)` broadly**: Subscribes the widget to all `MediaQueryData` changes (keyboard inset, orientation, padding, brightness). Always use specific aspect methods: `MediaQuery.sizeOf(context)`, `MediaQuery.paddingOf(context)`, `MediaQuery.textScalerOf(context)`.
- **Forgetting `TextEditingController` and `FocusNode` disposal**: Every controller or focus node instantiated in `State` must be disposed in `dispose()` to prevent memory leaks.

## Related Skills
- Use **flutter-state-management** when widgets need to consume or dispatch state.
- Use **flutter-navigation-routing** when screens navigate via `go_router` or deep links.
- Use **design-system** when Material 3 theme tokens must follow the design token contract.
- Use **ui-accessibility** when the rendered Flutter UI needs a WCAG 2.2 accessibility audit.
- Use **flutter-performance-optimization** when widget composition or layout depth causes rebuild or frame-budget issues.
