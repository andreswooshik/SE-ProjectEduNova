import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Search query notifier
/// Follows Single Responsibility Principle - only manages search state
class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query.toLowerCase().trim();
  }

  void clearQuery() {
    state = '';
  }
}

/// Search provider
final searchProvider = NotifierProvider<SearchNotifier, String>(
  SearchNotifier.new,
);
