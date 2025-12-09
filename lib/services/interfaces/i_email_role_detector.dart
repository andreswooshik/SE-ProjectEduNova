import '../../core/constants/app_constants.dart';

/// Interface for email role detection
/// Interface Segregation Principle: Clients depend only on what they need
/// Dependency Inversion Principle: High-level modules depend on abstractions
abstract class IEmailRoleDetector {
  /// Detects user role based on email address
  /// Returns UserRole based on email domain pattern
  UserRole detectRole(String email);
  
  /// Checks if email is a teacher/work email
  bool isTeacherEmail(String email);
  
  /// Checks if email is a student email
  bool isStudentEmail(String email);
}
