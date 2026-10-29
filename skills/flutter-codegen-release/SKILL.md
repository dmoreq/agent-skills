---
name: flutter-codegen-release
description: Manage Flutter code generation (build_runner, freezed, json_serializable, drift), dependency hygiene, resilient app bootstrap error handling, multi-environment flavors (--dart-define-from-file), code obfuscation, and CI/CD release gates. Use when running build_runner, resolving pubspec conflicts, configuring main.dart crash handling, setting up dev/staging/prod flavors, or preparing Android/iOS/Web production builds.
risk: safe
source: local
date_added: "2026-10-29"
---
# Flutter Codegen, Tooling, App Bootstrap, and Release Shipping

## Summary

Keep Flutter build pipelines fast, deterministic, and production-ready. Standardize `build_runner` code generation, enforce dependency hygiene, capture all synchronous and asynchronous crashes in `main()`, configure flavors via `--dart-define-from-file`, and ship obfuscated release builds with archived debug symbols.

## When to Use

- Running or configuring `build_runner` (`freezed`, `json_serializable`, `riverpod_generator`, `drift_dev`)
- Resolving `pubspec.yaml` dependency version conflicts or auditing outdated packages
- Writing `main.dart` initialization and global crash/error reporting hooks
- Setting up `dev`, `staging`, and `prod` environments and secret injection
- Configuring GitHub Actions CI gates or building release APKs/AppBundles/IPAs

## Steps

### 1. Optimize `build_runner` Code Generation

Keep code generation fast and conflict-free:

- Run `build_runner` deterministically using:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- Scope builders in `build.yaml` (`generate_for: include: - lib/features/**/models/**.dart`) so `build_runner` only scans files that actually contain annotations instead of every file in `lib/`.
- Exclude `**/*.g.dart` and `**/*.freezed.dart` from `analysis_options.yaml` and test coverage reports so generated code never slows down analysis or skews coverage metrics.
- Never manually edit `.g.dart` or `.freezed.dart` files.

### 2. Harden App Startup and Global Error Handling (`main.dart`)

Structure `main()` so every uncaught framework and async platform error is logged before `runApp` starts:

1. Call `WidgetsFlutterBinding.ensureInitialized();`.
2. Configure `FlutterError.onError = (details) { FlutterError.presentError(details); crashReporter.recordFlutterError(details); };` to catch widget build/layout/rendering errors.
3. Configure `PlatformDispatcher.instance.onError = (error, stack) { crashReporter.recordError(error, stack, fatal: true); return true; };` to catch uncaught asynchronous errors without needing legacy `runZonedGuarded`.
4. Set a custom `ErrorWidget.builder` for release builds (`if (kReleaseMode)`) so users see a friendly fallback card instead of a grey/red screen of death if a single widget fails to build.
5. Run only fast, essential local initialization before `runApp()`; defer heavy SDK initialization to a splash/bootstrap state so the first frame renders immediately.

### 3. Manage Environment Configs with `--dart-define-from-file`

Keep API keys and environment URLs out of source code and away from runtime `.env` asset bundles (assets packaged in `pubspec.yaml` are trivially extractable in plaintext from an APK/IPA):

- Create per-flavor JSON config files (`config/dev.json`, `config/prod.json`) and pass `--dart-define-from-file=config/prod.json` at build/run time.
- Read values as compile-time constants via `const String.fromEnvironment('API_BASE_URL')` inside a single `AppEnv` class, and assert at startup that required keys are non-empty.

### 4. Enforce Dependency Hygiene

Keep `pubspec.yaml` lean and reproducible:

- Commit `pubspec.lock` for application repositories so every developer and CI runner builds against identical transitive dependency versions.
- Before adding a third-party package, check whether the Dart/Flutter SDK already provides the capability natively (`http`, `intl`, `ValueNotifier`, `TransformationController`, `CarouselView`).
- Audit dependencies periodically:
  ```bash
  flutter pub outdated
  flutter pub deps
  ```

### 5. Build Obfuscated Releases and Enforce CI Gates

When building production Android App Bundles or iOS IPAs, enable Dart code obfuscation and split debug symbols (archive the debug symbols folder as a CI artifact to symbolicate production stack traces later):

```bash
# Android App Bundle
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols --dart-define-from-file=config/prod.json

# iOS IPA
flutter build ipa --release --obfuscate --split-debug-info=build/ios/symbols --dart-define-from-file=config/prod.json
```

Use the GitHub Actions workflow in `references/github-actions-ci.yml` to enforce formatting, codegen freshness, zero analyzer warnings, and randomized unit/widget tests on every pull request.

## Gotchas

- **Using `flutter_dotenv` for sensitive secrets**: Bundling `.env` in `pubspec.yaml` under `assets:` ships the raw `.env` file inside the uncompressed asset bundle of your APK/IPA. Use `--dart-define-from-file` for public client configuration and keep true private secrets on a backend server or Cloud Function.
- **Using `runZonedGuarded` in modern Flutter**: `runZonedGuarded` is no longer recommended for global error catching because it creates a custom Zone that can break `WidgetsFlutterBinding` zone assertions. Use `PlatformDispatcher.instance.onError` instead.

## Related Skills
- Use **flutter-architecture-data** when generated models or repositories define the data layer.
- Use **dart-modern-idioms** when reviewing generated Dart for idiom and exhaustiveness compliance.
- Use **flutter-testing-verification** when testing generated code or release builds.
