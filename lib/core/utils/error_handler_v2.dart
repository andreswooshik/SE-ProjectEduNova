import 'package:flutter/foundation.dart';

/// Interface for error message providers
/// Interface Segregation Principle: Specific interface for error message formatting
abstract class IErrorMessageProvider {
  /// Get user-friendly error message from exception
  String getUserFriendlyMessage(dynamic error);
}

/// Interface for error logging
/// Interface Segregation Principle: Separate interface for logging operations
abstract class IErrorLogger {
  /// Log an error with context
  void logError(String message, dynamic error, {StackTrace? stackTrace, String? context});
  
  /// Log a warning
  void logWarning(String message, {String? context});
  
  /// Log an info message
  void logInfo(String message, {String? context});
}

/// Default implementation of error message provider
/// Single Responsibility Principle: Only handles error message formatting
/// Open/Closed Principle: Can be extended to support new error types
class DefaultErrorMessageProvider implements IErrorMessageProvider {
  /// Map of error patterns to user-friendly messages
  /// Open/Closed Principle: Add new mappings without modifying existing code
  final Map<Pattern, String> _errorMappings = {
    RegExp(r'SocketException|Failed host lookup'): 
        'Network error. Please check your internet connection.',
    RegExp(r'TimeoutException'): 
        'Request timed out. Please try again.',
    RegExp(r'FileSystemException'): 
        'File operation failed. Please check permissions.',
    RegExp(r'FormatException'): 
        'Invalid data format received.',
    RegExp(r'Invalid email or password|User not found'): 
        'Invalid email or password. Please try again.',
    RegExp(r'Unauthorized|Access denied'): 
        'You do not have permission to perform this action.',
    RegExp(r'File size exceeds'): 
        '', // Will return the actual error message
  };

  @override
  String getUserFriendlyMessage(dynamic error) {
    if (error == null) {
      return 'An unknown error occurred';
    }

    final errorString = error.toString();

    // Check each error pattern
    for (final entry in _errorMappings.entries) {
      if (entry.key is RegExp && (entry.key as RegExp).hasMatch(errorString)) {
        // If message is empty, return the actual error
        return entry.value.isEmpty ? errorString : entry.value;
      }
    }

    // Default to generic message
    return 'An error occurred. Please try again.';
  }
}

/// Debug implementation of error logger
/// Single Responsibility Principle: Only handles logging operations
/// Liskov Substitution Principle: Can be replaced with other implementations
class DebugErrorLogger implements IErrorLogger {
  @override
  void logError(
    String message,
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    final contextInfo = context != null ? '[$context] ' : '';
    debugPrint('${contextInfo}ERROR: $message');
    debugPrint('Details: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  void logWarning(String message, {String? context}) {
    final contextInfo = context != null ? '[$context] ' : '';
    debugPrint('${contextInfo}WARNING: $message');
  }

  @override
  void logInfo(String message, {String? context}) {
    final contextInfo = context != null ? '[$context] ' : '';
    debugPrint('${contextInfo}INFO: $message');
  }
}

/// Composite error handler that combines logging and message formatting
/// Dependency Inversion Principle: Depends on abstractions (interfaces)
/// Single Responsibility Principle: Orchestrates logging and message formatting
class ErrorHandler {
  final IErrorLogger _logger;
  final IErrorMessageProvider _messageProvider;

  /// Constructor with dependency injection
  /// Dependency Inversion Principle: Depends on abstractions
  ErrorHandler({
    IErrorLogger? logger,
    IErrorMessageProvider? messageProvider,
  })  : _logger = logger ?? DebugErrorLogger(),
        _messageProvider = messageProvider ?? DefaultErrorMessageProvider();

  /// Log an error with context
  void logError(
    String message,
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    _logger.logError(message, error, stackTrace: stackTrace, context: context);
  }

  /// Log a warning
  void logWarning(String message, {String? context}) {
    _logger.logWarning(message, context: context);
  }

  /// Log an info message
  void logInfo(String message, {String? context}) {
    _logger.logInfo(message, context: context);
  }

  /// Get user-friendly error message from exception
  String getUserFriendlyMessage(dynamic error) {
    return _messageProvider.getUserFriendlyMessage(error);
  }

  /// Handle and log an exception, returning a user-friendly message
  String handleException(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    logError(
      'Exception occurred',
      error,
      stackTrace: stackTrace,
      context: context,
    );
    return getUserFriendlyMessage(error);
  }
}

/// Singleton instance for convenience
/// Note: For better testability, use dependency injection instead
final errorHandler = ErrorHandler();

/// Backward compatibility with static API
/// Note: This is provided for compatibility but using the instance is preferred
class ErrorHandlerCompat {
  static final _instance = ErrorHandler();

  static void logError(
    String message,
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    _instance.logError(message, error, stackTrace: stackTrace, context: context);
  }

  static void logWarning(String message, {String? context}) {
    _instance.logWarning(message, context: context);
  }

  static void logInfo(String message, {String? context}) {
    _instance.logInfo(message, context: context);
  }

  static String getUserFriendlyMessage(dynamic error) {
    return _instance.getUserFriendlyMessage(error);
  }

  static String handleException(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
  }) {
    return _instance.handleException(error, stackTrace: stackTrace, context: context);
  }
}
