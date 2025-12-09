import '../models/user.dart';
import '../core/utils/hash_utils.dart';

/// Service responsible for admin authentication
/// Single Responsibility Principle: Encapsulates admin logic
class AdminAuthService {
  /// Authenticate admin user
  User? authenticate(String email, String password) {
    // In a real app, this might check against a secure config or separate DB
    if (email == 'admin@edunova.ph' && password == 'admin123') {
      return Admin(
        id: 'admin-001',
        firstName: 'System',
        lastName: 'Admin',
        email: email,
        passwordHash: HashUtils.hashPassword(password),
      );
    }
    return null;
  }
}
