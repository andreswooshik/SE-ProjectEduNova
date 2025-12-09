import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/interfaces/i_auth_repository.dart';
import '../repositories/auth_repository.dart';
import '../services/interfaces/i_storage_service.dart';
import '../services/interfaces/i_user_storage_service.dart';
import '../services/interfaces/i_email_role_detector.dart';
import '../services/local_storage_service.dart';
import '../services/user_storage_service.dart';
import '../services/admin_auth_service.dart';
import '../services/email_role_detector_service.dart';
import '../core/constants/app_constants.dart';

/// Storage service provider
/// Dependency Inversion: Provides abstraction, not concrete implementation
final storageServiceProvider = Provider<IStorageService>((ref) {
  return LocalStorageService();
});

/// User storage service provider
final userStorageServiceProvider = Provider<IUserStorageService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return UserStorageService(storageService);
});

/// Admin auth service provider
final adminAuthServiceProvider = Provider<AdminAuthService>((ref) {
  return AdminAuthService();
});

/// Email role detector service provider
/// Dependency Inversion: Depends on abstraction
final emailRoleDetectorProvider = Provider<IEmailRoleDetector>((ref) {
  return EmailRoleDetectorService();
});

/// Auth repository provider
/// Dependency Inversion: Depends on abstractions
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final userStorageService = ref.watch(userStorageServiceProvider);
  final adminAuthService = ref.watch(adminAuthServiceProvider);
  return AuthRepository(storageService, userStorageService, adminAuthService);
});

/// Authentication state
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  /// Initial state
  factory AuthState.initial() => const AuthState();

  /// Loading state
  factory AuthState.loading() => const AuthState(isLoading: true);

  /// Authenticated state
  factory AuthState.authenticated(User user) => AuthState(
        isAuthenticated: true,
        user: user,
      );

  /// Error state
  factory AuthState.error(String message) => AuthState(errorMessage: message);
}

/// Auth state notifier following Single Responsibility Principle
/// Only handles authentication state changes
/// Uses Riverpod 3.x Notifier pattern
class AuthNotifier extends Notifier<AuthState> {
  late IAuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return AuthState.initial();
  }

  /// Check if user is already logged in (on app start)
  Future<void> checkAuthStatus() async {
    state = AuthState.loading();
    
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          state = AuthState.authenticated(user);
          return;
        }
      }
      state = AuthState.initial();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    state = AuthState.loading();

    try {
      final user = await _authRepository.signIn(email, password);
      if (user != null) {
        state = AuthState.authenticated(user);
        return true;
      } else {
        state = AuthState.error('Invalid email or password');
        return false;
      }
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Register a new student
  Future<bool> registerStudent({
    required String firstName,
    required String lastName,
    required String email,
    required String school,
    required int schoolId,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final data = StudentRegistrationData(
        firstName: firstName,
        lastName: lastName,
        email: email,
        school: school,
        schoolId: schoolId,
        password: password,
      );

      final user = await _authRepository.registerStudent(data);
      state = AuthState.authenticated(user);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Register a new teacher
  Future<bool> registerTeacher({
    required String firstName,
    required String lastName,
    required String email,
    required String school,
    required int employeeId,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final data = TeacherRegistrationData(
        firstName: firstName,
        lastName: lastName,
        email: email,
        school: school,
        employeeId: employeeId,
        password: password,
      );

      final user = await _authRepository.registerTeacher(data);
      state = AuthState.authenticated(user);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Register a new user with automatic role detection
  /// Single Responsibility Principle: Delegates role detection to service
  /// Open/Closed Principle: Can add new role detection logic without modifying this method
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String school,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      // Detect role from email using email role detector service
      final emailRoleDetector = ref.read(emailRoleDetectorProvider);
      final detectedRole = emailRoleDetector.detectRole(email);

      // Register based on detected role
      if (detectedRole == UserRole.teacher) {
        // Generate employee ID from timestamp for teachers
        final employeeId = DateTime.now().millisecondsSinceEpoch % 1000000;
        
        return await registerTeacher(
          firstName: firstName,
          lastName: lastName,
          email: email,
          school: school,
          employeeId: employeeId,
          password: password,
        );
      } else {
        // Register as student (default)
        // Generate school ID from timestamp for students
        final schoolId = DateTime.now().millisecondsSinceEpoch % 1000000;
        
        return await registerStudent(
          firstName: firstName,
          lastName: lastName,
          email: email,
          school: school,
          schoolId: schoolId,
          password: password,
        );
      }
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = AuthState.loading();

    try {
      await _authRepository.signOut();
      state = AuthState.initial();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Auth provider using Riverpod 3.x NotifierProvider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

/// Convenience provider to get current user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

/// Convenience provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
