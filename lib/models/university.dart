/// University model representing educational institutions
/// Following Single Responsibility Principle - only handles university data
class University {
  final String id;
  final String name;
  final String shortName;
  final String emailDomain;

  const University({
    required this.id,
    required this.name,
    required this.shortName,
    required this.emailDomain,
  });

  /// Display name for dropdown: "USJR - University of San Jose-Recoletos"
  String get displayName => '$shortName - $name';

  /// Email hint text: "Use your @usjr.edu.ph email"
  String get emailHint => 'Use your @$emailDomain email';

  /// Validates if an email belongs to this university's domain
  bool isValidEmailDomain(String email) {
    final emailLower = email.toLowerCase().trim();
    return emailLower.endsWith('@$emailDomain');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is University && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'University($shortName)';
}
