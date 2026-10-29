---
name: flutter-state-management
description: Implement predictable, leak-free state management in Flutter using Riverpod 3.x (Notifier, AsyncNotifier), Bloc/Cubit, or native Flutter SDK listenables (ChangeNotifier, ValueNotifier, ListenableBuilder). Use when designing feature state, wiring providers, optimizing widget rebuilds, handling async loading/error/data states, or migrating legacy state patterns.
risk: safe
source: local
date_added: "2026-10-29"
---
# Flutter State Management Best Practices

## Summary

Design clean, predictable state management across Ephemeral UI state and shared Application state. Support the project's chosen stack (Riverpod 3.x, Bloc/Cubit, or native `ChangeNotifier` / `ValueNotifier`) without mixing paradigms inside the same feature.

## When to Use

- Choosing between ephemeral widget state (`StatefulWidget` / `ValueNotifier`) and app/feature state
- Creating or refactoring Riverpod `Notifier` / `AsyncNotifier` providers and `ConsumerWidget` views
- Building `Cubit` or `Bloc` state machines with `sealed` states and `BlocConsumer` / `BlocSelector`
- Implementing official Flutter MVVM `ChangeNotifier` ViewModels with `ListenableBuilder`
- Debugging unnecessary widget rebuilds, stale state, or provider disposal bugs

## Steps

### 1. Match the Project Stack and Separate Ephemeral vs App State

Inspect `pubspec.yaml` first and follow the state management library already adopted in the repository:

- **Ephemeral UI state** (current tab index, text field focus, local expansion toggle, animation progress): Keep inside a local `StatefulWidget` or `ValueNotifier` with `ValueListenableBuilder`. Never hoist purely local UI flags into global providers.
- **Feature / App state** (authenticated user, server-fetched domain data, multi-screen form flows, shopping cart): Manage inside a dedicated ViewModel (`Notifier`, `AsyncNotifier`, `Cubit`, `Bloc`, or `ChangeNotifier`) backed by an immutable state class.

### 2. Riverpod 3.x Rules (`flutter_riverpod` / `riverpod_annotation`)

When the project uses Riverpod:

- **Use `Notifier` and `AsyncNotifier`**: Never use legacy `StateNotifierProvider`, `StateProvider`, or `ChangeNotifierProvider` in new code.
- **Strict `watch` / `read` / `listen` split**:
  - `ref.watch(provider)`: Use inside `build()` and provider bodies to reactively rebuild when state changes.
  - `ref.read(provider.notifier)`: Use inside gesture callbacks (`onPressed`, `onSubmitted`) to invoke intent methods. Never call `ref.read` directly inside `build()`.
  - `ref.listen(provider, (prev, next) { ... })`: Use to trigger one-off side effects (showing a `SnackBar`, dialog, or navigating on state transition).
- **Narrow rebuilds with `.select()`**: When a widget only cares about one field of a large state object, write `ref.watch(userProvider.select((s) => s.value?.avatarUrl))` so changes to other fields do not rebuild the widget.
- **Lifecycle & Disposal**: Use `autoDispose` by default for screen-scoped providers so memory is freed when the route pops. Register cleanup hooks via `ref.onDispose(() => timer.cancel())`.

### 3. Bloc and Cubit Rules (`flutter_bloc`)

When the project uses Bloc:

- **Prefer `Cubit` for straightforward request/response features**: Use `Cubit<State>` with clear method names (`loadProfile()`, `updateName(String)`). Escalate to full `Bloc<Event, State>` only when you need event transformers (`debounce`, `restartable`, `droppable` via `bloc_concurrency`) or granular event audit logs.
- **Model states correctly**:
  - For mutually exclusive screen modes, use a `sealed class FeatureState` (`Initial`, `Loading`, `Loaded`, `Error`).
  - For screens that retain existing data while refreshing, filter sorting, or submitting forms, use a **single immutable state class** with a `status` enum (`enum FormStatus { initial, submitting, success, failure }`), data fields, and an optional `AppFailure? failure`.
- **Consume selectively in UI**:
  - `BlocBuilder`: Rebuilds UI; use `buildWhen: (prev, curr) => prev.items != curr.items` or `context.select((CartCubit c) => c.state.totalPrice)` to minimize rebuild scope.
  - `BlocListener`: Triggers side effects (`SnackBar`, navigation); use `listenWhen` so it only fires on status transitions (`prev.status != curr.status && curr.status == Status.failure`).

### 4. Native Flutter SDK Rules (`ChangeNotifier` & `ValueNotifier`)

When following the zero-dependency official Flutter MVVM stack:

- Extend `ChangeNotifier` for multi-field ViewModels and expose read-only getters for state fields alongside `Command` objects for user actions.
- Consume ViewModels in the widget tree using `ListenableBuilder` (or `ValueListenableBuilder` for a single `ValueNotifier<T>`), scoping the builder tightly around the leaf widget that actually changes.
- Always dispose owned `ChangeNotifier`, `ValueNotifier`, `TextEditingController`, and `ScrollController` instances in `State.dispose()`.

### 5. Verify State Behavior

Consult `references/state-patterns.md` for canonical implementations across all three stacks. Run analyzer and unit tests on every new Notifier/Cubit/ViewModel:

```bash
flutter analyze
flutter test
```

## Gotchas

- **Triggering side effects inside `build()`**: Never call `Navigator.push`, `ScaffoldMessenger.of(context).showSnackBar`, or ViewModel mutation methods directly inside `build()`. Use `ref.listen`, `BlocListener`, or schedule post-frame only when strictly required.
- **Calling async initialization in constructors**: Avoid starting network requests inside a class constructor where errors cannot be awaited or mocked cleanly. In Riverpod, use `AsyncNotifier.build()`; in Bloc/ChangeNotifier, invoke an explicit initialization method/event when creating the provider.
- **Watching a provider inside an event handler**: Calling `ref.watch` inside an `onPressed` callback throws an assertion error at runtime. Always use `ref.read(myProvider.notifier).doAction()`.

## Related Skills
- Use **flutter-architecture-data** when the state layer depends on Repository or Service contracts.
- Use **flutter-ui-responsive-a11y** when widgets consume state and need responsive, accessible composition.
- Use **flutter-testing-verification** when testing Notifiers, Cubits, or provider wiring.
- Use **flutter-navigation-routing** when state changes trigger navigation redirects or route guards.
