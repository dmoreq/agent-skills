# Flutter Testing Harness and Fake Repository Templates

## 1. Reusable `pumpApp` Widget Test Harness (`test/helpers/pump_app.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
    Size surfaceSize = const Size(390, 844),
    double textScaleFactor = 1.0,
  }) async {
    view.physicalSize = surfaceSize;
    view.devicePixelRatio = 1.0;
    platformDispatcher.textScaleFactorTestValue = textScaleFactor;

    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
      platformDispatcher.clearTextScaleFactorTestValue();
    });

    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          home: Scaffold(body: widget),
        ),
      ),
    );
  }
}
```

## 2. Riverpod `ProviderContainer` Test Helper (`test/helpers/provider_container.dart`)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );
  addTearDown(container.dispose);
  return container;
}
```

## 3. Multi-Viewport and Accessibility Verification Test Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileCard renders without overflow at 2.0x text scale and meets a11y guidelines',
      (tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    try {
      await tester.pumpApp(
        const ListTile(
          title: Text('Alex Nguyen'),
          subtitle: Text('Senior Flutter Engineer'),
        ),
        surfaceSize: const Size(320, 568), // Small screen
        textScaleFactor: 2.0, // Large accessibility text
      );

      expect(tester.takeException(), isNull); // Verifies zero RenderFlex overflow
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    } finally {
      handle.dispose();
    }
  });
}
```
