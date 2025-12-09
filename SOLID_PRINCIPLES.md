# SOLID Principles in EduNova

This document explains how SOLID principles are applied throughout the EduNova codebase with specific examples.

## Table of Contents
- [Single Responsibility Principle (SRP)](#single-responsibility-principle-srp)
- [Open/Closed Principle (OCP)](#openclosed-principle-ocp)
- [Liskov Substitution Principle (LSP)](#liskov-substitution-principle-lsp)
- [Interface Segregation Principle (ISP)](#interface-segregation-principle-isp)
- [Dependency Inversion Principle (DIP)](#dependency-inversion-principle-dip)
- [Examples in Codebase](#examples-in-codebase)

## Single Responsibility Principle (SRP)

> A class should have one, and only one, reason to change.

### What It Means
Each class should focus on doing one thing well. If a class has multiple responsibilities, changes to one responsibility can affect the others.

### Examples in EduNova

#### ✅ Good: Separate Services

```dart
// EmailRoleDetectorService - Only detects roles from emails
class EmailRoleDetectorService implements IEmailRoleDetector {
  UserRole detectRole(String email) { /* ... */ }
  bool isTeacherEmail(String email) { /* ... */ }
  bool isStudentEmail(String email) { /* ... */ }
}

// UserStorageService - Only handles user storage
class UserStorageService implements IUserStorageService {
  Future<void> saveUser(User user) { /* ... */ }
  Future<User?> getUser(String id) { /* ... */ }
  Future<void> deleteUser(String id) { /* ... */ }
}
```

#### ❌ Bad: Mixed Responsibilities

```dart
// DON'T DO THIS - Too many responsibilities
class UserService {
  // Storage operations
  Future<void> saveUser(User user) { /* ... */ }
  
  // Role detection
  UserRole detectRole(String email) { /* ... */ }
  
  // Authentication
  Future<bool> authenticate(String email, String password) { /* ... */ }
  
  // Email sending
  Future<void> sendWelcomeEmail(User user) { /* ... */ }
}
```

### Benefits
- Easier to understand and maintain
- Changes are localized
- Easier to test
- Better code organization

## Open/Closed Principle (OCP)

> Software entities should be open for extension but closed for modification.

### What It Means
You should be able to add new functionality without changing existing code. Use abstraction and polymorphism to achieve this.

### Examples in EduNova

#### ✅ Good: Extensible Error Handler

```dart
// Interface allows extension
abstract class IErrorMessageProvider {
  String getUserFriendlyMessage(dynamic error);
}

// Default implementation
class DefaultErrorMessageProvider implements IErrorMessageProvider {
  @override
  String getUserFriendlyMessage(dynamic error) {
    // Default behavior
  }
}

// Can add new implementation without modifying existing code
class CustomErrorMessageProvider implements IErrorMessageProvider {
  @override
  String getUserFriendlyMessage(dynamic error) {
    // Custom behavior
  }
}
```

#### ✅ Good: Extensible Validators

```dart
// Base interface - closed for modification
abstract class IFieldValidator {
  String? validate(String? value);
}

// New validators can be added - open for extension
class EmailValidator implements IFieldValidator { /* ... */ }
class PasswordValidator implements IFieldValidator { /* ... */ }
class CustomValidator implements IFieldValidator { /* ... */ }

// Composite pattern for combining validators
class CompositeValidator implements IFieldValidator {
  final List<IFieldValidator> validators;
  
  CompositeValidator(this.validators);
  
  String? validate(String? value) {
    for (final validator in validators) {
      final error = validator.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}
```

#### ❌ Bad: Hard to Extend

```dart
// DON'T DO THIS - Must modify class to add new error types
class ErrorHandler {
  static String getUserFriendlyMessage(dynamic error) {
    if (error.toString().contains('NetworkException')) {
      return 'Network error';
    } else if (error.toString().contains('FileException')) {
      return 'File error';
    }
    // Need to modify this method to add new error types
    return 'Unknown error';
  }
}
```

### Benefits
- Add features without breaking existing code
- Reduces regression risk
- Promotes code reusability
- Makes system more flexible

## Liskov Substitution Principle (LSP)

> Objects of a superclass should be replaceable with objects of a subclass without breaking the application.

### What It Means
Derived classes must be substitutable for their base classes. If you have a base class reference, you should be able to use any derived class without knowing which specific one it is.

### Examples in EduNova

#### ✅ Good: User Hierarchy

```dart
// Base class
abstract class User {
  final String id;
  final String email;
  final UserRole role;
  
  User({required this.id, required this.email, required this.role});
  
  // All subclasses must implement this
  int get institutionId;
  
  String get fullName;
}

// Student can be used wherever User is expected
class Student extends User {
  final int schoolId;
  
  Student({/* ... */}) : super(/* ... */);
  
  @override
  int get institutionId => schoolId; // Consistent behavior
}

// Teacher can also be used wherever User is expected
class Teacher extends User {
  final int employeeId;
  
  Teacher({/* ... */}) : super(/* ... */);
  
  @override
  int get institutionId => employeeId; // Consistent behavior
}

// Usage - LSP in action
void processUser(User user) {
  // Works with Student, Teacher, or any User subclass
  print('User ID: ${user.institutionId}');
  print('Name: ${user.fullName}');
}
```

#### ✅ Good: Storage Services

```dart
// Interface
abstract class IStorageService {
  Future<void> save(String key, String value);
  Future<String?> get(String key);
}

// Can substitute LocalStorageService with any implementation
class LocalStorageService implements IStorageService {
  @override
  Future<void> save(String key, String value) async { /* ... */ }
  
  @override
  Future<String?> get(String key) async { /* ... */ }
}

// Alternative implementation - can be used anywhere IStorageService is expected
class MemoryStorageService implements IStorageService {
  final Map<String, String> _storage = {};
  
  @override
  Future<void> save(String key, String value) async {
    _storage[key] = value;
  }
  
  @override
  Future<String?> get(String key) async {
    return _storage[key];
  }
}
```

#### ❌ Bad: Violating LSP

```dart
// DON'T DO THIS
class Bird {
  void fly() { /* ... */ }
}

class Penguin extends Bird {
  @override
  void fly() {
    throw Exception('Penguins cannot fly!'); // Violates LSP
  }
}

// Better approach
abstract class Bird { }

abstract class FlyingBird extends Bird {
  void fly();
}

class Sparrow extends FlyingBird {
  @override
  void fly() { /* ... */ }
}

class Penguin extends Bird {
  // No fly method - doesn't violate LSP
}
```

### Benefits
- Improves code reliability
- Enables polymorphism
- Reduces coupling
- Makes testing easier

## Interface Segregation Principle (ISP)

> Clients should not be forced to depend on interfaces they don't use.

### What It Means
Create specific, focused interfaces rather than large, general-purpose ones. Clients should only know about the methods they need.

### Examples in EduNova

#### ✅ Good: Segregated Interfaces

```dart
// Specific interfaces for different needs
abstract class IErrorLogger {
  void logError(String message, dynamic error, {StackTrace? stackTrace, String? context});
  void logWarning(String message, {String? context});
  void logInfo(String message, {String? context});
}

abstract class IErrorMessageProvider {
  String getUserFriendlyMessage(dynamic error);
}

// Clients use only what they need
class LoggingService {
  final IErrorLogger logger;
  
  LoggingService(this.logger);
  
  void log(String message) {
    logger.logInfo(message); // Only uses logging interface
  }
}

class ErrorDisplayWidget {
  final IErrorMessageProvider messageProvider;
  
  ErrorDisplayWidget(this.messageProvider);
  
  String getDisplayMessage(dynamic error) {
    return messageProvider.getUserFriendlyMessage(error); // Only uses message provider
  }
}
```

#### ❌ Bad: Fat Interface

```dart
// DON'T DO THIS - Forcing clients to depend on methods they don't use
abstract class IErrorHandler {
  void logError(String message, dynamic error);
  void logWarning(String message);
  void logInfo(String message);
  String getUserFriendlyMessage(dynamic error);
  void sendErrorReport(dynamic error);
  void displayErrorDialog(dynamic error);
  void saveErrorToFile(dynamic error);
}

// Client must implement all methods even if they only need logging
class SimpleLogger implements IErrorHandler {
  @override
  void logError(String message, dynamic error) { /* ... */ }
  
  @override
  void logWarning(String message) { /* ... */ }
  
  // Forced to implement methods we don't need
  @override
  String getUserFriendlyMessage(dynamic error) => throw UnimplementedError();
  
  @override
  void sendErrorReport(dynamic error) => throw UnimplementedError();
  // ... and so on
}
```

### Benefits
- Smaller, more focused interfaces
- Easier to implement
- Reduces coupling
- Improves maintainability

## Dependency Inversion Principle (DIP)

> Depend on abstractions, not concretions. High-level modules should not depend on low-level modules.

### What It Means
Instead of depending on concrete classes, depend on interfaces or abstract classes. This makes your code more flexible and testable.

### Examples in EduNova

#### ✅ Good: Dependency Injection with Interfaces

```dart
// High-level module depends on abstraction
class AuthRepository {
  final IStorageService _storage;
  final IUserStorageService _userStorage;
  
  // Dependencies injected via constructor
  AuthRepository(this._storage, this._userStorage);
  
  Future<User?> signIn(String email, String password) async {
    // Uses abstractions, not concrete implementations
    final userData = await _storage.get('users');
    // ...
  }
}

// Riverpod provider injects dependencies
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    ref.watch(storageServiceProvider),
    ref.watch(userStorageServiceProvider),
  );
});
```

#### ✅ Good: Testable Code with DIP

```dart
// Easy to test because we can inject mocks
class MockStorageService implements IStorageService {
  @override
  Future<void> save(String key, String value) async {
    // Test implementation
  }
  
  @override
  Future<String?> get(String key) async {
    return 'test_data';
  }
}

// In tests
void main() {
  test('AuthRepository signIn', () async {
    final mockStorage = MockStorageService();
    final mockUserStorage = MockUserStorageService();
    final repo = AuthRepository(mockStorage, mockUserStorage);
    
    final user = await repo.signIn('test@example.com', 'password');
    expect(user, isNotNull);
  });
}
```

#### ❌ Bad: Direct Dependencies

```dart
// DON'T DO THIS - Depends on concrete class
class AuthRepository {
  final LocalStorageService _storage; // Concrete dependency
  
  AuthRepository() {
    _storage = LocalStorageService(); // Creates dependency directly
  }
  
  Future<User?> signIn(String email, String password) async {
    // Tightly coupled to LocalStorageService
    final userData = await _storage.get('users');
    // ...
  }
}

// Hard to test - cannot inject mock
// Cannot swap implementation without modifying code
```

### Benefits
- Easier to test (can inject mocks)
- Flexible - can swap implementations
- Reduces coupling
- Supports multiple implementations

## Examples in Codebase

### Complete Example: Module Management

Here's how all SOLID principles work together in the module management system:

```dart
// 1. INTERFACES (ISP + DIP)
// Specific, focused interfaces
abstract class IModuleStorage {
  Future<List<Module>> getModules(String courseId);
  Future<void> saveModule(Module module);
}

abstract class IFileStorage {
  Future<String> saveFile(File file, String moduleId);
  Future<void> deleteFile(String filePath);
}

// 2. IMPLEMENTATIONS (SRP + OCP)
// Each class has single responsibility
class ModuleStorageService implements IModuleStorage {
  final IStorageService _storage;
  
  ModuleStorageService(this._storage); // DIP - depends on abstraction
  
  @override
  Future<List<Module>> getModules(String courseId) async {
    // Only handles module storage operations
  }
  
  @override
  Future<void> saveModule(Module module) async {
    // Single responsibility: module storage
  }
}

class FileStorageService implements IFileStorage {
  @override
  Future<String> saveFile(File file, String moduleId) async {
    // Only handles file storage operations
  }
  
  @override
  Future<void> deleteFile(String filePath) async {
    // Single responsibility: file storage
  }
}

// 3. BUSINESS LOGIC (SRP + DIP)
// Orchestrates operations, depends on abstractions
class ModuleManagementService {
  final IModuleStorage _moduleStorage;
  final IFileStorage _fileStorage;
  
  // DIP - injected dependencies
  ModuleManagementService(this._moduleStorage, this._fileStorage);
  
  // SRP - manages module operations
  Future<Module> createModuleWithFiles(
    ModuleCreateData data,
    List<File> files,
  ) async {
    // Uses abstractions
    final module = Module(/* ... */);
    await _moduleStorage.saveModule(module);
    
    for (final file in files) {
      await _fileStorage.saveFile(file, module.id);
    }
    
    return module;
  }
}

// 4. STATE MANAGEMENT (LSP + DIP)
class ModuleNotifier extends StateNotifier<ModuleState> {
  final ModuleManagementService _service;
  
  // DIP - depends on service abstraction
  ModuleNotifier(this._service) : super(ModuleState.initial());
  
  Future<void> createModule(ModuleCreateData data) async {
    // LSP - works with any implementation of the service
    state = state.copyWith(isLoading: true);
    
    try {
      final module = await _service.createModule(data);
      state = state.copyWith(
        modules: [...state.modules, module],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

// 5. DEPENDENCY INJECTION (DIP)
// Riverpod providers wire everything together
final moduleStorageProvider = Provider<IModuleStorage>((ref) {
  return ModuleStorageService(ref.watch(storageServiceProvider));
});

final fileStorageProvider = Provider<IFileStorage>((ref) {
  return FileStorageService();
});

final moduleManagementServiceProvider = Provider((ref) {
  return ModuleManagementService(
    ref.watch(moduleStorageProvider),
    ref.watch(fileStorageProvider),
  );
});

final moduleProvider = StateNotifierProvider<ModuleNotifier, ModuleState>((ref) {
  return ModuleNotifier(ref.watch(moduleManagementServiceProvider));
});
```

## SOLID Principles Checklist

When writing new code, ask yourself:

### Single Responsibility
- [ ] Does this class have only one reason to change?
- [ ] Can I describe what this class does in one sentence?
- [ ] Would splitting this class make the code clearer?

### Open/Closed
- [ ] Can I add new features without modifying existing code?
- [ ] Am I using interfaces or abstract classes?
- [ ] Can this be extended through inheritance or composition?

### Liskov Substitution
- [ ] Can I replace a base class with any of its derived classes?
- [ ] Do derived classes maintain the contract of the base class?
- [ ] Am I throwing exceptions in overridden methods?

### Interface Segregation
- [ ] Are my interfaces focused and specific?
- [ ] Do clients need all methods in the interface?
- [ ] Should I split this interface into smaller ones?

### Dependency Inversion
- [ ] Am I depending on abstractions (interfaces) instead of concrete classes?
- [ ] Are dependencies injected rather than created internally?
- [ ] Can I easily swap implementations for testing?

## Benefits of SOLID in EduNova

Following SOLID principles in EduNova provides:

1. **Maintainability**: Easy to understand and modify
2. **Testability**: Can inject mocks and test in isolation
3. **Flexibility**: Easy to add new features
4. **Reliability**: Changes in one area don't break others
5. **Scalability**: Architecture supports growth
6. **Collaboration**: Clear structure helps team development

---

**Remember**: SOLID principles are guidelines, not strict rules. Apply them pragmatically to improve code quality without over-engineering.
