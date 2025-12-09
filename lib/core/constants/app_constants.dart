/// App-wide constants following Single Responsibility Principle
/// This class only handles constant values used throughout the app
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Info
  static const String appName = 'EduNova';
  static const String appTagline = 'The Platform for curated learning resources';

  // Colors (as hex values)
  static const int primaryColorValue = 0xFF6A4C93;
  static const int secondaryColorValue = 0xFF7FFFD4;
  static const int textPrimaryValue = 0xFF2C3E50;
  static const int textSecondaryValue = 0xFF5A6C7D;
  static const int accentColorValue = 0xFF9B7EBD;
  static const int pinkButtonValue = 0xFFFF69B4;

  // Validation
  static const int minPasswordLength = 6;
  static const int minIdLength = 1;

  // Storage Keys
  static const String currentUserKey = 'current_user';
  static const String usersListKey = 'users_list';
  static const String coursesListKey = 'courses_list';
  static const String isLoggedInKey = 'is_logged_in';
  static const String storagePrefix = 'edunova_'; // Storage prefix for all keys
}

/// User roles enumeration
enum UserRole {
  student,
  teacher,
  admin,
}
