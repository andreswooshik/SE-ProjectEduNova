# Developer Guide for EduNova

A comprehensive guide for developers working on the EduNova mobile application.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [State Management](#state-management)
- [Code Organization](#code-organization)
- [Development Workflow](#development-workflow)
- [Common Tasks](#common-tasks)
- [Debugging Tips](#debugging-tips)
- [Performance Optimization](#performance-optimization)

## Project Overview

EduNova is a Flutter-based mobile application designed to provide accessible learning resources for students and teachers. The app supports:

- **Students**: Browse courses, access modules, view resources
- **Teachers**: Create courses, manage modules, upload resources
- **Admins**: System administration (future feature)

### Technology Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **State Management**: Riverpod 3.x
- **Local Storage**: SharedPreferences
- **Authentication**: Custom implementation with bcrypt
- **File Handling**: file_picker, path_provider

## Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│   (Screens, Widgets, Providers)         │
├─────────────────────────────────────────┤
│          Business Logic Layer           │
│    (Services, Repositories)             │
├─────────────────────────────────────────┤
│            Data Layer                   │
│  (Models, Storage Services)             │
└─────────────────────────────────────────┘
```

### SOLID Principles

All code follows SOLID principles:

1. **Single Responsibility**: Each class has one clear purpose
2. **Open/Closed**: Open for extension, closed for modification
3. **Liskov Substitution**: Subtypes can replace base types
4. **Interface Segregation**: Specific, focused interfaces
5. **Dependency Inversion**: Depend on abstractions

### Layer Responsibilities

#### Presentation Layer (`lib/screens`, `lib/widgets`, `lib/providers`)
- UI components and screens
- State management with Riverpod
- User interaction handling
- Navigation logic

#### Business Logic Layer (`lib/services`, `lib/repositories`)
- Business rules and logic
- Data access and manipulation
- Authorization and validation
- File operations

#### Data Layer (`lib/models`, `lib/services/*_storage_service.dart`)
- Data models and entities
- Storage operations
- Serialization/deserialization

## State Management

### Riverpod 3.x

The app uses Riverpod for state management with the new Notifier pattern.

#### Provider Types

1. **Provider**: For dependencies and computed values
   ```dart
   final userStorageProvider = Provider<IUserStorageService>((ref) {
     return UserStorageService(ref.watch(storageServiceProvider));
   });
   ```

2. **NotifierProvider**: For mutable state
   ```dart
   final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
     return AuthNotifier();
   });
   ```

3. **FamilyProvider**: For parameterized providers
   ```dart
   final moduleByIdProvider = Provider.family<Module?, String>((ref, id) {
     // Return module by ID
   });
   ```

#### Using Providers in Widgets

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for changes
    final authState = ref.watch(authProvider);
    
    // Read once (e.g., in callbacks)
    final notifier = ref.read(authProvider.notifier);
    
    return ElevatedButton(
      onPressed: () => notifier.signOut(),
      child: Text('Sign Out'),
    );
  }
}
```

## Code Organization

### Directory Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart       # App-wide constants
│   │   └── ui_constants.dart        # UI-related constants
│   ├── utils/
│   │   └── error_handler.dart       # Error handling utility
│   └── validators/
│       └── form_validators.dart     # Form validation logic
│
├── models/
│   ├── user.dart                    # User models (Student, Teacher, Admin)
│   ├── course.dart                  # Course model
│   ├── module.dart                  # Module model
│   └── university.dart              # University model
│
├── services/
│   ├── interfaces/                  # Service interfaces
│   │   ├── i_auth_repository.dart
│   │   ├── i_storage_service.dart
│   │   └── ...
│   ├── auth_service.dart            # Authentication logic
│   ├── file_storage_service.dart    # File operations
│   ├── module_storage_service.dart  # Module storage
│   └── ...
│
├── repositories/
│   ├── interfaces/                  # Repository interfaces
│   ├── auth_repository.dart         # Auth data access
│   ├── course_repository.dart       # Course data access
│   └── module_repository.dart       # Module data access
│
├── providers/
│   ├── auth_provider.dart           # Authentication state
│   ├── courses_provider.dart        # Courses state
│   ├── module_provider.dart         # Modules state
│   └── app_providers.dart           # Centralized providers
│
├── screens/
│   ├── welcome_page.dart            # Splash screen
│   ├── onboarding_page.dart         # Onboarding flow
│   ├── sign_in_page.dart            # Sign in screen
│   ├── sign_up_page.dart            # Sign up screen
│   ├── student_dashboard_page.dart  # Student home
│   ├── teacher_dashboard_page.dart  # Teacher home
│   └── ...
│
├── widgets/
│   ├── custom_text_field.dart       # Reusable text field
│   ├── custom_search_bar.dart       # Reusable search bar
│   └── ...
│
└── main.dart                        # App entry point
```

### File Naming Conventions

- Use `snake_case` for file names
- Suffix with purpose: `_page.dart`, `_widget.dart`, `_provider.dart`, `_service.dart`
- Use `i_` prefix for interfaces: `i_auth_repository.dart`

## Development Workflow

### Setting Up Your Environment

1. **Install Flutter SDK**
   ```bash
   # Verify installation
   flutter doctor
   ```

2. **Clone Repository**
   ```bash
   git clone https://github.com/andreswooshik/SE-ProjectEduNova.git
   cd SE-ProjectEduNova
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

### Development Cycle

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature
   ```

2. **Make Changes** following the architecture

3. **Format Code**
   ```bash
   dart format .
   ```

4. **Run Analysis**
   ```bash
   flutter analyze
   ```

5. **Test Changes**
   ```bash
   flutter test
   ```

6. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: your feature description"
   git push origin feature/your-feature
   ```

## Common Tasks

### Adding a New Screen

1. Create screen file in `lib/screens/`
2. Extend `ConsumerWidget` or `ConsumerStatefulWidget`
3. Add navigation route
4. Update relevant providers if needed

**Example:**
```dart
class NewScreen extends ConsumerWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: const Center(child: Text('Content')),
    );
  }
}
```

### Adding a New Model

1. Create model file in `lib/models/`
2. Define class with immutable properties
3. Add `toJson()` and `fromJson()` methods
4. Add `copyWith()` method
5. Override `==` and `hashCode` if needed

**Example:**
```dart
class MyModel {
  final String id;
  final String name;

  const MyModel({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(id: json['id'], name: json['name']);
  }

  MyModel copyWith({String? id, String? name}) {
    return MyModel(id: id ?? this.id, name: name ?? this.name);
  }
}
```

### Adding a New Service

1. Create interface in `lib/services/interfaces/`
2. Create implementation in `lib/services/`
3. Add provider in `lib/providers/app_providers.dart`
4. Use dependency injection via Riverpod

**Example:**
```dart
// Interface
abstract class IMyService {
  Future<void> doSomething();
}

// Implementation
class MyService implements IMyService {
  @override
  Future<void> doSomething() async {
    // Implementation
  }
}

// Provider
final myServiceProvider = Provider<IMyService>((ref) {
  return MyService();
});
```

### Adding Form Validation

1. Add validator to `lib/core/validators/form_validators.dart`
2. Use in form fields

**Example:**
```dart
// In FormValidators
static String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter username';
  }
  if (value.length < 3) {
    return 'Username must be at least 3 characters';
  }
  return null;
}

// In widget
TextFormField(
  validator: FormValidators.validateUsername,
  // ...
)
```

## Debugging Tips

### Using Flutter DevTools

```bash
flutter run
# Press 'v' to open DevTools in browser
```

### Logging

Use the `ErrorHandler` utility for logging:

```dart
import 'package:edunova_app/core/utils/error_handler.dart';

// Log info
ErrorHandler.logInfo('User signed in', context: 'AuthService');

// Log warning
ErrorHandler.logWarning('Invalid file type', context: 'FileUpload');

// Log error
ErrorHandler.logError('Failed to save', error, context: 'Repository');
```

### Common Issues

**Issue**: Provider not updating
**Solution**: Ensure you're using `ref.watch()` not `ref.read()` in build method

**Issue**: State not persisting
**Solution**: Check SharedPreferences keys and serialization

**Issue**: File upload failing
**Solution**: Check file size limits and permissions

## Performance Optimization

### Best Practices

1. **Use const constructors**
   ```dart
   const Text('Hello') // Not Text('Hello')
   ```

2. **Avoid rebuilds**
   ```dart
   // Use select to watch specific fields
   final userName = ref.watch(authProvider.select((s) => s.user?.fullName));
   ```

3. **Lazy load data**
   ```dart
   // Load data only when needed
   ref.read(moduleProvider.notifier).loadModulesForCourse(courseId);
   ```

4. **Use ListView.builder**
   ```dart
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
   )
   ```

5. **Cache images**
   ```dart
   Image.asset('path', cacheWidth: 100, cacheHeight: 100)
   ```

### Memory Management

- Dispose controllers in `dispose()` method
- Clear lists and maps when not needed
- Use weak references for large objects
- Implement pagination for large datasets

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Testing Guide](TESTING_GUIDE.md)
- [Security Best Practices](SECURITY.md)

---

Happy coding! 🚀
