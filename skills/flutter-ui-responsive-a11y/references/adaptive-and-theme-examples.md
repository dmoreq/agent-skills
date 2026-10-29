# Adaptive Scaffold and ThemeExtension Reference Examples

## 1. Material 3 Adaptive Navigation Scaffold (`<600` / `600-839` / `>=840`)

```dart
import 'package:flutter/material.dart';

enum WindowSizeClass {
  compact,
  medium,
  expanded;

  static WindowSizeClass fromWidth(double width) {
    if (width < 600) return WindowSizeClass.compact;
    if (width < 840) return WindowSizeClass.medium;
    return WindowSizeClass.expanded;
  }
}

class AdaptiveNavigationShell extends StatelessWidget {
  const AdaptiveNavigationShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final sizeClass = WindowSizeClass.fromWidth(width);

    if (sizeClass == WindowSizeClass.compact) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: sizeClass == WindowSizeClass.expanded,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: [
                for (final dest in destinations)
                  NavigationRailDestination(
                    icon: dest.icon,
                    selectedIcon: dest.selectedIcon,
                    label: Text(dest.label),
                  ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
```

## 2. Custom `ThemeExtension` for Brand Spacing and Semantic Colors

```dart
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

@immutable
final class AppDesignTokens extends ThemeExtension<AppDesignTokens> {
  const AppDesignTokens({
    required this.successColor,
    required this.warningColor,
    required this.cardRadius,
    required this.pagePadding,
  });

  final Color successColor;
  final Color warningColor;
  final double cardRadius;
  final double pagePadding;

  static const light = AppDesignTokens(
    successColor: Color(0xFF1B873F),
    warningColor: Color(0xFFB75D00),
    cardRadius: 16,
    pagePadding: 16,
  );

  static const dark = AppDesignTokens(
    successColor: Color(0xFF57D982),
    warningColor: Color(0xFFFFB74D),
    cardRadius: 16,
    pagePadding: 16,
  );

  @override
  AppDesignTokens copyWith({
    Color? successColor,
    Color? warningColor,
    double? cardRadius,
    double? pagePadding,
  }) {
    return AppDesignTokens(
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      cardRadius: cardRadius ?? this.cardRadius,
      pagePadding: pagePadding ?? this.pagePadding,
    );
  }

  @override
  AppDesignTokens lerp(ThemeExtension<AppDesignTokens>? other, double t) {
    if (other is! AppDesignTokens) return this;
    return AppDesignTokens(
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
      pagePadding: lerpDouble(pagePadding, other.pagePadding, t)!,
    );
  }
}

extension AppDesignTokensBuildContext on BuildContext {
  AppDesignTokens get tokens =>
      Theme.of(this).extension<AppDesignTokens>() ?? AppDesignTokens.light;
}
```
