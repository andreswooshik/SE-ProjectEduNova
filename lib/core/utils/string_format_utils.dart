/// String formatting utilities
/// Single Responsibility Principle: Only handles string formatting operations
class StringFormatUtils {
  // Private constructor to prevent instantiation
  StringFormatUtils._();

  /// Formats field name for error messages
  /// Converts camelCase or snake_case to readable format
  /// 
  /// Examples:
  /// - "username" -> "username"
  /// - "email" -> "email"
  /// - "firstName" -> "first name"
  /// - "email_address" -> "email address"
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

  /// Capitalizes the first letter of a string
  /// 
  /// Example: "hello world" -> "Hello world"
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Converts a string to title case
  /// 
  /// Example: "hello world" -> "Hello World"
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Converts camelCase or PascalCase to human-readable format
  /// 
  /// Example: "firstName" -> "first name"
  static String camelCaseToWords(String text) {
    if (text.isEmpty) return text;
    
    return text.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)!.toLowerCase()}',
    ).trim();
  }

  /// Truncates text to specified length with ellipsis
  /// 
  /// Example: truncate("Hello World", 8) -> "Hello..."
  static String truncate(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    
    final cutOff = maxLength - ellipsis.length;
    if (cutOff <= 0) return ellipsis;
    
    return text.substring(0, cutOff) + ellipsis;
  }
}
