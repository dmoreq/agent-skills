---
name: dart-modern-idioms
description: Write idiomatic, type-safe Dart 3.x code following Effective Dart guidelines, pattern matching, exhaustive switch expressions, sealed classes, records, class modifiers, async safety, and strict static analysis. Use when writing or reviewing Dart code, refactoring legacy Dart 2 patterns, configuring analysis_options.yaml, fixing analyzer lints, or documenting public APIs with Dartdoc.
risk: safe
source: local
date_added: "2026-10-29"
---
# Modern Dart 3.x Idioms and Effective Dart

## Summary

Enforce Effective Dart standards, modern Dart 3.x language features, strict static analysis, and async safety. Replace verbose legacy patterns with concise, compiler-verified constructs.

## When to Use

- Writing new Dart classes, functions, extensions, or data models
- Refactoring `if-else` type chains or legacy enums into `sealed` classes and `switch` expressions
- Auditing asynchronous code (`Future`, `Stream`, `Timer`, `BuildContext` across `await` gaps)
- Setting up or tightening `analysis_options.yaml` and resolving `dart analyze` warnings
- Documenting public APIs using `///` Dartdoc comments

## Steps

### 1. Apply Modern Dart 3.x Language Features

Use Dart 3 constructs where they improve compile-time exhaustiveness and readability:

- **Sealed Hierarchies & Exhaustive Switches**: Declare closed state or result hierarchies as `sealed class`. Prefer `switch` expressions (`final label = switch (state) { ... };`) over statement blocks so the compiler enforces exhaustiveness without a `default` branch.
- **Pattern Matching & Destructuring**: Validate and extract JSON or object properties cleanly using `if (json case {'id': final String id, 'count': final int count})`.
- **Records**: Use records `(String id, int count)` or named records `({double lat, double lng})` for lightweight intra-layer multi-value returns. Promote a record to a dedicated `class` once it crosses architectural layers or requires behavior.
- **Class Modifiers**: Restrict inheritance intentionally:
  - `final class`: Concrete class that cannot be subclassed or implemented outside its library (default for most services, repositories, and models).
  - `abstract interface class`: Pure contract that can only be `implemented`, never `extended` (ideal for Repository interfaces).
  - `base class`: Enforces that subclasses call the base constructor and cannot be implicitly mocked via `implements` without `base`.
- **Extension Types**: Use `extension type const UserId(String value)` for zero-cost compile-time wrapper types around primitive IDs (`String`, `int`) or canonical units (cents, milliseconds) to prevent parameter mix-ups.
- **Null-Aware Collection Elements**: Use `?element` and `?...list` inside collection literals (`[header, ?optionalSubtitle, ...items]`) instead of `if (optionalSubtitle != null) optionalSubtitle`.

### 2. Follow Effective Dart Naming and Style

Adhere to official Effective Dart conventions:

- `UpperCamelCase` for classes, enums, typedefs, extensions, and type parameters.
- `lowerCamelCase` for variables, methods, parameters, and enum values.
- `lowercase_with_underscores` for file, directory, and package names.
- Prefer relative imports within `lib/` of the same package, or consistent `package:` imports across the workspace (never mix them in the same file; let linter enforce one).
- Omit redundant type annotations on local variables when the right-hand side makes the type obvious (`final users = <User>[];`), but always type public API signatures, fields, and top-level declarations explicitly.
- Use `Object?` instead of `dynamic` when accepting arbitrary unknown values (such as decoded JSON maps `Map<String, Object?>`), forcing explicit type checks or pattern matching before member access.

### 3. Enforce Async Safety (No Silent Failures)

Prevent race conditions, memory leaks, and unhandled async exceptions:

- **Never drop a `Future` silently**: Enable `unawaited_futures` and `discarded_futures` lints. When firing a background task intentionally inside a synchronous callback, wrap it explicitly with `unawaited(...)` from `dart:async` and ensure internal errors are caught.
- **Watch out for `() => asyncFn()` in `VoidCallback`**: Passing `onPressed: () => saveAsync()` returns a `Future` to a `void Function()` slot, bypassing `unawaited_futures` in older lint configs. Always handle errors inside `saveAsync()`.
- **Check `context.mounted` after every `await`**: Never use `BuildContext` after an `await` gap without first checking `if (!context.mounted) return;`.
- **Cancel subscriptions and timers**: Store every `StreamSubscription` and `Timer` created in a widget or service and cancel it in `dispose()` or `ref.onDispose()`.
- **Avoid `async void`**: Always return `Future<void>` from async functions so callers can `await` completion in production and tests.

### 4. Write High-Signal Dartdoc Comments

Document public classes, methods, and properties with `///`:

- Start every doc comment with a single-sentence summary ending in a period, followed by a blank line.
- Write from the caller's perspective using third-person declarative verbs ("Returns the user profile..." or "Throws a [StateError] if...").
- Reference in-scope identifiers in brackets (`[UserRepository]`) so `dart doc` and IDEs link them and flag broken references.
- Use `//` implementation comments only to explain *why* a non-obvious decision or workaround exists, never *what* the code literally does.

### 5. Configure Strict Static Analysis and Verify

Include `flutter_lints` or `very_good_analysis` in `analysis_options.yaml` and enable strict type checks (`strict-casts`, `strict-inference`, `strict-raw-types`). Copy the template from `references/analysis-options-template.yaml` when setting up a project.

Verify all Dart changes with:

```bash
dart fix --dry-run
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
```

## Gotchas

- **Using `default:` in switches over `sealed` classes**: Adding a `default:` or `_:` branch silences compiler errors when a new subtype is added later. Handle every subtype explicitly so future additions fail compilation until handled.
- **Bang operator (`!`) abuse**: Avoid the null-assertion operator `!` on nullable fields. Promote local variables via `if (value != null)` or pattern matching `if (state.user case final user?)` so the compiler guarantees non-nullability.
- **Catching errors without stack traces**: Always write `catch (error, stackTrace)` and pass `stackTrace` to loggers or `Error.throwWithStackTrace(newError, stackTrace)` so the original crash origin is never lost.

## Related Skills
- Use **flutter-architecture-data** when Dart idioms shape the feature-first MVVM structure; sealed states, records, and `Result<T>` types are defined here.
- Use **flutter-testing-verification** when Dart idioms need deterministic unit or widget test coverage.
- Use **code-review** when a Dart or Flutter diff needs the merge quality gate.
