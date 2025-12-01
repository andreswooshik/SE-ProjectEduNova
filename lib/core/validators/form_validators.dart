import '../constants/app_constants.dart';

/// Form validators following Single Responsibility Principle
/// This class ONLY handles form validation logic
class FormValidators {
  // Private constructor to prevent instantiation
  FormValidators._();

  /// Validates first name field
  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your first name';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  /// Validates last name field
  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your last name';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  /// Validates email field
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    // Basic email regex pattern
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates school/university field
  static String? validateSchool(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your school/university';
    }
    return null;
  }

  /// Validates school ID (must be a positive integer)
  static String? validateSchoolId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your school ID';
    }
    final id = int.tryParse(value.trim());
    if (id == null) {
      return 'School ID must be a number';
    }
    if (id <= 0) {
      return 'School ID must be a positive number';
    }
    return null;
  }

  /// Validates employee ID (must be a positive integer)
  static String? validateEmployeeId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your employee ID';
    }
    final id = int.tryParse(value.trim());
    if (id == null) {
      return 'Employee ID must be a number';
    }
    if (id <= 0) {
      return 'Employee ID must be a positive number';
    }
    return null;
  }

  /// Validates password field
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  /// Validates confirm password field
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
