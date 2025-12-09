/// Utility class for string formatting operations
/// Single Responsibility Principle: Only handles string formatting
class StringFormatUtils {
  /// Private constructor to prevent instantiation
  StringFormatUtils._();

  /// Formats a field name for display in error messages
  /// Converts camelCase or snake_case to readable format
  /// 
  /// Example:
  /// - 'firstName' -> 'first name'
  /// - 'email_address' -> 'email address'
  /// - 'password' -> 'password'
  static String formatFieldName(String fieldName) {
    if (fieldName.isEmpty) return fieldName;

    // Replace underscores with spaces
    String formatted = fieldName.replaceAll('_', ' ');

    // Insert spaces before capital letters (camelCase)
    formatted = formatted.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    // Convert to lowercase
    return formatted.toLowerCase();
  }

  /// Capitalizes the first character of a string
  /// 
  /// Example:
  /// - 'hello' -> 'Hello'
  /// - 'first name' -> 'First name'
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Converts a string to title case (capitalizes first letter of each word)
  /// 
  /// Example:
  /// - 'hello world' -> 'Hello World'
  /// - 'first name' -> 'First Name'
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
