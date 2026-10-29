# Architecture Patterns and Code Templates

## 1. Sealed `Result<T>` and `Failure` Pattern (Dart 3)

Use a `sealed class Result<T>` so the compiler forces callers to handle both success and failure branches exhaustively.

```dart
sealed class AppFailure {
  const AppFailure(this.message, {this.cause});
  final String message;
  final Object? cause;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Unable to connect to the server.']);
}

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([super.message = 'Session expired. Please sign in again.']);
}

final class ServerFailure extends AppFailure {
  const ServerFailure(super.message, {this.statusCode, super.cause});
  final int? statusCode;
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, {this.fieldErrors = const {}});
  final Map<String, String> fieldErrors;
}

sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;
  const factory Result.error(AppFailure failure) = Error<T>;

  bool get isOk => this is Ok<T>;
  bool get isError => this is Error<T>;
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);
  final AppFailure failure;
}
```

## 2. Official Flutter `Command` Pattern for ViewModels

Wrap async actions in a `Command` object so the UI can bind directly to `running`, `error`, and `completed` states while preventing duplicate concurrent taps.

```dart
import 'package:flutter/foundation.dart';

abstract class Command<T> extends ChangeNotifier {
  bool _running = false;
  bool get running => _running;

  Result<T>? _result;
  Result<T>? get result => _result;

  bool get hasError => _result is Error<T>;
  bool get completed => _result is Ok<T>;

  void clearResult() {
    _result = null;
    notifyListeners();
  }

  Future<void> _execute(Future<Result<T>> Function() action) async {
    if (_running) return;
    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

final class Command0<T> extends Command<T> {
  Command0(this._action);
  final Future<Result<T>> Function() _action;

  Future<void> execute() => _execute(_action);
}

final class Command1<T, A> extends Command<T> {
  Command1(this._action);
  final Future<Result<T>> Function(A argument) _action;

  Future<void> execute(A argument) => _execute(() => _action(argument));
}
```

## 3. Repository and Service Separation Example

```dart
import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;

// Immutable Domain Model
final class Article {
  const Article({
    required this.id,
    required this.title,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final DateTime publishedAt;

  factory Article.fromJson(Map<String, Object?> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      publishedAt: DateTime.parse(json['published_at'] as String).toUtc(),
    );
  }
}

// Service: Low-level stateless API wrapper
final class ArticleApiService {
  const ArticleApiService(this._client);
  final http.Client _client;

  Future<String> fetchArticlesRaw() async {
    final uri = Uri.https('api.example.com', '/v1/articles');
    final response = await _client.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    return response.body;
  }
}

// Abstract Repository Interface (for easy Fake testing)
abstract interface class ArticleRepository {
  Future<Result<List<Article>>> getArticles();
}

// Concrete Repository Implementation
final class RemoteArticleRepository implements ArticleRepository {
  const RemoteArticleRepository(this._apiService);
  final ArticleApiService _apiService;

  @override
  Future<Result<List<Article>>> getArticles() async {
    try {
      final rawJson = await _apiService.fetchArticlesRaw();
      // Parse in background isolate if payload can be large
      final articles = await Isolate.run(() {
        final decoded = jsonDecode(rawJson) as List<Object?>;
        return decoded
            .cast<Map<String, Object?>>()
            .map(Article.fromJson)
            .toList(growable: false);
      });
      return Result.ok(articles);
    } catch (e) {
      return Result.error(NetworkFailure('Failed to load articles: $e'));
    }
  }
}
```
