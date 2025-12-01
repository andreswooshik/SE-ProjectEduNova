/// Course model following Single Responsibility Principle
/// This class only represents course data
class Course {
  final String id;
  final String title;
  final String description;
  final String teacherId;
  final List<String> enrolledStudentIds;
  final List<CourseMaterial> materials;
  final List<Assignment> assignments;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.teacherId,
    List<String>? enrolledStudentIds,
    List<CourseMaterial>? materials,
    List<Assignment>? assignments,
    DateTime? createdAt,
    this.updatedAt,
  })  : enrolledStudentIds = enrolledStudentIds ?? [],
        materials = materials ?? [],
        assignments = assignments ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teacherId': teacherId,
      'enrolledStudentIds': enrolledStudentIds,
      'materials': materials.map((m) => m.toJson()).toList(),
      'assignments': assignments.map((a) => a.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      teacherId: json['teacherId'] as String,
      enrolledStudentIds: List<String>.from(json['enrolledStudentIds'] ?? []),
      materials: (json['materials'] as List<dynamic>?)
              ?.map((m) => CourseMaterial.fromJson(m))
              .toList() ??
          [],
      assignments: (json['assignments'] as List<dynamic>?)
              ?.map((a) => Assignment.fromJson(a))
              .toList() ??
          [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? teacherId,
    List<String>? enrolledStudentIds,
    List<CourseMaterial>? materials,
    List<Assignment>? assignments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      teacherId: teacherId ?? this.teacherId,
      enrolledStudentIds: enrolledStudentIds ?? this.enrolledStudentIds,
      materials: materials ?? this.materials,
      assignments: assignments ?? this.assignments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Course material model
class CourseMaterial {
  final String id;
  final String title;
  final String description;
  final String? fileUrl;
  final MaterialType type;
  final DateTime createdAt;

  CourseMaterial({
    required this.id,
    required this.title,
    required this.description,
    this.fileUrl,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CourseMaterial.fromJson(Map<String, dynamic> json) {
    return CourseMaterial(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      fileUrl: json['fileUrl'] as String?,
      type: MaterialType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MaterialType.document,
      ),
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
    );
  }
}

/// Assignment model
class Assignment {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final int maxPoints;
  final DateTime createdAt;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.maxPoints = 100,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'maxPoints': maxPoints,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      maxPoints: json['maxPoints'] as int? ?? 100,
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
    );
  }
}

/// Material type enumeration
enum MaterialType {
  document,
  video,
  audio,
  link,
  image,
}
