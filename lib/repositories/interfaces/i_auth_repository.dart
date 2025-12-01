import '../../models/user.dart';

/// Data class for student registration
class StudentRegistrationData {
  final String firstName;
  final String lastName;
  final String email;
  final String school;
  final int schoolId;
  final String password;

  StudentRegistrationData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.school,
    required this.schoolId,
    required this.password,
  });
}

/// Data class for teacher registration
class TeacherRegistrationData {
  final String firstName;
  final String lastName;
  final String email;
  final String school;
  final int employeeId;
  final String password;

  TeacherRegistrationData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.school,
    required this.employeeId,
    required this.password,
  });
}

/// Interface Segregation Principle: Focused interface for authentication
/// Dependency Inversion Principle: Providers depend on this abstraction
abstract class IAuthRepository {
  /// Sign in with email and password
  Future<User?> signIn(String email, String password);

  /// Register a new student
  Future<User> registerStudent(StudentRegistrationData data);

  /// Register a new teacher
  Future<User> registerTeacher(TeacherRegistrationData data);

  /// Sign out the current user
  Future<void> signOut();

  /// Get the currently logged-in user
  Future<User?> getCurrentUser();

  /// Check if a user is logged in
  Future<bool> isLoggedIn();

  /// Check if email already exists
  Future<bool> emailExists(String email);
}
