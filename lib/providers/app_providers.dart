import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';
import '../services/user_storage_service.dart';
import '../services/course_storage_service.dart';
import '../services/module_storage_service.dart';
import '../services/file_storage_service.dart';
import '../services/admin_auth_service.dart';
import '../services/email_role_detector_service.dart';
import '../services/module_management_service.dart';
import '../services/interfaces/i_storage_service.dart';
import '../services/interfaces/i_user_storage_service.dart';
import '../services/interfaces/i_course_storage_service.dart';
import '../services/interfaces/i_module_storage_service.dart';
import '../services/interfaces/i_file_storage_service.dart';
import '../services/interfaces/i_email_role_detector.dart';
import '../repositories/auth_repository.dart';
import '../repositories/course_repository.dart';
import '../repositories/module_repository.dart';
import '../repositories/interfaces/i_auth_repository.dart';
import '../repositories/interfaces/i_course_repository.dart';
import '../repositories/interfaces/i_module_repository.dart';
import '../models/module.dart';
import 'auth_provider.dart' show AuthNotifier, AuthState;
import 'courses_provider.dart' show CoursesNotifier, CoursesState;
import 'module_provider.dart' show ModuleNotifier, ModuleState;

// ==================== SERVICE PROVIDERS ====================

/// Local storage service provider (Singleton)
/// Dependency Inversion: Provides abstraction for storage
final localStorageServiceProvider = Provider<IStorageService>((ref) {
  return LocalStorageService();
});

/// User storage service provider
final userStorageServiceProvider = Provider<IUserStorageService>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return UserStorageService(storageService);
});

/// Course storage service provider
final courseStorageServiceProvider = Provider<ICourseStorageService>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return CourseStorageService(storageService);
});

/// Module storage service provider
final moduleStorageServiceProvider = Provider<IModuleStorageService>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return ModuleStorageService(storageService);
});

/// File storage service provider
final fileStorageServiceProvider = Provider<IFileStorageService>((ref) {
  return FileStorageService();
});

/// Admin auth service provider
final adminAuthServiceProvider = Provider<AdminAuthService>((ref) {
  return AdminAuthService();
});

/// Email role detector service provider
final emailRoleDetectorServiceProvider = Provider<IEmailRoleDetector>((ref) {
  return EmailRoleDetectorService();
});

/// Module management service provider
final moduleManagementServiceProvider = Provider<ModuleManagementService>((ref) {
  final moduleRepository = ref.watch(moduleRepositoryProvider);
  final fileStorageService = ref.watch(fileStorageServiceProvider);
  return ModuleManagementService(moduleRepository, fileStorageService);
});

// ==================== REPOSITORY PROVIDERS ====================

/// Auth repository provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  final userStorageService = ref.watch(userStorageServiceProvider);
  final adminAuthService = ref.watch(adminAuthServiceProvider);
  return AuthRepository(storageService, userStorageService, adminAuthService);
});

/// Course repository provider
final courseRepositoryProvider = Provider<ICourseRepository>((ref) {
  final courseStorageService = ref.watch(courseStorageServiceProvider);
  // Note: moduleRepository is injected later to avoid circular dependency
  return CourseRepository(courseStorageService);
});

/// Module repository provider
final moduleRepositoryProvider = Provider<IModuleRepository>((ref) {
  final moduleStorageService = ref.watch(moduleStorageServiceProvider);
  final fileStorageService = ref.watch(fileStorageServiceProvider);
  final courseRepository = ref.watch(courseRepositoryProvider);
  return ModuleRepository(
    moduleStorageService,
    fileStorageService,
    courseRepository,
  );
});

// ==================== STATE NOTIFIER PROVIDERS ====================

/// Auth state notifier provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Courses state notifier provider
final coursesProvider = NotifierProvider<CoursesNotifier, CoursesState>(
  CoursesNotifier.new,
);

/// Module state notifier provider
final moduleProvider = NotifierProvider<ModuleNotifier, ModuleState>(
  ModuleNotifier.new,
);

// ==================== COMPUTED/DERIVED PROVIDERS ====================

/// Get modules for a specific course
final modulesForCourseProvider = FutureProvider.family<List<Module>, String>((ref, courseId) async {
  final moduleRepository = ref.watch(moduleRepositoryProvider);
  return await moduleRepository.getModulesByCourseId(courseId);
});

/// Get published modules for a specific course (student view)
final publishedModulesProvider = FutureProvider.family<List<Module>, String>((ref, courseId) async {
  final moduleRepository = ref.watch(moduleRepositoryProvider);
  return await moduleRepository.getPublishedModules(courseId);
});

/// Get a specific module by ID
final moduleByIdProvider = FutureProvider.family<Module?, String>((ref, moduleId) async {
  final moduleRepository = ref.watch(moduleRepositoryProvider);
  return await moduleRepository.getModuleById(moduleId);
});

// ==================== HELPER PROVIDERS ====================

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});

/// Provider to get current user
final currentUserProvider = Provider((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

/// Provider to check if current user is a teacher
final isTeacherProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role.name == 'teacher';
});

/// Provider to check if current user is a student
final isStudentProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role.name == 'student';
});

/// Provider to check if current user is an admin
final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.role.name == 'admin';
});
