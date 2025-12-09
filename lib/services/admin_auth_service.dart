import '../models/user.dart';
import '../core/utils/hash_utils.dart';

/// Service responsible for admin authentication
/// Single Responsibility Principle: Encapsulates admin logic
class AdminAuthService {
  /// Authenticate admin user
  User? authenticate(String email, String password) {
    // In a real app, this might check against a secure config or separate DB
    
    // Admin account
    if (email == 'admin@edunova.ph' && password == 'admin123') {
      return Admin(
        id: 'admin-001',
        firstName: 'System',
        lastName: 'Admin',
        email: email,
        passwordHash: HashUtils.hashPassword(password),
      );
    }
    
    // Pre-configured Student account for testing
    if (email == 'student@edunova.ph' && password == 'student123') {
      return Student(
        id: 'student-test-001',
        firstName: 'Test',
        lastName: 'Student',
        email: email,
        school: 'University of the Philippines',
        passwordHash: HashUtils.hashPassword(password),
        schoolId: 2024001,
      );
    }
    
    // Pre-configured Teacher account for testing
    if (email == 'teacher@edunova.ph' && password == 'teacher123') {
      return Teacher(
        id: 'teacher-test-001',
        firstName: 'Test',
        lastName: 'Teacher',
        email: email,
        school: 'University of the Philippines',
        passwordHash: HashUtils.hashPassword(password),
        employeeId: 2024001,
      );
    }
    
    return null;
  }
}
