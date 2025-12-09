import '../../models/user.dart';

/// Interface for user storage operations
/// Interface Segregation Principle: Specific interface for user data access
abstract class IUserStorageService {
  Future<List<User>> getAllUsers();
  Future<User?> getUserByEmail(String email);
  Future<void> saveUser(User user);
  Future<bool> emailExists(String email);
}
