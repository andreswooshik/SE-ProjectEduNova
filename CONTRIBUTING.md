# Contributing to EduNova

Thank you for considering contributing to EduNova! This document provides guidelines and best practices for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/SE-ProjectEduNova.git
   cd SE-ProjectEduNova
   ```
3. **Add the upstream repository**:
   ```bash
   git remote add upstream https://github.com/andreswooshik/SE-ProjectEduNova.git
   ```

## Development Setup

### Prerequisites

- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK (comes with Flutter)
- Android Studio or VS Code with Flutter extensions
- Git

### Installation Steps

1. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

2. Verify your installation:
   ```bash
   flutter doctor
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Coding Standards

### SOLID Principles

This project follows SOLID principles. Please maintain these standards:

1. **Single Responsibility Principle**: Each class should have one responsibility
2. **Open/Closed Principle**: Open for extension, closed for modification
3. **Liskov Substitution Principle**: Subtypes must be substitutable for base types
4. **Interface Segregation Principle**: Use specific interfaces
5. **Dependency Inversion Principle**: Depend on abstractions, not concretions

### Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` before committing:
  ```bash
  dart format .
  ```
- Run static analysis:
  ```bash
  flutter analyze
  ```

### Naming Conventions

- **Classes**: Use PascalCase (e.g., `UserRepository`)
- **Variables/Functions**: Use camelCase (e.g., `getUserData`)
- **Constants**: Use camelCase with `const` (e.g., `const maxFileSize`)
- **Private members**: Prefix with underscore (e.g., `_privateMethod`)
- **Files**: Use snake_case (e.g., `user_repository.dart`)

### Project Structure

```
lib/
├── core/
│   ├── constants/     # App-wide constants
│   ├── utils/         # Utility functions
│   └── validators/    # Form validators
├── models/            # Data models
├── services/          # Business logic services
│   └── interfaces/    # Service interfaces
├── repositories/      # Data access layer
│   └── interfaces/    # Repository interfaces
├── providers/         # Riverpod state management
├── screens/           # UI screens
└── widgets/           # Reusable widgets
```

## Commit Guidelines

### Commit Message Format

Use conventional commit messages:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(auth): add password reset functionality

fix(module): resolve file upload issue for large files

docs(readme): update installation instructions

test(validators): add tests for email validation
```

## Pull Request Process

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the coding standards

3. **Test your changes**:
   ```bash
   flutter test
   ```

4. **Format your code**:
   ```bash
   dart format .
   ```

5. **Run static analysis**:
   ```bash
   flutter analyze
   ```

6. **Commit your changes** with descriptive messages

7. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request** on GitHub with:
   - Clear title and description
   - Reference to related issues
   - Screenshots (if UI changes)
   - Test coverage information

### PR Checklist

- [ ] Code follows the project's style guidelines
- [ ] Self-review of code completed
- [ ] Comments added for complex code
- [ ] Documentation updated (if applicable)
- [ ] Tests added/updated
- [ ] All tests passing
- [ ] No new warnings from `flutter analyze`
- [ ] Code formatted with `dart format`

## Testing Guidelines

### Writing Tests

1. **Unit Tests**: Test individual functions and classes
   ```dart
   test('should validate email correctly', () {
     expect(FormValidators.validateEmail('test@example.com'), isNull);
   });
   ```

2. **Widget Tests**: Test UI components
   ```dart
   testWidgets('Login button should be present', (tester) async {
     await tester.pumpWidget(LoginScreen());
     expect(find.text('SIGN IN'), findsOneWidget);
   });
   ```

3. **Integration Tests**: Test complete user flows

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/auth_service_test.dart
```

### Code Coverage

Aim for at least 70% code coverage. Check coverage with:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Documentation

### Code Documentation

- Add doc comments for all public APIs:
  ```dart
  /// Validates email address format
  ///
  /// Returns `null` if valid, error message if invalid.
  static String? validateEmail(String? value) {
    // Implementation
  }
  ```

### Updating Documentation

When adding new features:
1. Update the README.md if necessary
2. Add/update relevant markdown documentation
3. Include inline code comments for complex logic
4. Update the TESTING_GUIDE.md if testing procedures change

## Questions or Issues?

- **Bug Reports**: Use the GitHub issue tracker
- **Feature Requests**: Create a detailed issue with use cases
- **Questions**: Start a discussion in GitHub Discussions

## License

By contributing to EduNova, you agree that your contributions will be licensed under the project's license.

---

Thank you for contributing to EduNova! Your efforts help make quality education more accessible. 🎓
