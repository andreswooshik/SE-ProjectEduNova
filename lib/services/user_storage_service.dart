import 'dart:convert';
import '../core/constants/app_constants.dart';
import '../models/user.dart';
import 'interfaces/i_storage_service.dart';
import 'interfaces/i_user_storage_service.dart';

/// Service responsible for user data persistence
/// Single Responsibility Principle: Handles only user storage logic
class UserStorageService implements IUserStorageService {
  final IStorageService _storageService;

  UserStorageService(this._storageService);

  @override
  Future<List<User>> getAllUsers() async {
    final usersJson = await _storageService.getStringList(AppConstants.usersListKey);
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
    await _storageService.saveStringList(AppConstants.usersListKey, usersJson);
  }

  @override
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }
}
