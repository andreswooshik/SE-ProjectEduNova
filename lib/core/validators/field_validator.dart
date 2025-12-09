import '../utils/string_format_utils.dart';

/// Interface for field validators
/// Interface Segregation Principle: Specific interface for validation
abstract class IFieldValidator {
  /// Validates a field value
  /// Returns null if valid, error message if invalid
  String? validate(String? value);
}

/// Base class for validators with common functionality
/// Single Responsibility Principle: Only provides base validation utilities
abstract class BaseValidator implements IFieldValidator {
  /// Check if value is empty
  bool isEmpty(String? value) => value == null || value.trim().isEmpty;

  /// Get trimmed value
  String? getTrimmed(String? value) => value?.trim();
}

/// Email validator
/// Single Responsibility Principle: Only validates email format
/// Open/Closed Principle: Can be extended without modification
class EmailValidator extends BaseValidator {
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  String? validate(String? value) {
    if (isEmpty(value)) {
      return 'Please enter your email';
    }
    
    final trimmed = getTrimmed(value)!;
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
}

/// Name validator (for first/last names)
/// Single Responsibility Principle: Only validates name fields
class NameValidator extends BaseValidator {
  final String fieldName;
  final int minLength;

  NameValidator({required this.fieldName, this.minLength = 2});

  @override
  String? validate(String? value) {
    if (isEmpty(value)) {
      return 'Please enter your $fieldName';
    }
    
    final trimmed = getTrimmed(value)!;
    if (trimmed.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    
    return null;
  }
}

/// Password validator with configurable rules
/// Single Responsibility Principle: Only validates passwords
/// Open/Closed Principle: Rules can be extended
class PasswordValidator extends BaseValidator {
  final int minLength;
  final bool requireLetters;
  final bool requireNumbers;
  final bool requireSpecialChars;

  PasswordValidator({
    required this.minLength,
    this.requireLetters = false,
    this.requireNumbers = false,
    this.requireSpecialChars = false,
  });

  @override
  String? validate(String? value) {
    if (isEmpty(value)) {
      return 'Please enter a password';
    }

    if (value!.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (requireLetters && !RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }

    if (requireNumbers && !RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    if (requireSpecialChars && !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }
}

/// Confirm password validator
/// Single Responsibility Principle: Only validates password confirmation
class ConfirmPasswordValidator extends BaseValidator {
  final String password;

  ConfirmPasswordValidator(this.password);

  @override
  String? validate(String? value) {
    if (isEmpty(value)) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
}

/// URL validator
/// Single Responsibility Principle: Only validates URLs
class UrlValidator extends BaseValidator {
  final bool required;
  final RegExp _urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  UrlValidator({this.required = true});

  @override
  String? validate(String? value) {
    if (!required && isEmpty(value)) {
      return null;
    }

    if (required && isEmpty(value)) {
      return 'Please enter a URL';
    }

    final trimmed = getTrimmed(value)!;
    if (!_urlRegex.hasMatch(trimmed)) {
      return 'Please enter a valid URL (must start with http:// or https://)';
    }

    return null;
  }
}

/// Length validator for generic text fields
/// Single Responsibility Principle: Only validates length constraints
class LengthValidator extends BaseValidator {
  final String fieldName;
  final int? minLength;
  final int? maxLength;
  final bool required;

  LengthValidator({
    required this.fieldName,
    this.minLength,
    this.maxLength,
    this.required = true,
  });

  @override
  String? validate(String? value) {
    // Use shared utility (DRY principle)
    final formattedName = StringFormatUtils.formatFieldName(fieldName);

    if (required && isEmpty(value)) {
      return 'Please enter $formattedName';
    }

    if (!isEmpty(value)) {
      final trimmed = getTrimmed(value);
      // Safe null check before using value
      if (trimmed != null) {
        if (minLength != null && trimmed.length < minLength) {
          return '${StringFormatUtils.capitalizeFirst(formattedName)} must be at least $minLength characters';
        }
        
        if (maxLength != null && trimmed.length > maxLength) {
          return '${StringFormatUtils.capitalizeFirst(formattedName)} must not exceed $maxLength characters';
        }
      }
    }

    return null;
  }
}

/// Composite validator that runs multiple validators
/// Open/Closed Principle: Can combine validators without modifying them
/// Liskov Substitution Principle: Can be used wherever IFieldValidator is expected
class CompositeValidator implements IFieldValidator {
  final List<IFieldValidator> validators;

  CompositeValidator(this.validators);

  @override
  String? validate(String? value) {
    for (final validator in validators) {
      final error = validator.validate(value);
      if (error != null) {
        return error; // Return first error found
      }
    }
    return null;
  }
}

/// Factory for creating common validators
/// Single Responsibility Principle: Only creates validator instances
/// Dependency Inversion Principle: Returns abstractions (IFieldValidator)
class ValidatorFactory {
  /// Create email validator
  static IFieldValidator email() => EmailValidator();

  /// Create first name validator
  static IFieldValidator firstName() => NameValidator(fieldName: 'first name');

  /// Create last name validator
  static IFieldValidator lastName() => NameValidator(fieldName: 'last name');

  /// Create basic password validator (length only)
  static IFieldValidator passwordBasic(int minLength) {
    return PasswordValidator(minLength: minLength);
  }

  /// Create strong password validator
  static IFieldValidator passwordStrong(int minLength) {
    return PasswordValidator(
      minLength: minLength,
      requireLetters: true,
      requireNumbers: true,
    );
  }

  /// Create password confirmation validator
  static IFieldValidator confirmPassword(String password) {
    return ConfirmPasswordValidator(password);
  }

  /// Create URL validator
  static IFieldValidator url({bool required = true}) {
    return UrlValidator(required: required);
  }

  /// Create generic text field validator
  static IFieldValidator textField({
    required String fieldName,
    int? minLength,
    int? maxLength,
    bool required = true,
  }) {
    return LengthValidator(
      fieldName: fieldName,
      minLength: minLength,
      maxLength: maxLength,
      required: required,
    );
  }

  /// Create composite validator from multiple validators
  static IFieldValidator composite(List<IFieldValidator> validators) {
    return CompositeValidator(validators);
  }
}
