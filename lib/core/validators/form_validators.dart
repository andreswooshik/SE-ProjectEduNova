import '../constants/app_constants.dart';
import '../../models/university.dart';

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

  /// Validates email field (basic format check)
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

  /// Validates email with university domain check
  /// Returns error message if email doesn't match the university domain
  static String? validateEmailWithUniversity(String? value, University? university) {
    // First, validate basic email format
    final basicValidation = validateEmail(value);
    if (basicValidation != null) {
      return basicValidation;
    }

    // Check if university is selected
    if (university == null) {
      return 'Please select a university first';
    }

    // Validate email domain matches university
    if (!university.isValidEmailDomain(value!)) {
      return 'Email must be from @${university.emailDomain} domain';
    }

    return null;
  }

  /// Validates university selection
  static String? validateUniversity(University? value) {
    if (value == null) {
      return 'Please select your university';
    }
    return null;
  }

  /// Validates school/university field (legacy - kept for backwards compatibility)
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
    // Check for at least one letter
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }
    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Validates password field with basic requirement (for backward compatibility)
  static String? validatePasswordBasic(String? value) {
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

  /// Validates module title
  static String? validateModuleTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a module title';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.trim().length > 100) {
      return 'Title must not exceed 100 characters';
    }
    return null;
  }

  /// Validates description fields
  static String? validateDescription(String? value, {bool required = false}) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'Please enter a description';
    }
    if (value != null && value.trim().length > 500) {
      return 'Description must not exceed 500 characters';
    }
    return null;
  }

  /// Validates course title
  static String? validateCourseTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a course title';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    if (value.trim().length > 100) {
      return 'Title must not exceed 100 characters';
    }
    return null;
  }

  /// Validates general text input
  static String? validateTextField(String? value, {
    required String fieldName,
    int? minLength,
    int? maxLength,
    bool required = true,
  }) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'Please enter $fieldName';
    }
    
    if (value != null && value.trim().isNotEmpty) {
      if (minLength != null && value.trim().length < minLength) {
        return '$fieldName must be at least $minLength characters';
      }
      if (maxLength != null && value.trim().length > maxLength) {
        return '$fieldName must not exceed $maxLength characters';
      }
    }
    
    return null;
  }

  /// Validates URL format
  static String? validateUrl(String? value, {bool required = false}) {
    if (!required && (value == null || value.trim().isEmpty)) {
      return null;
    }
    
    if (required && (value == null || value.trim().isEmpty)) {
      return 'Please enter a URL';
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value!.trim())) {
      return 'Please enter a valid URL (must start with http:// or https://)';
    }
    
    return null;
  }
}
