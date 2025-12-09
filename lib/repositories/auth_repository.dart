import 'dart:convert';
import '../core/constants/app_constants.dart';
import '../models/user.dart';
import '../services/interfaces/i_storage_service.dart';
import '../services/interfaces/i_user_storage_service.dart';
import '../services/admin_auth_service.dart';
import '../core/utils/hash_utils.dart';
import 'interfaces/i_auth_repository.dart';

/// Concrete implementation of IAuthRepository
/// Open/Closed Principle: Can be extended or replaced without modifying clients
class AuthRepository implements IAuthRepository {
  final IStorageService _storageService;
  final IUserStorageService _userStorageService;
  final AdminAuthService _adminAuthService;

  AuthRepository(
    this._storageService,
    this._userStorageService,
    this._adminAuthService,
  );

  @override
  Future<User?> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return null;

    // Admin Account Check
    final admin = _adminAuthService.authenticate(email, password);
    if (admin != null) {
      await _saveSession(admin);
      return admin;
    }

    final user = await _userStorageService.getUserByEmail(email);

    if (user != null && HashUtils.verifyPassword(password, user.passwordHash)) {
      await _saveSession(user);
      return user;
    }
    return null;
  }

  @override
  Future<User> registerStudent(StudentRegistrationData data) async {
    if (await _userStorageService.emailExists(data.email)) {
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

    await _userStorageService.saveUser(student);
    await _saveSession(student);

    return student;
  }

  @override
  Future<User> registerTeacher(TeacherRegistrationData data) async {
    if (await _userStorageService.emailExists(data.email)) {
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

    await _userStorageService.saveUser(teacher);
    await _saveSession(teacher);

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
    return await _userStorageService.emailExists(email);
  }

  Future<void> _saveSession(User user) async {
    await _storageService.saveString(
      AppConstants.currentUserKey,
      jsonEncode(user.toJson()),
    );
    await _storageService.saveBool(AppConstants.isLoggedInKey, true);
  }
}
