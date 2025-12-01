import '../../models/university.dart';

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

  /// List of Cebu City Universities
  /// Open/Closed Principle: Easy to add more universities without modifying existing code
  static const List<University> universities = [
    University(
      id: 'usjr',
      name: 'University of San Jose-Recoletos',
      shortName: 'USJR',
      emailDomain: 'usjr.edu.ph',
    ),
    University(
      id: 'uc',
      name: 'University of Cebu',
      shortName: 'UC',
      emailDomain: 'uc.edu.ph',
    ),
    University(
      id: 'citu',
      name: 'Cebu Institute of Technology - University',
      shortName: 'CIT-U',
      emailDomain: 'cit.edu.ph',
    ),
    University(
      id: 'upcebu',
      name: 'University of the Philippines Cebu',
      shortName: 'UP Cebu',
      emailDomain: 'up.edu.ph',
    ),
    University(
      id: 'cnu',
      name: 'Cebu Normal University',
      shortName: 'CNU',
      emailDomain: 'cnu.edu.ph',
    ),
    University(
      id: 'usc',
      name: 'University of San Carlos',
      shortName: 'USC',
      emailDomain: 'usc.edu.ph',
    ),
    University(
      id: 'swu',
      name: 'Southwestern University PHINMA',
      shortName: 'SWU',
      emailDomain: 'swu.edu.ph',
    ),
    University(
      id: 'ctu',
      name: 'Cebu Technological University',
      shortName: 'CTU',
      emailDomain: 'ctu.edu.ph',
    ),
    University(
      id: 'uv',
      name: 'University of the Visayas',
      shortName: 'UV',
      emailDomain: 'uv.edu.ph',
    ),
    University(
      id: 'cdu',
      name: "Cebu Doctors' University",
      shortName: 'CDU',
      emailDomain: 'cdu.edu.ph',
    ),
  ];

  /// Get university by ID
  static University? getUniversityById(String id) {
    try {
      return universities.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// User roles enumeration
enum UserRole {
  student,
  teacher,
}
