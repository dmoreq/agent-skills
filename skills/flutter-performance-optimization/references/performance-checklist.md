# Flutter Performance Optimization Reference Patterns

## 1. Replacing Nested `shrinkWrap: true` Lists with `CustomScrollView` Slivers

### Anti-Pattern (Disables Lazy Loading - Builds All Items Upfront)

```dart
// BAD: shrinkWrap forces full layout of all 10,000 items on frame 1
SingleChildScrollView(
  child: Column(
    children: [
      const HeaderBanner(),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => ItemTile(item: items[index]),
      ),
    ],
  ),
)
```

### Best Practice (`CustomScrollView` + `SliverFixedExtentList`)

```dart
// GOOD: Lazy virtualization preserved + O(1) scroll jump via itemExtent
CustomScrollView(
  slivers: [
    const SliverToBoxAdapter(child: HeaderBanner()),
    SliverFixedExtentList.builder(
      itemExtent: 72.0,
      itemCount: items.length,
      itemBuilder: (context, index) => ItemTile(
        key: ValueKey(items[index].id),
        item: items[index],
      ),
    ),
  ],
)
```

## 2. Caching Static Child in `AnimatedBuilder`

```dart
class RotatingBadge extends StatelessWidget {
  const RotatingBadge({required this.controller, super.key});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        // Built ONCE, never rebuilt during the 60/120fps rotation ticks
        child: const ExpensiveBadgeGraphic(),
        builder: (context, staticChild) {
          return Transform.rotate(
            angle: controller.value * 6.283185,
            child: staticChild,
          );
        },
      ),
    );
  }
}
```

## 3. Right-Sizing Image Memory Cache (`cacheWidth`)

```dart
class AvatarThumbnail extends StatelessWidget {
  const AvatarThumbnail({required this.imageUrl, this.size = 48, super.key});
  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final targetCachePixels = (size * dpr).round();

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        cacheWidth: targetCachePixels,
        cacheHeight: targetCachePixels,
        fit: BoxFit.cover,
      ),
    );
  }
}
```
