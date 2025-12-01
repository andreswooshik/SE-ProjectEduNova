import 'dart:convert';
import '../core/constants/app_constants.dart';
import '../models/user.dart';
import '../services/interfaces/i_storage_service.dart';
import '../core/utils/hash_utils.dart';
import 'interfaces/i_auth_repository.dart';

/// Concrete implementation of IAuthRepository
/// Open/Closed Principle: Can be extended or replaced without modifying clients
class AuthRepository implements IAuthRepository {
  final IStorageService _storageService;

  AuthRepository(this._storageService);

  @override
  Future<User?> signIn(String email, String password) async {
    final users = await _getAllUsers();
    final passwordHash = HashUtils.hashPassword(password);

    try {
      final user = users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && 
               u.passwordHash == passwordHash,
      );

      // Save current user
      await _storageService.saveString(
        AppConstants.currentUserKey,
        jsonEncode(user.toJson()),
      );
      await _storageService.saveBool(AppConstants.isLoggedInKey, true);

      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> registerStudent(StudentRegistrationData data) async {
    // Check if email already exists
    if (await emailExists(data.email)) {
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

    // Save user to storage
    await _saveUser(student);

    // Set as current user
    await _storageService.saveString(
      AppConstants.currentUserKey,
      jsonEncode(student.toJson()),
    );
    await _storageService.saveBool(AppConstants.isLoggedInKey, true);

    return student;
  }

  @override
  Future<User> registerTeacher(TeacherRegistrationData data) async {
    // Check if email already exists
    if (await emailExists(data.email)) {
      throw Exception('Email already registered');
    }

    final teacher = Teacher(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: data.firstName.trim(),
      lastName: data.lastName.trim(),
      email: data.email.trim().toLowerCase(),
      school: data.school.trim(),
      passwordHash: HashUtils.hashPassword(data.password),
      employeeId: data.employeeId,
    );

    // Save user to storage
    await _saveUser(teacher);

    // Set as current user
    await _storageService.saveString(
      AppConstants.currentUserKey,
      jsonEncode(teacher.toJson()),
    );
    await _storageService.saveBool(AppConstants.isLoggedInKey, true);

    return teacher;
  }

  @override
  Future<void> signOut() async {
    await _storageService.remove(AppConstants.currentUserKey);
    await _storageService.saveBool(AppConstants.isLoggedInKey, false);
  }

  @override
  Future<User?> getCurrentUser() async {
    final userJson = await _storageService.getString(AppConstants.currentUserKey);
    if (userJson == null) return null;

    try {
      final Map<String, dynamic> json = jsonDecode(userJson);
      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _storageService.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  @override
  Future<bool> emailExists(String email) async {
    final users = await _getAllUsers();
    return users.any((u) => u.email.toLowerCase() == email.toLowerCase());
  }

  /// Private helper to get all users from storage
  Future<List<User>> _getAllUsers() async {
    final usersJson = await _storageService.getStringList(AppConstants.usersListKey);
    if (usersJson == null || usersJson.isEmpty) return [];

    return usersJson.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return User.fromJson(data);
    }).toList();
  }

  /// Private helper to save a user to storage
  Future<void> _saveUser(User user) async {
    final users = await _getAllUsers();
    users.add(user);

    final usersJson = users.map((u) => jsonEncode(u.toJson())).toList();
    await _storageService.saveStringList(AppConstants.usersListKey, usersJson);
  }
}
