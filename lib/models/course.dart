import 'package:flutter/material.dart';

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

  // New fields for UI display
  final String? thumbnailUrl;
  final String? thumbnailAsset;
  final Color? accentColor;
  final String? instructor;
  final String? progress;

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
    this.thumbnailUrl,
    this.thumbnailAsset,
    this.accentColor,
    this.instructor,
    this.progress,
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
      'thumbnailUrl': thumbnailUrl,
      'thumbnailAsset': thumbnailAsset,
      'accentColor': accentColor?.value,
      'instructor': instructor,
      'progress': progress,
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
      thumbnailUrl: json['thumbnailUrl'] as String?,
      thumbnailAsset: json['thumbnailAsset'] as String?,
      accentColor: json['accentColor'] != null
          ? Color(json['accentColor'] as int)
          : null,
      instructor: json['instructor'] as String?,
      progress: json['progress'] as String?,
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
    String? thumbnailUrl,
    String? thumbnailAsset,
    Color? accentColor,
    String? instructor,
    String? progress,
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
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      accentColor: accentColor ?? this.accentColor,
      instructor: instructor ?? this.instructor,
      progress: progress ?? this.progress,
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
