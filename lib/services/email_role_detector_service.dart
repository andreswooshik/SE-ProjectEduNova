import '../core/constants/app_constants.dart';
import 'interfaces/i_email_role_detector.dart';

/// Email role detector service
/// Single Responsibility Principle: Only responsible for detecting roles from emails
/// Open/Closed Principle: Open for extension (add more domains), closed for modification
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

  @override
  UserRole detectRole(String email) {
    if (isTeacherEmail(email)) {
      return UserRole.teacher;
    }
    return UserRole.student;
  }

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

  @override
  bool isStudentEmail(String email) {
    return !isTeacherEmail(email);
  }
}
