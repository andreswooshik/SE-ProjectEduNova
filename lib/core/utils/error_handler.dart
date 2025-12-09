import 'package:flutter/foundation.dart';

/// Centralized error handling utility
/// Single Responsibility Principle: Handles only error logging and reporting
class ErrorHandler {
  // Private constructor to prevent instantiation
  ErrorHandler._();

  /// Log an error with context
  static void logError(
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

  /// Log a warning
  static void logWarning(String message, {String? context}) {
    final contextInfo = context != null ? '[$context] ' : '';
    debugPrint('${contextInfo}WARNING: $message');
  }

  /// Log an info message
  static void logInfo(String message, {String? context}) {
    final contextInfo = context != null ? '[$context] ' : '';
    debugPrint('${contextInfo}INFO: $message');
  }

  /// Get user-friendly error message from exception
  static String getUserFriendlyMessage(dynamic error) {
    if (error == null) {
      return 'An unknown error occurred';
    }

    final errorString = error.toString();

    // Network errors
    if (errorString.contains('SocketException') ||
        errorString.contains('Failed host lookup')) {
      return 'Network error. Please check your internet connection.';
    }

    // Timeout errors
    if (errorString.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }

    // File system errors
    if (errorString.contains('FileSystemException')) {
      return 'File operation failed. Please check permissions.';
    }

    // Format exceptions
    if (errorString.contains('FormatException')) {
      return 'Invalid data format received.';
    }

    // Authentication errors
    if (errorString.contains('Invalid email or password') ||
        errorString.contains('User not found')) {
      return 'Invalid email or password. Please try again.';
    }

    // Authorization errors
    if (errorString.contains('Unauthorized') ||
        errorString.contains('Access denied')) {
      return 'You do not have permission to perform this action.';
    }

    // File size errors
    if (errorString.contains('File size exceeds')) {
      return errorString;
    }

    // Default to generic message
    return 'An error occurred. Please try again.';
  }

  /// Handle and log an exception, returning a user-friendly message
  static String handleException(
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
