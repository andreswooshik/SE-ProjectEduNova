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

  /// Validates password field with enhanced security
  /// 
  /// Enforces strong password requirements:
  /// - Minimum length requirement
  /// - At least one letter
  /// - At least one number
  /// 
  /// For basic validation without complexity requirements, use [validatePasswordBasic].
  static String? validatePassword(String? value, {bool enforceComplexity = true}) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    
    if (enforceComplexity) {
      // Check for at least one letter
      if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
        return 'Password must contain at least one letter';
      }
      // Check for at least one number
      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return 'Password must contain at least one number';
      }
    }
    
    return null;
  }

  /// Validates password field with basic requirement (for backward compatibility)
  /// 
  /// Only checks for minimum length. For enhanced security validation,
  /// use [validatePassword] with enforceComplexity parameter.
  static String? validatePasswordBasic(String? value) {
    return validatePassword(value, enforceComplexity: false);
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
  /// 
  /// A flexible validator for various text input fields with customizable constraints.
  /// 
  /// Parameters:
  /// - [value]: The text to validate
  /// - [fieldName]: Human-readable field name for error messages (e.g., 'username', 'title')
  /// - [minLength]: Minimum required length (optional)
  /// - [maxLength]: Maximum allowed length (optional)
  /// - [required]: Whether the field is required (default: true)
  /// 
  /// Returns: Error message or null if valid
  /// 
  /// Example:
  /// ```dart
  /// validateTextField('John', fieldName: 'username', minLength: 3, maxLength: 20)
  /// ```
  static String? validateTextField(String? value, {
    required String fieldName,
    int? minLength,
    int? maxLength,
    bool required = true,
  }) {
    // Properly format field name for error messages
    final formattedFieldName = _formatFieldName(fieldName);
    
    if (required && (value == null || value.trim().isEmpty)) {
      return 'Please enter $formattedFieldName';
    }
    
    if (value != null && value.trim().isNotEmpty) {
      if (minLength != null && value.trim().length < minLength) {
        return '${_capitalizeFirst(formattedFieldName)} must be at least $minLength characters';
      }
      if (maxLength != null && value.trim().length > maxLength) {
        return '${_capitalizeFirst(formattedFieldName)} must not exceed $maxLength characters';
      }
    }
    
    return null;
  }

  /// Formats field name for error messages with proper article
  static String _formatFieldName(String fieldName) {
    final lowercase = fieldName.toLowerCase();
    // Check if needs article 'a' or 'an'
    final needsArticle = !lowercase.startsWith(RegExp(r'^(the|your|a |an )'));
    
    if (!needsArticle) return lowercase;
    
    // Use 'an' for vowel sounds, 'a' for consonants
    final startsWithVowel = RegExp(r'^[aeiou]', caseSensitive: false).hasMatch(lowercase);
    return startsWithVowel ? 'an $lowercase' : 'a $lowercase';
  }

  /// Capitalizes the first letter of a string
  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
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
