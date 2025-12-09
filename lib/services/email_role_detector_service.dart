import '../core/constants/app_constants.dart';
import 'interfaces/i_email_role_detector.dart';

/// Email role detector service
/// 
/// Automatically detects user roles (Student, Teacher) based on email address patterns.
/// This service implements the Single Responsibility Principle by focusing solely on
/// role detection logic.
/// 
/// Detection Rules:
/// - **Teachers**: Detected by educational/organizational domains or role keywords
/// - **Students**: Default role for all other email addresses
/// 
/// Single Responsibility Principle: Only responsible for detecting roles from emails
/// Open/Closed Principle: Open for extension (add more domains), closed for modification
/// 
/// Example usage:
/// ```dart
/// final detector = EmailRoleDetectorService();
/// final role = detector.detectRole('teacher@university.edu');
/// print(role); // UserRole.teacher
/// ```
class EmailRoleDetectorService implements IEmailRoleDetector {
  // Teacher/Work email domains (educational and organizational)
  static const List<String> _teacherDomains = [
    '.edu',          // Educational institutions
    '.edu.ph',       // Philippine educational institutions
    '.ac.uk',        // UK academic institutions
    '.ac.jp',        // Japanese academic institutions
    '.edu.au',       // Australian educational institutions
    'school.com',    // Generic school domain
    'university.com',// Generic university domain
    'college.com',   // Generic college domain
    '.gov',          // Government institutions
    '.org',          // Organizations
  ];

  // Keywords in email that suggest teacher/staff accounts
  static const List<String> _teacherKeywords = [
    'teacher',
    'faculty',
    'staff',
    'instructor',
    'professor',
    'admin',
    'dept',
    'department',
  ];

  /// Detects the user role based on email address
  /// 
  /// Returns [UserRole.teacher] if the email matches teacher patterns,
  /// otherwise returns [UserRole.student] as the default role.
  /// 
  /// Parameters:
  /// - [email]: The email address to analyze
  /// 
  /// Returns: The detected [UserRole]
  @override
  UserRole detectRole(String email) {
    if (isTeacherEmail(email)) {
      return UserRole.teacher;
    }
    return UserRole.student;
  }

  /// Checks if an email belongs to a teacher
  /// 
  /// Determines if the email address matches teacher patterns by checking:
  /// 1. Educational or organizational domain suffixes
  /// 2. Teacher-related keywords in the email address
  /// 
  /// Parameters:
  /// - [email]: The email address to check
  /// 
  /// Returns: `true` if the email matches teacher patterns, `false` otherwise
  @override
  bool isTeacherEmail(String email) {
    final lowercaseEmail = email.toLowerCase();
    
    // Check for teacher email domains
    for (final domain in _teacherDomains) {
      if (lowercaseEmail.endsWith(domain)) {
        return true;
      }
    }
    
    // Check for teacher keywords in email address
    for (final keyword in _teacherKeywords) {
      if (lowercaseEmail.contains(keyword)) {
        return true;
      }
    }
    
    return false;
  }

  /// Checks if an email belongs to a student
  /// 
  /// A student email is any email that doesn't match teacher patterns.
  /// This is the default role for the application.
  /// 
  /// Parameters:
  /// - [email]: The email address to check
  /// 
  /// Returns: `true` if the email is classified as a student email, `false` otherwise
  @override
  bool isStudentEmail(String email) {
    return !isTeacherEmail(email);
  }
}
