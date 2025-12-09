# Changelog

All notable changes to the EduNova project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Documentation**: Comprehensive CONTRIBUTING.md with contribution guidelines
- **Documentation**: SECURITY.md with security best practices and vulnerability reporting
- **Documentation**: DEVELOPER_GUIDE.md with architecture, development workflow, and common tasks
- **Documentation**: DESIGN_SYSTEM.md for design specifications and UI consistency
- **Documentation**: CODE_STYLE_GUIDE.md for coding standards and conventions
- **Documentation**: PERFORMANCE.md for optimization techniques and profiling
- **Documentation**: CHANGELOG.md for tracking version history
- **CI/CD**: GitHub Actions workflow for automated testing and builds
- **Code Quality**: ErrorHandler utility class for centralized error logging
- **Code Quality**: UIConstants for consistent spacing, sizing, and styling
- **Validation**: Enhanced password validation with optional complexity enforcement
- **Validation**: URL validation utility
- **Validation**: Generic text field validation with customizable constraints and proper grammar
- **Validation**: Module and course title validation
- **Validation**: Description validation with length limits
- **Testing**: Updated widget tests to match actual app structure
- **Documentation**: API documentation comments to email role detector service

### Changed
- **Code Quality**: Replaced `print()` with `debugPrint()` in file_storage_service.dart
- **Documentation**: Enhanced README.md with badges, better structure, and quick start guide
- **Documentation**: Added comprehensive documentation links in README
- **Code Quality**: Improved code comments and documentation throughout
- **Validation**: Refactored password validation to eliminate code duplication
- **Validation**: Improved error message formatting with proper articles and capitalization
- **CI/CD**: Made Flutter version configurable via environment variable
- **Documentation**: Added note about password length requirements in SECURITY.md

### Fixed
- **Testing**: Fixed obsolete counter test in widget_test.dart
- **Code Quality**: Removed debug print statement that violated linting rules
- **Code Quality**: Eliminated code duplication in password validators
- **UX**: Improved error messages for better user experience

## [1.0.0] - 2024-12-09

### Added (Previous Implementation)
- Role-based authentication system with automatic role detection
- Student and Teacher dashboards with role-specific features
- Module management system (Phases 1-3 complete)
- File storage service with validation and cleanup
- Course repository with cascade delete functionality
- Riverpod state management implementation
- SOLID principles throughout the codebase
- Form validators for common input types
- User models (Student, Teacher, Admin) with Liskov Substitution Principle
- Email role detector service
- Local storage services for users, courses, and modules
- Teacher dashboard with access control
- Student dashboard via main navigation

### Features
- **Authentication**
  - Sign up with automatic role detection
  - Sign in with role-based navigation
  - Password hashing with bcrypt
  - Session management
  
- **Student Features**
  - Browse available courses
  - Access published modules
  - View learning resources
  - Track course progress
  
- **Teacher Features**
  - Create and manage courses
  - Upload and organize modules
  - Add learning resources (PDF, PPT, DOCX, XLSX, etc.)
  - Publish/unpublish modules
  - File size limit enforcement (50MB)
  
- **Core Features**
  - Clean architecture with separation of concerns
  - Dependency injection via Riverpod
  - Type-safe state management
  - File type validation
  - Sanitized file names for security
  - Orphaned file cleanup

### Technical Details
- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **State Management**: Riverpod 3.x
- **Architecture**: Clean Architecture + SOLID Principles
- **Local Storage**: SharedPreferences
- **Password Security**: bcrypt hashing

## Guidelines for Future Changelog Entries

### Types of Changes
- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security vulnerability fixes

### Commit Message Format
Follow conventional commits for easy changelog generation:
- `feat:` for new features (Added)
- `fix:` for bug fixes (Fixed)
- `docs:` for documentation (Changed/Added)
- `style:` for formatting changes
- `refactor:` for code refactoring (Changed)
- `test:` for test additions/changes
- `chore:` for maintenance tasks

### Version Numbering
- **Major (X.0.0)**: Breaking changes
- **Minor (0.X.0)**: New features, backwards compatible
- **Patch (0.0.X)**: Bug fixes, backwards compatible

---

**Note**: This changelog tracks significant changes. For detailed commit history, see the Git log.
