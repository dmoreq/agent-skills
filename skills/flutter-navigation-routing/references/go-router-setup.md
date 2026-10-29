# GoRouter Production Setup with Auth Guard and StatefulShellRoute

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class Routes {
  static const home = '/home';
  static const search = '/search';
  static const profile = '/profile';
  static const login = '/login';
  static String itemDetails(String id) => '/home/items/$id';
}

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createAppRouter({required ValueListenable<bool> isAuthenticated}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.home,
    refreshListenable: isAuthenticated,
    redirect: (context, state) {
      final loggedIn = isAuthenticated.value;
      final isOnLogin = state.matchedLocation == Routes.login;

      if (!loggedIn && !isOnLogin) {
        final from = Uri.encodeComponent(state.uri.toString());
        return '${Routes.login}?from=$from';
      }
      if (loggedIn && isOnLogin) {
        final from = state.uri.queryParameters['from'];
        return (from != null && from.isNotEmpty)
            ? Uri.decodeComponent(from)
            : Routes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const Placeholder(), // LoginScreen()
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const Placeholder(), // HomeScreen()
                routes: [
                  GoRoute(
                    path: 'items/:id',
                    parentNavigatorKey: rootNavigatorKey, // Covers bottom bar
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return Placeholder(key: ValueKey(id)); // ItemDetailScreen(id: id)
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.search,
                builder: (context, state) => const Placeholder(), // SearchScreen()
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) => const Placeholder(), // ProfileScreen()
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Predictive Back + Unsaved Changes Confirmation with PopScope
class UnsavedFormGuard extends StatelessWidget {
  const UnsavedFormGuard({
    required this.hasUnsavedChanges,
    required this.child,
    super.key,
  });

  final bool hasUnsavedChanges;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldDiscard = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text('You have unsaved changes that will be lost.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Keep editing'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Discard'),
              ),
            ],
          ),
        );
        if ((shouldDiscard ?? false) && context.mounted) {
          Navigator.of(context).pop(result);
        }
      },
      child: child,
    );
  }
}
```
