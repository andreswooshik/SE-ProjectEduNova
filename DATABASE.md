# EduNova Database Architecture Documentation

## Table of Contents
- [Overview](#overview)
- [Database Technology](#database-technology)
- [Architecture Pattern](#architecture-pattern)
- [Core Components](#core-components)
- [Data Flow](#data-flow)
- [File Structure](#file-structure)
- [Code Examples](#code-examples)
- [SOLID Principles Application](#solid-principles-application)
- [Testing the Database](#testing-the-database)
- [Future Enhancements](#future-enhancements)

---

## Overview

EduNova uses a **local storage database** system based on Flutter's `SharedPreferences` package. This provides persistent data storage on the device without requiring an external database server. The architecture is designed following **Clean Architecture** principles with clear separation of concerns and dependency inversion.

### Key Features
- ✅ Local device storage (no backend required)
- ✅ JSON-based data serialization
- ✅ Interface-based abstraction for easy replacement
- ✅ Type-safe models with validation
- ✅ SOLID principles compliance
- ✅ Repository pattern for data access
- ✅ Provider pattern for dependency injection

---

## Database Technology

### SharedPreferences
**Package:** `shared_preferences: ^2.5.3`

SharedPreferences is a key-value storage system that persists data across app sessions. It's ideal for:
- User authentication data
- App settings and preferences
- Small to medium datasets
- Offline-first applications

**Storage Location:**
- **Android:** XML files in app's shared preferences directory
- **iOS:** NSUserDefaults
- **Web:** LocalStorage
- **Windows/Linux/macOS:** Local JSON files

### Data Format
Data is stored as JSON strings, allowing complex objects to be serialized and deserialized:

```dart
// Storing a user object
User user = Student(...);
String jsonString = jsonEncode(user.toJson());
await storage.saveString('current_user', jsonString);

// Retrieving a user object
String? jsonString = await storage.getString('current_user');
User user = User.fromJson(jsonDecode(jsonString));
```

---

## Architecture Pattern

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                     │
│  (Screens, Widgets, Providers - User Interface)         │
├─────────────────────────────────────────────────────────┤
│                   DOMAIN LAYER                           │
│  (Models, Use Cases, Business Logic)                    │
├─────────────────────────────────────────────────────────┤
│                   DATA LAYER                             │
│  (Repositories, Storage Services, Data Sources)         │
└─────────────────────────────────────────────────────────┘
```

### Dependency Flow

```
Screens/Widgets
      ↓
   Providers (Riverpod)
      ↓
   Repositories (Interfaces)
      ↓
   Storage Services (Interfaces)
      ↓
   LocalStorageService (SharedPreferences)
```

**Key Principle:** Higher-level modules depend on abstractions (interfaces), not concrete implementations. This allows easy replacement of storage mechanisms.

---

## Core Components

### 1. Storage Constants
**File:** [`lib/core/constants/app_constants.dart`](lib/core/constants/app_constants.dart)

Defines all storage keys used throughout the application:

```dart
class AppConstants {
  // Storage Keys
  static const String currentUserKey = 'current_user';
  static const String usersListKey = 'users_list';
  static const String coursesListKey = 'courses_list';
  static const String modulesListKey = 'modules_list';
  static const String isLoggedInKey = 'is_logged_in';
  static const String storagePrefix = 'edunova_';
}
```

**Purpose:** Centralizes all storage keys to prevent typos and ensure consistency.

---

### 2. Storage Interfaces

#### IStorageService Interface
**File:** [`lib/services/interfaces/i_storage_service.dart`](lib/services/interfaces/i_storage_service.dart)

Base interface for all storage operations:

```dart
abstract class IStorageService {
  Future<bool> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> saveStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  Future<bool> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<bool> containsKey(String key);
}
```

**SOLID Principle Applied:**
- **Interface Segregation Principle:** Small, focused interface
- **Dependency Inversion Principle:** High-level modules depend on this abstraction

#### IUserStorageService Interface
**File:** [`lib/services/interfaces/i_user_storage_service.dart`](lib/services/interfaces/i_user_storage_service.dart)

User-specific storage operations:

```dart
abstract class IUserStorageService {
  Future<List<User>> getAllUsers();
  Future<User?> getUserByEmail(String email);
  Future<void> saveUser(User user);
  Future<bool> emailExists(String email);
}
```

#### ICourseStorageService Interface
**File:** [`lib/services/interfaces/i_course_storage_service.dart`](lib/services/interfaces/i_course_storage_service.dart)

Course-specific storage operations:

```dart
abstract class ICourseStorageService {
  Future<List<Course>> getAllCourses();
  Future<void> saveCourses(List<Course> courses);
}
```

---

### 3. Storage Service Implementation

#### LocalStorageService
**File:** [`lib/services/local_storage_service.dart`](lib/services/local_storage_service.dart)

Concrete implementation using SharedPreferences:

```dart
class LocalStorageService implements IStorageService {
  SharedPreferences? _prefs;

  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<bool> saveString(String key, String value) async {
    await _ensureInitialized();
    return await _prefs!.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    await _ensureInitialized();
    return _prefs!.getString(key);
  }
  
  // ... other methods
}
```

**Key Features:**
- Lazy initialization of SharedPreferences
- Async operations for non-blocking I/O
- Error handling with null safety
- Can be replaced with Firebase, SQLite, or any other storage without changing dependent code

#### UserStorageService
**File:** [`lib/services/user_storage_service.dart`](lib/services/user_storage_service.dart)

Handles user data persistence:

```dart
class UserStorageService implements IUserStorageService {
  final IStorageService _storageService;

  UserStorageService(this._storageService);

  @override
  Future<List<User>> getAllUsers() async {
    final usersJson = await _storageService.getStringList(
      AppConstants.usersListKey
    );
    if (usersJson == null || usersJson.isEmpty) return [];

    return usersJson.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return User.fromJson(data);
    }).toList();
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    final users = await getAllUsers();
    users.add(user);
    
    final usersJson = users.map((u) => jsonEncode(u.toJson())).toList();
    await _storageService.saveStringList(
      AppConstants.usersListKey, 
      usersJson
    );
  }

  @override
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }
}
```

**SOLID Principle Applied:**
- **Single Responsibility:** Only handles user storage logic
- **Dependency Inversion:** Depends on `IStorageService` interface, not concrete implementation

#### CourseStorageService
**File:** [`lib/services/course_storage_service.dart`](lib/services/course_storage_service.dart)

Handles course data persistence:

```dart
class CourseStorageService implements ICourseStorageService {
  final IStorageService _storageService;

  CourseStorageService(this._storageService);

  @override
  Future<List<Course>> getAllCourses() async {
    final coursesJson = await _storageService.getStringList(
      AppConstants.coursesListKey
    );
    if (coursesJson == null || coursesJson.isEmpty) return [];

    return coursesJson.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return Course.fromJson(data);
    }).toList();
  }

  @override
  Future<void> saveCourses(List<Course> courses) async {
    final coursesJson = courses.map((c) => jsonEncode(c.toJson())).toList();
    await _storageService.saveStringList(
      AppConstants.coursesListKey, 
      coursesJson
    );
  }
}
```

---

### 4. Repository Layer

Repositories provide high-level business logic for data operations.

#### AuthRepository
**File:** [`lib/repositories/auth_repository.dart`](lib/repositories/auth_repository.dart)

Handles authentication and user management:

```dart
class AuthRepository implements IAuthRepository {
  final IStorageService _storageService;
  final IUserStorageService _userStorageService;
  final AdminAuthService _adminAuthService;

  AuthRepository(
    this._storageService,
    this._userStorageService,
    this._adminAuthService,
  );

  @override
  Future<User?> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return null;

    // Check admin account first
    final admin = _adminAuthService.authenticate(email, password);
    if (admin != null) {
      await _saveSession(admin);
      return admin;
    }

    // Check regular users
    final user = await _userStorageService.getUserByEmail(email);
    if (user != null && HashUtils.verifyPassword(password, user.passwordHash)) {
      await _saveSession(user);
      return user;
    }
    
    return null;
  }

  @override
  Future<User> registerStudent(StudentRegistrationData data) async {
    if (await _userStorageService.emailExists(data.email)) {
      throw Exception('Email already registered');
    }

    final student = Student(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: data.firstName.trim(),
      lastName: data.lastName.trim(),
      email: data.email.trim().toLowerCase(),
      school: data.school.trim(),
      passwordHash: HashUtils.hashPassword(data.password),
      schoolId: data.schoolId,
    );

    await _userStorageService.saveUser(student);
    await _saveSession(student);
    return student;
  }

  Future<void> _saveSession(User user) async {
    await _storageService.saveString(
      AppConstants.currentUserKey,
      jsonEncode(user.toJson())
    );
    await _storageService.saveBool(AppConstants.isLoggedInKey, true);
  }
}
```

**Operations:**
- User authentication (sign in)
- User registration (students and teachers)
- Session management
- Password hashing and verification

#### CourseRepository
**File:** [`lib/repositories/course_repository.dart`](lib/repositories/course_repository.dart)

Handles course data operations:

```dart
class CourseRepository implements ICourseRepository {
  final ICourseStorageService _courseStorageService;
  final IModuleRepository? _moduleRepository;

  CourseRepository(
    this._courseStorageService, 
    {IModuleRepository? moduleRepository}
  ) : _moduleRepository = moduleRepository;

  @override
  Future<List<Course>> getAllCourses() async {
    return await _courseStorageService.getAllCourses();
  }

  @override
  Future<Course?> getCourseById(String courseId) async {
    final allCourses = await getAllCourses();
    try {
      return allCourses.firstWhere((c) => c.id == courseId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Course> createCourse(Course course) async {
    final courses = await getAllCourses();
    courses.add(course);
    await _courseStorageService.saveCourses(courses);
    return course;
  }

  @override
  Future<Course> updateCourse(Course course) async {
    final courses = await getAllCourses();
    final index = courses.indexWhere((c) => c.id == course.id);
    
    if (index == -1) {
      throw Exception('Course not found');
    }

    courses[index] = course.copyWith(updatedAt: DateTime.now());
    await _courseStorageService.saveCourses(courses);
    return courses[index];
  }

  @override
  Future<bool> enrollStudent(String courseId, String studentId) async {
    final course = await getCourseById(courseId);
    if (course == null) return false;

    if (course.enrolledStudentIds.contains(studentId)) {
      return true; // Already enrolled
    }

    final updatedCourse = course.copyWith(
      enrolledStudentIds: [...course.enrolledStudentIds, studentId],
    );

    await updateCourse(updatedCourse);
    return true;
  }
}
```

**Operations:**
- CRUD operations for courses
- Student enrollment management
- Teacher course filtering
- Cascade delete with modules

---

### 5. Data Models

#### User Model
**File:** [`lib/models/user.dart`](lib/models/user.dart)

Abstract base class with Student and Teacher subclasses:

```dart
abstract class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String school;
  final String passwordHash;
  final UserRole role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.school,
    required this.passwordHash,
    required this.role,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson();
  
  static User fromJson(Map<String, dynamic> json) {
    final role = UserRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => UserRole.student,
    );

    if (role == UserRole.student) {
      return Student.fromJson(json);
    } else if (role == UserRole.teacher) {
      return Teacher.fromJson(json);
    } else {
      return Admin.fromJson(json);
    }
  }
}

class Student extends User {
  final int schoolId;

  Student({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.school,
    required super.passwordHash,
    required this.schoolId,
    super.createdAt,
  }) : super(role: UserRole.student);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'school': school,
      'passwordHash': passwordHash,
      'role': role.name,
      'schoolId': schoolId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      school: json['school'] as String,
      passwordHash: json['passwordHash'] as String,
      schoolId: json['schoolId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
```

**SOLID Principles Applied:**
- **Liskov Substitution Principle:** Student and Teacher can be used wherever User is expected
- **Open/Closed Principle:** Extensible through inheritance without modifying base class

#### Course Model
**File:** [`lib/models/course.dart`](lib/models/course.dart)

```dart
class Course {
  final String id;
  final String title;
  final String description;
  final String teacherId;
  final List<String> enrolledStudentIds;
  final List<CourseMaterial> materials;
  final List<Assignment> assignments;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.teacherId,
    List<String>? enrolledStudentIds,
    List<CourseMaterial>? materials,
    List<Assignment>? assignments,
    DateTime? createdAt,
    this.updatedAt,
  })  : enrolledStudentIds = enrolledStudentIds ?? [],
        materials = materials ?? [],
        assignments = assignments ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teacherId': teacherId,
      'enrolledStudentIds': enrolledStudentIds,
      'materials': materials.map((m) => m.toJson()).toList(),
      'assignments': assignments.map((a) => a.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      teacherId: json['teacherId'] as String,
      enrolledStudentIds: List<String>.from(json['enrolledStudentIds'] ?? []),
      materials: (json['materials'] as List<dynamic>?)
              ?.map((m) => CourseMaterial.fromJson(m))
              .toList() ?? [],
      assignments: (json['assignments'] as List<dynamic>?)
              ?.map((a) => Assignment.fromJson(a))
              .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }
}
```

---

### 6. Dependency Injection with Riverpod

**File:** [`lib/providers/auth_provider.dart`](lib/providers/auth_provider.dart)

Providers wire up all dependencies:

```dart
/// Storage service provider
final storageServiceProvider = Provider<IStorageService>((ref) {
  return LocalStorageService();
});

/// User storage service provider
final userStorageServiceProvider = Provider<IUserStorageService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return UserStorageService(storageService);
});

/// Auth repository provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final userStorageService = ref.watch(userStorageServiceProvider);
  final adminAuthService = ref.watch(adminAuthServiceProvider);
  return AuthRepository(
    storageService, 
    userStorageService, 
    adminAuthService
  );
});

/// Auth state notifier
class AuthNotifier extends Notifier<AuthState> {
  late IAuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return AuthState.initial();
  }

  Future<void> signIn(String email, String password) async {
    state = AuthState.loading();
    
    try {
      final user = await _authRepository.signIn(email, password);
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.error('Invalid credentials');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
```

---

## Data Flow

### User Registration Flow

```
┌──────────────┐
│   UI Screen  │ (SignUpPage)
└──────┬───────┘
       │ 1. User enters data
       ↓
┌──────────────┐
│   Provider   │ (AuthNotifier)
└──────┬───────┘
       │ 2. Calls registerStudent()
       ↓
┌──────────────┐
│  Repository  │ (AuthRepository)
└──────┬───────┘
       │ 3. Validates email
       │ 4. Creates Student model
       │ 5. Hashes password
       ↓
┌──────────────┐
│   Storage    │ (UserStorageService)
│   Service    │
└──────┬───────┘
       │ 6. Serializes to JSON
       ↓
┌──────────────┐
│    Local     │ (LocalStorageService)
│   Storage    │
└──────┬───────┘
       │ 7. Saves to SharedPreferences
       ↓
┌──────────────┐
│    Device    │ (Persistent storage)
└──────────────┘
```

### User Authentication Flow

```
┌──────────────┐
│   UI Screen  │ (SignInPage)
└──────┬───────┘
       │ 1. User enters credentials
       ↓
┌──────────────┐
│   Provider   │ (AuthNotifier)
└──────┬───────┘
       │ 2. Calls signIn()
       ↓
┌──────────────┐
│  Repository  │ (AuthRepository)
└──────┬───────┘
       │ 3. Retrieves user by email
       ↓
┌──────────────┐
│   Storage    │ (UserStorageService)
│   Service    │
└──────┬───────┘
       │ 4. Gets user list from storage
       ↓
┌──────────────┐
│    Local     │ (LocalStorageService)
│   Storage    │
└──────┬───────┘
       │ 5. Retrieves from SharedPreferences
       │ 6. Returns JSON string list
       ↑
       │ 7. Deserializes JSON to User objects
┌──────┴───────┐
│   Storage    │
│   Service    │
└──────┬───────┘
       │ 8. Finds user by email
       ↑
┌──────┴───────┐
│  Repository  │
└──────┬───────┘
       │ 9. Verifies password hash
       │ 10. Saves session if valid
       ↓
┌──────────────┐
│   Provider   │
└──────┬───────┘
       │ 11. Updates state
       ↓
┌──────────────┐
│   UI Screen  │ (Navigates to dashboard)
└──────────────┘
```

### Course Creation Flow

```
┌──────────────┐
│   UI Screen  │ (Teacher Dashboard)
└──────┬───────┘
       │ 1. Teacher creates course
       ↓
┌──────────────┐
│   Provider   │ (CoursesNotifier)
└──────┬───────┘
       │ 2. Calls createCourse()
       ↓
┌──────────────┐
│  Repository  │ (CourseRepository)
└──────┬───────┘
       │ 3. Creates Course model
       │ 4. Adds to course list
       ↓
┌──────────────┐
│   Storage    │ (CourseStorageService)
│   Service    │
└──────┬───────┘
       │ 5. Serializes all courses to JSON
       ↓
┌──────────────┐
│    Local     │ (LocalStorageService)
│   Storage    │
└──────┬───────┘
       │ 6. Saves JSON list to SharedPreferences
       ↓
┌──────────────┐
│    Device    │ (Persistent storage)
└──────────────┘
```

---

## File Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # Storage keys and constants
│   └── utils/
│       └── hash_utils.dart             # Password hashing utilities
│
├── models/
│   ├── user.dart                       # User, Student, Teacher models
│   ├── course.dart                     # Course model with materials
│   ├── module.dart                     # Module model
│   ├── assignment.dart                 # Assignment model
│   └── quiz.dart                       # Quiz model
│
├── services/
│   ├── interfaces/
│   │   ├── i_storage_service.dart      # Base storage interface
│   │   ├── i_user_storage_service.dart # User storage interface
│   │   ├── i_course_storage_service.dart # Course storage interface
│   │   └── i_module_storage_service.dart # Module storage interface
│   │
│   ├── local_storage_service.dart      # SharedPreferences implementation
│   ├── user_storage_service.dart       # User data operations
│   ├── course_storage_service.dart     # Course data operations
│   └── module_storage_service.dart     # Module data operations
│
├── repositories/
│   ├── interfaces/
│   │   ├── i_auth_repository.dart      # Auth repository interface
│   │   ├── i_course_repository.dart    # Course repository interface
│   │   └── i_module_repository.dart    # Module repository interface
│   │
│   ├── auth_repository.dart            # Authentication logic
│   ├── course_repository.dart          # Course business logic
│   └── module_repository.dart          # Module business logic
│
├── providers/
│   ├── app_providers.dart              # Main provider configuration
│   ├── auth_provider.dart              # Authentication state management
│   ├── courses_provider.dart           # Course state management
│   └── module_provider.dart            # Module state management
│
└── screens/
    ├── signin_page.dart                # Login screen
    ├── signup_page.dart                # Registration screen
    ├── student_dashboard.dart          # Student home
    └── teacher_dashboard.dart          # Teacher home

test/
└── database_test.dart                  # Database health check tests
```

---

## Code Examples

### Example 1: Saving a New User

```dart
// 1. Create a student instance
final student = Student(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  firstName: 'John',
  lastName: 'Doe',
  email: 'john.doe@example.com',
  school: 'Example University',
  passwordHash: HashUtils.hashPassword('password123'),
  schoolId: 12345,
);

// 2. Save to storage service
final userStorageService = UserStorageService(LocalStorageService());
await userStorageService.saveUser(student);

// Storage process:
// a. Get existing users list from SharedPreferences
// b. Deserialize JSON strings to User objects
// c. Add new student to list
// d. Serialize all users back to JSON strings
// e. Save updated list to SharedPreferences
```

### Example 2: Authenticating a User

```dart
// In AuthRepository
Future<User?> signIn(String email, String password) async {
  // 1. Retrieve user by email
  final user = await _userStorageService.getUserByEmail(email);
  
  // 2. Verify password
  if (user != null && HashUtils.verifyPassword(password, user.passwordHash)) {
    // 3. Save session
    await _storageService.saveString(
      AppConstants.currentUserKey,
      jsonEncode(user.toJson())
    );
    await _storageService.saveBool(AppConstants.isLoggedInKey, true);
    
    return user;
  }
  
  return null;
}

// Used in UI:
final authNotifier = ref.read(authProvider.notifier);
final user = await authNotifier.signIn('john@example.com', 'password123');
```

### Example 3: Creating a Course

```dart
// In CourseRepository
Future<Course> createCourse(Course course) async {
  // 1. Get all existing courses
  final courses = await getAllCourses();
  
  // 2. Add new course
  courses.add(course);
  
  // 3. Save updated list
  await _courseStorageService.saveCourses(courses);
  
  return course;
}

// Used in UI (Teacher Dashboard):
final newCourse = Course(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  title: 'Introduction to Flutter',
  description: 'Learn Flutter from scratch',
  teacherId: currentUser.id,
);

final courseRepository = ref.read(courseRepositoryProvider);
await courseRepository.createCourse(newCourse);
```

### Example 4: Enrolling a Student in a Course

```dart
// In CourseRepository
Future<bool> enrollStudent(String courseId, String studentId) async {
  // 1. Find the course
  final course = await getCourseById(courseId);
  if (course == null) return false;
  
  // 2. Check if already enrolled
  if (course.enrolledStudentIds.contains(studentId)) {
    return true;
  }
  
  // 3. Add student to enrollment list
  final updatedCourse = course.copyWith(
    enrolledStudentIds: [...course.enrolledStudentIds, studentId],
  );
  
  // 4. Save updated course
  await updateCourse(updatedCourse);
  return true;
}

// Used in UI (Student Dashboard):
final courseRepository = ref.read(courseRepositoryProvider);
await courseRepository.enrollStudent(courseId, currentUser.id);
```

### Example 5: Querying Data

```dart
// Get all courses for a specific teacher
Future<List<Course>> getCoursesForTeacher(String teacherId) async {
  final allCourses = await getAllCourses();
  return allCourses.where((c) => c.teacherId == teacherId).toList();
}

// Get all courses a student is enrolled in
Future<List<Course>> getCoursesForStudent(String studentId) async {
  final allCourses = await getAllCourses();
  return allCourses
      .where((c) => c.enrolledStudentIds.contains(studentId))
      .toList();
}

// Check if email exists before registration
Future<bool> emailExists(String email) async {
  final user = await getUserByEmail(email);
  return user != null;
}
```

---

## SOLID Principles Application

### 1. Single Responsibility Principle (SRP)

Each class has one reason to change:

- **`LocalStorageService`**: Only handles low-level storage operations
- **`UserStorageService`**: Only handles user data persistence
- **`CourseStorageService`**: Only handles course data persistence
- **`AuthRepository`**: Only handles authentication logic
- **`CourseRepository`**: Only handles course business logic

```dart
// ❌ BAD: Class doing too much
class UserService {
  Future<User?> signIn(String email, String password) { }
  Future<void> saveUser(User user) { }
  Future<List<Course>> getUserCourses(String userId) { }
  Future<void> sendEmail(User user) { }
}

// ✅ GOOD: Separate responsibilities
class AuthRepository {
  Future<User?> signIn(String email, String password) { }
}

class UserStorageService {
  Future<void> saveUser(User user) { }
}

class CourseRepository {
  Future<List<Course>> getUserCourses(String userId) { }
}

class EmailService {
  Future<void> sendEmail(User user) { }
}
```

### 2. Open/Closed Principle (OCP)

Classes are open for extension, closed for modification:

```dart
// Base interface remains unchanged
abstract class IStorageService {
  Future<bool> saveString(String key, String value);
  Future<String?> getString(String key);
}

// Can extend with new implementations
class LocalStorageService implements IStorageService {
  // SharedPreferences implementation
}

class FirebaseStorageService implements IStorageService {
  // Firebase implementation
}

class SQLiteStorageService implements IStorageService {
  // SQLite implementation
}
```

**Benefit:** Can add new storage mechanisms without modifying existing code.

### 3. Liskov Substitution Principle (LSP)

Subtypes can replace their base types:

```dart
// Base class
abstract class User {
  final String id;
  final String email;
  // ...
}

// Subtypes
class Student extends User { }
class Teacher extends User { }
class Admin extends User { }

// Can use any user type interchangeably
Future<void> saveUser(User user) async {
  // Works with Student, Teacher, or Admin
  await userStorageService.saveUser(user);
}

// Polymorphic deserialization
User user = User.fromJson(json); // Returns Student, Teacher, or Admin
```

### 4. Interface Segregation Principle (ISP)

Clients don't depend on interfaces they don't use:

```dart
// ✅ GOOD: Small, focused interfaces
abstract class IStorageService {
  Future<bool> saveString(String key, String value);
  Future<String?> getString(String key);
}

abstract class IUserStorageService {
  Future<List<User>> getAllUsers();
  Future<User?> getUserByEmail(String email);
}

abstract class ICourseStorageService {
  Future<List<Course>> getAllCourses();
  Future<void> saveCourses(List<Course> courses);
}

// ❌ BAD: One large interface
abstract class IStorageService {
  // User methods
  Future<List<User>> getAllUsers();
  Future<User?> getUserByEmail(String email);
  // Course methods
  Future<List<Course>> getAllCourses();
  // Module methods
  Future<List<Module>> getAllModules();
  // Assignment methods
  Future<List<Assignment>> getAllAssignments();
  // ... too many responsibilities
}
```

### 5. Dependency Inversion Principle (DIP)

High-level modules depend on abstractions, not concretions:

```dart
// ✅ GOOD: Depend on abstraction
class AuthRepository implements IAuthRepository {
  final IStorageService _storageService;        // Interface
  final IUserStorageService _userStorageService; // Interface
  
  AuthRepository(this._storageService, this._userStorageService);
}

// ❌ BAD: Depend on concrete class
class AuthRepository {
  final LocalStorageService _storageService;    // Concrete class
  final UserStorageService _userStorageService; // Concrete class
  
  AuthRepository(this._storageService, this._userStorageService);
}
```

**Benefits:**
- Easy to test with mock implementations
- Can swap implementations without changing dependent code
- Loose coupling between components

---

## Testing the Database

### Running Database Tests

```bash
# Run all tests
flutter test

# Run only database tests
flutter test test/database_test.dart

# Run with verbose output
flutter test test/database_test.dart --verbose
```

### Test Coverage

**File:** [`test/database_test.dart`](test/database_test.dart)

The test suite verifies:

1. **LocalStorageService Operations**
   - Save and retrieve strings
   - Save and retrieve string lists
   - Save and retrieve booleans

2. **UserStorageService Operations**
   - Save users
   - Retrieve all users
   - Get user by email
   - Check email existence

3. **CourseStorageService Operations**
   - Save courses
   - Retrieve all courses

4. **Complete Health Check**
   - Initialize SharedPreferences
   - Write operations
   - Read operations
   - All services operational

### Example Test Output

```
00:07 +0: Database Tests LocalStorageService - Save and retrieve string
✓ LocalStorageService string operations working
00:07 +1: Database Tests LocalStorageService - Save and retrieve string list
✓ LocalStorageService list operations working
00:07 +2: Database Tests UserStorageService - Save and retrieve user
✓ User saved successfully
✓ UserStorageService operations working
00:07 +3: Database Tests UserStorageService - Check if email exists
✓ Email existence check working
00:07 +4: Database Tests CourseStorageService - Save and retrieve courses
✓ Course saved successfully
✓ CourseStorageService operations working
00:07 +5: Database Health Check Complete database health check

═══════════════════════════════════════
   DATABASE HEALTH CHECK: PASSED ✓
═══════════════════════════════════════
✓ SharedPreferences initialized
✓ Write operations successful
✓ Read operations successful
✓ All storage services operational
═══════════════════════════════════════

00:07 +6: All tests passed!
```

### Manual Testing

You can test the database through the app UI:

1. **Registration Flow**
   - Open the app
   - Navigate to Sign Up
   - Fill in the form and submit
   - Check if user is saved (try logging in)

2. **Authentication Flow**
   - Try logging in with test accounts:
     - Student: `student@gmail.com` / `password123`
     - Teacher: `teacher@university.edu` / `password123`
   - Verify session persistence (close and reopen app)

3. **Course Management**
   - Log in as teacher
   - Create a new course
   - Verify course appears in course list
   - Log out and log in again to verify persistence

4. **Enrollment Flow**
   - Log in as student
   - Browse available courses
   - Enroll in a course
   - Verify enrollment persists after logout

---

## Future Enhancements

### 1. Backend Integration

Replace local storage with a backend API:

```dart
// New implementation
class ApiStorageService implements IStorageService {
  final Dio _dio;
  
  @override
  Future<bool> saveString(String key, String value) async {
    final response = await _dio.post('/storage', data: {
      'key': key,
      'value': value,
    });
    return response.statusCode == 200;
  }
  
  @override
  Future<String?> getString(String key) async {
    final response = await _dio.get('/storage/$key');
    return response.data['value'];
  }
}

// In providers, just change one line:
final storageServiceProvider = Provider<IStorageService>((ref) {
  return ApiStorageService(Dio()); // Instead of LocalStorageService()
});
```

### 2. Firebase Integration

```dart
class FirebaseStorageService implements IStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  @override
  Future<bool> saveString(String key, String value) async {
    await _firestore.collection('storage').doc(key).set({
      'value': value,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return true;
  }
  
  @override
  Future<String?> getString(String key) async {
    final doc = await _firestore.collection('storage').doc(key).get();
    return doc.data()?['value'];
  }
}
```

### 3. SQLite Database

For more complex queries and better performance:

```dart
class SQLiteStorageService implements IStorageService {
  final Database _db;
  
  @override
  Future<bool> saveString(String key, String value) async {
    await _db.insert(
      'storage',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }
  
  @override
  Future<String?> getString(String key) async {
    final results = await _db.query(
      'storage',
      where: 'key = ?',
      whereArgs: [key],
    );
    return results.isNotEmpty ? results.first['value'] as String : null;
  }
}
```

### 4. Caching Layer

Add a caching layer for better performance:

```dart
class CachedStorageService implements IStorageService {
  final IStorageService _underlyingStorage;
  final Map<String, String> _cache = {};
  
  CachedStorageService(this._underlyingStorage);
  
  @override
  Future<bool> saveString(String key, String value) async {
    _cache[key] = value;
    return await _underlyingStorage.saveString(key, value);
  }
  
  @override
  Future<String?> getString(String key) async {
    if (_cache.containsKey(key)) {
      return _cache[key];
    }
    final value = await _underlyingStorage.getString(key);
    if (value != null) _cache[key] = value;
    return value;
  }
}
```

### 5. Data Synchronization

Implement offline-first with sync:

```dart
class SyncStorageService implements IStorageService {
  final IStorageService _localStorage;
  final IStorageService _remoteStorage;
  
  SyncStorageService(this._localStorage, this._remoteStorage);
  
  @override
  Future<bool> saveString(String key, String value) async {
    // Save locally first
    await _localStorage.saveString(key, value);
    
    // Queue for remote sync
    _queueForSync(key, value);
    
    return true;
  }
  
  Future<void> sync() async {
    // Sync all pending changes to remote storage
    for (final change in _syncQueue) {
      await _remoteStorage.saveString(change.key, change.value);
    }
  }
}
```

---

## Summary

The EduNova database architecture demonstrates:

✅ **Clean Architecture** with clear separation of concerns  
✅ **SOLID Principles** applied throughout the codebase  
✅ **Repository Pattern** for business logic abstraction  
✅ **Interface-based Design** for flexibility and testability  
✅ **Dependency Injection** with Riverpod for loose coupling  
✅ **Type-safe Models** with JSON serialization  
✅ **Comprehensive Testing** for reliability  

This architecture makes it easy to:
- Replace storage mechanisms (local → backend → Firebase)
- Test components in isolation
- Extend functionality without breaking existing code
- Maintain and scale the application

---

## Related Documentation

- [Developer Guide](DEVELOPER_GUIDE.md) - Complete development guide
- [SOLID Principles](SOLID_PRINCIPLES.md) - SOLID principles implementation
- [Testing Guide](TESTING_GUIDE.md) - Testing procedures
- [Security Best Practices](SECURITY.md) - Security guidelines

---

**Last Updated:** December 12, 2025  
**Version:** 1.0.0
