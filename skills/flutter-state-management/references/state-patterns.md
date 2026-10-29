# Canonical Flutter State Management Patterns

## 1. Riverpod 3.x `AsyncNotifier` Pattern

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Immutable model
final class TodoItem {
  const TodoItem({required this.id, required this.title, this.completed = false});
  final String id;
  final String title;
  final bool completed;

  TodoItem copyWith({String? title, bool? completed}) => TodoItem(
        id: id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
      );
}

// Repository Provider (DI)
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  throw UnimplementedError('Override todoRepositoryProvider in ProviderScope');
});

abstract interface class TodoRepository {
  Future<List<TodoItem>> fetchTodos();
  Future<void> toggleTodo(String id, {required bool completed});
}

// Feature AsyncNotifier
final class TodoListNotifier extends AutoDisposeAsyncNotifier<List<TodoItem>> {
  @override
  Future<List<TodoItem>> build() async {
    final repo = ref.watch(todoRepositoryProvider);
    return repo.fetchTodos();
  }

  Future<void> toggle(String id) async {
    final currentList = state.valueOrNull;
    if (currentList == null) return;

    final target = currentList.firstWhere((item) => item.id == id);
    final updatedCompleted = !target.completed;

    // Optimistic update with new immutable list
    state = AsyncData([
      for (final item in currentList)
        if (item.id == id) item.copyWith(completed: updatedCompleted) else item,
    ]);

    state = await AsyncValue.guard(() async {
      await ref.read(todoRepositoryProvider).toggleTodo(id, completed: updatedCompleted);
      return state.requireValue;
    });
  }
}

final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoListNotifier, List<TodoItem>>(
  TodoListNotifier.new,
);

// ConsumerWidget View
class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for errors to show SnackBar without rebuilding
    ref.listen<AsyncValue<List<TodoItem>>>(todoListProvider, (prev, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    final todosAsync = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: switch (todosAsync) {
        AsyncData(:final value) when value.isEmpty =>
          const Center(child: Text('No tasks yet.')),
        AsyncData(:final value) => ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final item = value[index];
              return CheckboxListTile(
                key: ValueKey(item.id),
                title: Text(item.title),
                value: item.completed,
                onChanged: (_) => ref.read(todoListProvider.notifier).toggle(item.id),
              );
            },
          ),
        AsyncError(:final error) => Center(
            child: FilledButton(
              onPressed: () => ref.invalidate(todoListProvider),
              child: Text('Retry ($error)'),
            ),
          ),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}
```

## 2. Flutter Bloc / Cubit Single-State Pattern

```dart
enum CheckoutStatus { initial, submitting, success, failure }

final class CheckoutState {
  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.couponCode = '',
    this.errorMessage,
  });

  final CheckoutStatus status;
  final String couponCode;
  final String? errorMessage;

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? couponCode,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      couponCode: couponCode ?? this.couponCode,
      errorMessage: errorMessage,
    );
  }
}
```

## 3. Native Flutter `ChangeNotifier` + `ListenableBuilder` Pattern

```dart
import 'package:flutter/material.dart';

final class CounterViewModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterSection extends StatelessWidget {
  const CounterSection({required this.viewModel, super.key});
  final CounterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Row(
          children: [
            Text('Count: ${viewModel.count}'),
            const SizedBox(width: 12),
            child!,
          ],
        );
      },
      // Static child built once and reused across notifications
      child: FilledButton(
        onPressed: viewModel.increment,
        child: const Text('Increment'),
      ),
    );
  }
}
```
