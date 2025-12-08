import '../core/constants/app_constants.dart';

/// Base User class following Liskov Substitution Principle
/// Student and Teacher can be used wherever User is expected
abstract class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String school;
  final String passwordHash;
  final UserRole role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.school,
    required this.passwordHash,
    required this.role,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Abstract getter for role-specific institution ID
  /// Liskov Substitution: Both Student and Teacher must implement this
  int get institutionId;

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Convert to JSON map (for storage)
  Map<String, dynamic> toJson();

  /// Factory constructor to create User from JSON
  static User fromJson(Map<String, dynamic> json) {
    final role = UserRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => UserRole.student,
    );

    if (role == UserRole.student) {
      return Student.fromJson(json);
    } else if (role == UserRole.teacher) {
      return Teacher.fromJson(json);
    } else {
      return Admin.fromJson(json);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Student class extending User
/// Follows Liskov Substitution Principle
class Student extends User {
  final int schoolId;

  Student({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.school,
    required super.passwordHash,
    required this.schoolId,
    super.createdAt,
  }) : super(role: UserRole.student);

  @override
  int get institutionId => schoolId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'school': school,
      'passwordHash': passwordHash,
      'role': role.name,
      'schoolId': schoolId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      school: json['school'] as String,
      passwordHash: json['passwordHash'] as String,
      schoolId: json['schoolId'] as int,
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
    );
  }

  Student copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? school,
    String? passwordHash,
    int? schoolId,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      school: school ?? this.school,
      passwordHash: passwordHash ?? this.passwordHash,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Teacher class extending User
/// Follows Liskov Substitution Principle
class Teacher extends User {
  final int employeeId;

  Teacher({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.school,
    required super.passwordHash,
    required this.employeeId,
    super.createdAt,
  }) : super(role: UserRole.teacher);

  @override
  int get institutionId => employeeId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'school': school,
      'passwordHash': passwordHash,
      'role': role.name,
      'employeeId': employeeId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      school: json['school'] as String,
      passwordHash: json['passwordHash'] as String,
      employeeId: json['employeeId'] as int,
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
    );
  }

  Teacher copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? school,
    String? passwordHash,
    int? employeeId,
    DateTime? createdAt,
  }) {
    return Teacher(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      school: school ?? this.school,
      passwordHash: passwordHash ?? this.passwordHash,
      employeeId: employeeId ?? this.employeeId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Admin class extending User
class Admin extends User {
  Admin({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.passwordHash,
    super.createdAt,
  }) : super(
          school: 'EduNova Administration',
          role: UserRole.admin,
        );

  @override
  int get institutionId => 0;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'school': school,
      'passwordHash': passwordHash,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
    );
  }
}
