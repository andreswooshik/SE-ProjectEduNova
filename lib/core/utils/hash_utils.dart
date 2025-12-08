import 'package:bcrypt/bcrypt.dart';

/// Utility class for hashing operations
/// Single Responsibility Principle: Only handles hashing logic
class HashUtils {
  // Private constructor to prevent instantiation
  HashUtils._();

  /// Hash a password using Bcrypt
  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Verify a password against a hash
  static bool verifyPassword(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }
}
