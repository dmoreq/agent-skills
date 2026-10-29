---
name: flutter-architecture-data
description: Architect scalable Flutter applications using feature-first organization, MVVM separation (UI and Data layers), Repository and Service patterns, Command and Result types, Dependency Injection, immutable data models, networking, and local persistence. Use when scaffolding a new Flutter project, designing folder structures, creating repositories or API services, modeling domain/data entities, or refactoring legacy spaghetti widgets into clean layered architecture.
risk: safe
source: local
date_added: "2026-10-29"
---
# Flutter Architecture and Data Layer

## Summary

Architect Flutter applications following the official Flutter Architecture Guide and production community standards. Separate code into a UI layer (Views + ViewModels/Notifiers) and a Data layer (Repositories + Services) using unidirectional data flow, immutable models, and typed error handling.

## When to Use

- Scaffolding a new Flutter application or adding a new feature module
- Refactoring business logic out of widgets into ViewModels/Notifiers and Repositories
- Designing REST/GraphQL networking clients, local database DAOs (Drift/SQLite), or caching flows
- Implementing typed error handling (`Result<T>`) and UI interaction `Command` wrappers
- Setting up Dependency Injection (Riverpod providers, Provider, or GetIt)

## Steps

### 1. Organize by Feature-First Structure

Structure the project under `lib/` by feature for domain cohesion, keeping shared infrastructure in `core/` or `shared/`. Do not split the entire project top-level by technical layer alone unless the app is tiny.

```text
lib/
├── core/
│   ├── error/          # Result<T>, Failure sealed hierarchy
│   ├── network/        # HTTP client, interceptors, endpoints
│   ├── storage/        # Database setup, secure storage, shared prefs
│   ├── theme/          # AppTheme, ThemeExtensions, tokens
│   └── widgets/        # Design system reusable dumb widgets
├── features/
│   └── <feature_name>/
│       ├── data/
│       │   ├── models/         # DTOs / API serialization models
│       │   ├── services/       # Raw API / DB / platform clients
│       │   └── repositories/   # Concrete Repository implementations
│       ├── domain/             # Optional: pure models & interfaces (or keep in data/ui if simple)
│       └── ui/
│           ├── view_models/    # Notifier / Cubit / ChangeNotifier
│           ├── views/          # Screen-level widgets
│           └── widgets/        # Feature-scoped sub-widgets
├── routing/
│   └── app_router.dart
└── main.dart
```

### 2. Enforce Strict Layer Boundaries and Naming

Name every class with a role suffix so its architectural layer is immediately obvious:

- `HomeScreen` or `HomePage`: Top-level route widget in the UI layer.
- `HomeViewModel` / `HomeNotifier` / `HomeCubit`: Holds UI state and exposes intent methods.
- `UserRepository` (interface) / `RemoteUserRepository` (implementation): Single source of truth for a data domain.
- `AuthApiService` / `LocalDatabaseService`: Wraps external stateless APIs, SDKs, or `MethodChannel` calls.

Follow the downward dependency rule:

- UI layer depends only on ViewModels and Domain/Data models (via Repositories injected into ViewModels).
- ViewModels depend on Repositories (and optional UseCases if logic spans multiple repositories).
- Repositories depend on one or more Services and map raw DTOs into clean application models.
- Services never import UI or ViewModels, and Views never call Services directly.

### 3. Keep Views Dumb and Unidirectional

Restrict widgets (`StatelessWidget` / `ConsumerWidget`) to rendering state and forwarding user gestures to the ViewModel:

- Never perform HTTP calls, SQL queries, JSON parsing, or complex business validation inside a Widget.
- Allow only display logic in Views: conditional visibility flags, layout branching by constraints, simple routing triggers, and animation controllers.
- Flow data strictly in one direction: Data Layer -> ViewModel (immutable state) -> View (renders UI) -> User Event (calls ViewModel command) -> Data Layer.

### 4. Return Typed Results Instead of Throwing Across Boundaries

Prevent uncaught exceptions in UI code by catching low-level exceptions inside Services/Repositories and returning a `sealed class Result<T>`:

- Catch `SocketException`, `TimeoutException`, `DioException`, and `FormatException` at the Repository boundary.
- Map exceptions to a domain-meaningful `Failure` subtype (e.g., `NetworkFailure`, `UnauthorizedFailure`, `ValidationFailure`).
- Use Dart 3 exhaustive `switch` expressions in the ViewModel to transition state cleanly into loading, data, or error states.
- See `references/patterns-and-templates.md` for copy-ready `Result<T>` and `Command` implementations.

### 5. Build Immutable Models and Isolate DTOs

Guarantee state predictability by making all data models immutable:

- Declare all fields `final` and provide a `const` constructor.
- Use `freezed` + `json_serializable` for complex models requiring `copyWith`, deep equality, union states, and JSON serialization.
- For simple models without codegen overhead, write manual `fromJson`, `toJson`, `copyWith`, and override `operator ==` and `hashCode` (or use `equatable`).
- Keep raw API DTOs separate from domain models when backend payloads are deeply nested, unstable, or contain nullable fields that your UI guarantees are non-null after sanitization.
- Parse large JSON payloads (>100KB) off the main isolate using `Isolate.run(() => parseItems(rawBody))` to prevent frame drops.

### 6. Verify Architecture Compliance

Run static checks after scaffolding or refactoring:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
```

Verify that no file in `ui/` imports `package:dio`, `package:http`, `package:drift`, or `services/` directly.

## Gotchas

- **Over-engineering with Domain UseCases**: Do not create 1-line pass-through UseCase classes that simply forward a call to a single Repository method. Introduce a Domain UseCase only when business logic coordinates multiple Repositories or is reused across multiple ViewModels.
- **Mutating lists in place**: Calling `state.items.add(newItem)` mutates the existing list reference and prevents `Selector`, `Riverpod`, or `ValueNotifier` from detecting state changes. Always emit a new list: `[...state.items, newItem]`.
- **Leaking `BuildContext` into ViewModels**: Never pass `BuildContext` into a ViewModel, Notifier, or Repository. Emit state changes or one-off UI events and let the Widget layer show `SnackBar`, `Dialog`, or navigate using its own mounted `context`.

## Related Skills
- Use **dart-modern-idioms** when writing the Dart 3.x constructs (sealed classes, records, pattern matching) that implement the layers.
- Use **flutter-state-management** when wiring ViewModel/Notifier state into the UI layer.
- Use **flutter-testing-verification** when testing repositories, services, or ViewModels.
- Use **flutter-codegen-release** when models need `build_runner` code generation or the app needs release packaging.
