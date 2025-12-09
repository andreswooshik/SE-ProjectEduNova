# EduNova Code Style Guide

This document defines the coding standards and best practices for the EduNova project.

## Table of Contents
- [General Principles](#general-principles)
- [Dart/Flutter Specific](#dartflutter-specific)
- [Naming Conventions](#naming-conventions)
- [Code Organization](#code-organization)
- [Comments and Documentation](#comments-and-documentation)
- [Error Handling](#error-handling)
- [State Management](#state-management)
- [Testing](#testing)

## General Principles

### Follow SOLID Principles

All code should adhere to SOLID principles:

1. **Single Responsibility**: Each class should have one clear purpose
2. **Open/Closed**: Open for extension, closed for modification
3. **Liskov Substitution**: Subtypes must be substitutable for their base types
4. **Interface Segregation**: Create specific, focused interfaces
5. **Dependency Inversion**: Depend on abstractions, not concretions

### Code Quality

- Write self-documenting code with clear variable and function names
- Keep functions small and focused (ideally under 50 lines)
- Avoid deep nesting (max 3-4 levels)
- Follow the DRY principle (Don't Repeat Yourself)
- Use const constructors wherever possible for performance

## Dart/Flutter Specific

### Use Dart Style Guide

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

Key points:
- Use `dart format` before committing
- Run `flutter analyze` to catch issues
- Enable all recommended lints in `analysis_options.yaml`

### Null Safety

Always use null-safe code:

```dart
// Good
String? nullableString;
final String nonNullString = 'value';

// Use null-aware operators
final length = nullableString?.length ?? 0;

// Avoid
String badString; // Warning: non-nullable without initialization
```

### Const Constructors

Use `const` constructors for better performance:

```dart
// Good
const Text('Hello')
const SizedBox(height: 16)
const EdgeInsets.all(8)

// Avoid
Text('Hello')
SizedBox(height: 16)
EdgeInsets.all(8)
```

### Async/Await

Prefer async/await over raw Futures:

```dart
// Good
Future<User?> getUser() async {
  try {
    final data = await fetchUserData();
    return User.fromJson(data);
  } catch (e) {
    ErrorHandler.logError('Failed to get user', e);
    return null;
  }
}

// Avoid
Future<User?> getUser() {
  return fetchUserData().then((data) {
    return User.fromJson(data);
  }).catchError((e) {
    print('Error: $e');
    return null;
  });
}
```

## Naming Conventions

### Files and Directories

```dart
// Use snake_case for file names
auth_service.dart
user_repository.dart
sign_in_page.dart

// Prefix interfaces with 'i_'
i_auth_service.dart
i_user_repository.dart
```

### Classes

```dart
// Use PascalCase for class names
class UserRepository { }
class AuthService { }
class SignInPage extends StatelessWidget { }

// Use 'I' prefix for interfaces (optional but recommended for clarity)
abstract class IAuthService { }
```

### Variables and Functions

```dart
// Use camelCase for variables and functions
final String userName = 'John';
int calculateTotal() { }

// Use descriptive names
// Good
final List<Course> publishedCourses = [];
Future<void> loadUserData() async { }

// Avoid
final List<Course> c = [];
Future<void> load() async { }
```

### Constants

```dart
// Use camelCase for constants (with const keyword)
const double spacingMedium = 16.0;
const int maxFileSize = 52428800;

// For app-wide constants, group in a class
class AppConstants {
  static const String appName = 'EduNova';
  static const int minPasswordLength = 6;
}
```

### Private Members

```dart
// Prefix private members with underscore
class MyClass {
  String publicField;
  String _privateField;
  
  void publicMethod() { }
  void _privateMethod() { }
}
```

### Boolean Variables

```dart
// Use 'is', 'has', 'can', or 'should' prefixes
bool isLoading = false;
bool hasError = false;
bool canEdit = true;
bool shouldRefresh = false;

// Avoid
bool loading = false;
bool error = false;
```

## Code Organization

### Import Order

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:io';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 4. Local imports (relative)
import '../models/user.dart';
import '../services/auth_service.dart';
import 'widgets/custom_button.dart';
```

### Class Member Order

```dart
class MyWidget extends StatefulWidget {
  // 1. Static constants
  static const String title = 'My Widget';
  
  // 2. Final fields
  final String id;
  final VoidCallback? onPressed;
  
  // 3. Constructor
  const MyWidget({
    Key? key,
    required this.id,
    this.onPressed,
  }) : super(key: key);
  
  // 4. Overridden methods
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // 1. Private fields
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  
  // 2. Lifecycle methods
  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 4. Private helper methods
  void _handleSubmit() { }
}
```

## Comments and Documentation

### When to Comment

```dart
// Good: Explain WHY, not WHAT
// Retry connection because the server may be temporarily unavailable
await retryConnection();

// Avoid: Obvious comments
// Increment counter by 1
counter++;
```

### Documentation Comments

Use `///` for public API documentation:

```dart
/// Validates email address format
///
/// Checks if the email matches a standard email pattern.
/// Returns `null` if valid, error message string if invalid.
///
/// Parameters:
/// - [value]: The email address to validate
///
/// Returns: Error message or null
///
/// Example:
/// ```dart
/// final error = FormValidators.validateEmail('test@example.com');
/// if (error != null) {
///   print('Invalid email: $error');
/// }
/// ```
static String? validateEmail(String? value) {
  // Implementation
}
```

### TODOs

```dart
// TODO: Add input validation
// FIXME: Memory leak in dispose method
// HACK: Temporary workaround for API bug
// NOTE: This relies on external service
```

## Error Handling

### Use Try-Catch Appropriately

```dart
// Good: Catch specific errors
try {
  await performOperation();
} on FileSystemException catch (e, stackTrace) {
  ErrorHandler.logError('File operation failed', e, stackTrace: stackTrace);
  return ErrorState('Failed to save file');
} on NetworkException catch (e) {
  ErrorHandler.logError('Network error', e);
  return ErrorState('Network connection failed');
} catch (e, stackTrace) {
  ErrorHandler.logError('Unexpected error', e, stackTrace: stackTrace);
  return ErrorState('An unexpected error occurred');
}

// Avoid: Empty catch blocks
try {
  await performOperation();
} catch (e) {
  // Silent failure - BAD!
}
```

### User-Friendly Error Messages

```dart
// Good: Use ErrorHandler utility
final message = ErrorHandler.getUserFriendlyMessage(error);
showSnackBar(message);

// Avoid: Exposing internal errors
showSnackBar(error.toString()); // May expose stack traces
```

### Logging

```dart
// Use ErrorHandler for logging
ErrorHandler.logInfo('User signed in', context: 'AuthService');
ErrorHandler.logWarning('Invalid file type', context: 'FileUpload');
ErrorHandler.logError('Failed to save', error, context: 'Repository');

// Never use print() in production code
// Avoid
print('Debug message'); // Use debugPrint() or ErrorHandler instead
```

## State Management

### Riverpod Patterns

```dart
// Provider for dependencies
final authServiceProvider = Provider<IAuthService>((ref) {
  return AuthService(ref.watch(storageServiceProvider));
});

// NotifierProvider for state
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

// Family provider for parameterized data
final userByIdProvider = Provider.family<User?, String>((ref, userId) {
  return ref.watch(usersProvider).firstWhere((u) => u.id == userId);
});
```

### Using Providers

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for automatic rebuilds
    final authState = ref.watch(authProvider);
    
    // Read once (in callbacks)
    final notifier = ref.read(authProvider.notifier);
    
    // Listen to specific fields
    final isLoading = ref.watch(authProvider.select((s) => s.isLoading));
    
    return Container();
  }
}
```

## Testing

### Test File Naming

```dart
// Match source file with _test suffix
// Source: lib/services/auth_service.dart
// Test: test/services/auth_service_test.dart
```

### Test Structure

```dart
void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockRepository mockRepo;
    
    setUp(() {
      mockRepo = MockRepository();
      authService = AuthService(mockRepo);
    });
    
    test('should sign in with valid credentials', () async {
      // Arrange
      when(mockRepo.findUser(any)).thenReturn(testUser);
      
      // Act
      final result = await authService.signIn('email', 'password');
      
      // Assert
      expect(result, isNotNull);
      expect(result?.email, equals('email'));
    });
    
    test('should return null for invalid credentials', () async {
      // Arrange
      when(mockRepo.findUser(any)).thenReturn(null);
      
      // Act
      final result = await authService.signIn('wrong', 'wrong');
      
      // Assert
      expect(result, isNull);
    });
  });
}
```

### Test Coverage

- Aim for at least 70% code coverage
- Test all public APIs
- Test error cases and edge cases
- Test state management logic

## Performance Best Practices

### Widget Building

```dart
// Good: Extract widgets
class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(); // Complex build logic
  }
}

// Use in parent
const ExpensiveWidget() // Const prevents unnecessary rebuilds

// Avoid: Building inline
build(context) {
  return Column(
    children: [
      Container(), // Complex build logic duplicated
    ],
  );
}
```

### List Building

```dart
// Good: Use builders for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// Avoid: Building all items at once
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

## Pre-Commit Checklist

Before committing code:

- [ ] Run `dart format .`
- [ ] Run `flutter analyze` (no errors)
- [ ] Run tests (`flutter test`)
- [ ] Remove debug `print()` statements
- [ ] Add/update documentation comments
- [ ] Check for TODO/FIXME comments
- [ ] Ensure proper error handling
- [ ] Verify const constructors used where possible

---

**Remember**: Consistent code style makes collaboration easier and reduces bugs!
