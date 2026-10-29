---
name: flutter-navigation-routing
description: Configure declarative navigation, deep linking, authentication redirect guards, nested shell routes, and predictive back gestures in Flutter using go_router and MaterialApp.router. Use when setting up routing, adding new screens or tabs, handling URL parameters, protecting authenticated routes, or configuring Android App Links and iOS Universal Links.
risk: safe
source: local
date_added: "2026-10-29"
---
# Flutter Declarative Navigation and Routing

## Summary

Implement URL-driven, deep-link-safe navigation in Flutter using `go_router` and `MaterialApp.router`. Keep route definitions centralized, pass scalar identifiers via path/query parameters rather than in-memory objects, and handle authentication redirects reactively.

## When to Use

- Configuring `go_router` and `MaterialApp.router` in a new or existing Flutter project
- Adding routes, nested tab bars (`StatefulShellRoute.indexedStack`), or modal dialogs
- Implementing login/onboarding guards via `redirect` and `refreshListenable`
- Setting up Android App Links (`assetlinks.json`), iOS Universal Links (`apple-app-site-association`), or Web URL strategies
- Migrating legacy `Navigator.push` or `WillPopScope` calls to `GoRouter` and `PopScope`

## Steps

### 1. Centralize `GoRouter` Configuration

Define a single `GoRouter` instance in `lib/routing/app_router.dart` (or provided via a Riverpod/DI provider) and wire it into `MaterialApp.router(routerConfig: appRouter)`:

- Define route paths and names as constants in an abstract `Routes` class (`static const productDetails = '/products/:id';`).
- Prefer `context.go('/path')` when navigating to a canonical URL hierarchy (replaces or updates the route stack to match the URL) and `context.push('/path')` when opening a transient modal or detail screen that should pop back to the exact caller regardless of URL hierarchy.
- Provide an `errorBuilder` on `GoRouter` to render a user-friendly 404 Not Found screen with a "Go Home" button.

### 2. Pass IDs via Path/Query Parameters (Never `state.extra` for Deep-Linkable Routes)

Design every screen so it can be cold-started from a deep link or browser refresh:

- Pass entity identifiers in path parameters (`/orders/:orderId`) or filter criteria in query parameters (`/orders?status=pending`).
- Have the target screen's ViewModel/Notifier fetch or look up the entity by ID from the Repository/cache.
- Avoid relying on `state.extra` for required screen data because `extra` is lost on browser page reload, deep linking, and OS process death restoration.

### 3. Implement Reactive Auth and Onboarding Guards

Protect private routes using top-level `redirect` combined with `refreshListenable` (or a Riverpod reactive router listener):

- Never put imperative navigation calls (`context.go('/login')`) inside an Auth Repository or Notifier.
- Let the router observe auth state changes and return `/login?from=${Uri.encodeComponent(state.matchedLocation)}` when unauthenticated, or redirect away from `/login` once authenticated.
- See `references/go-router-setup.md` for a complete auth-guarded `GoRouter` + `StatefulShellRoute.indexedStack` setup.

### 4. Use `StatefulShellRoute.indexedStack` for Persistent Bottom/Rail Tabs

When building an app with bottom navigation (`NavigationBar`) or side rail (`NavigationRail`) where each tab preserves its own scroll position and navigation stack:

- Use `StatefulShellRoute.indexedStack` with one `StatefulShellBranch` per tab.
- Provide a unique `GlobalKey<NavigatorState>` for the root navigator and each branch navigator when modals need to cover the entire screen (`parentNavigatorKey: rootNavigatorKey`) vs staying inside a tab.

### 5. Replace Deprecated `WillPopScope` with `PopScope`

Handle unsaved-changes confirmation and Android 14+ predictive back gestures using `PopScope`:

- Set `canPop: !hasUnsavedChanges` dynamically so predictive back animations work smoothly when there are no unsaved changes.
- Handle intercepted back gestures in `onPopInvokedWithResult: (didPop, result) async { if (didPop) return; ... }`.

### 6. Verify Routing Configuration

```bash
flutter analyze
flutter test
```

## Gotchas

- **Recreating `GoRouter` on every widget rebuild**: Never instantiate `GoRouter(...)` directly inside a widget's `build()` method, or the navigation stack will reset to `initialLocation` on every rebuild. Cache it in a `final` field, `State` variable, or single-instance provider with `refreshListenable`.
- **Infinite redirect loops**: Always check `final isLoggingIn = state.matchedLocation == Routes.login;` inside `redirect` before returning `Routes.login`; returning the same path you are already on triggers a redirect loop error.

## Related Skills
- Use **flutter-ui-responsive-a11y** when composing the screens that navigation targets.
- Use **flutter-state-management** when auth guards read or dispatch authentication state.
- Use **flutter-architecture-data** when route handlers call repositories or services.
