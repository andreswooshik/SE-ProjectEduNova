import 'package:flutter/material.dart';

/// Assignment model representing a course assignment
class Assignment {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final int maxPoints;
  final String courseId;
  final String courseName;
  final DateTime createdAt;
  final AssignmentStatus status;
  final int? submittedScore;
  final DateTime? submittedAt;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.courseId,
    required this.courseName,
    this.maxPoints = 100,
    DateTime? createdAt,
    this.status = AssignmentStatus.pending,
    this.submittedScore,
    this.submittedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isOverdue =>
      DateTime.now().isAfter(dueDate) && status == AssignmentStatus.pending;
  bool get isSubmitted =>
      status == AssignmentStatus.submitted || status == AssignmentStatus.graded;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'maxPoints': maxPoints,
      'courseId': courseId,
      'courseName': courseName,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'submittedScore': submittedScore,
      'submittedAt': submittedAt?.toIso8601String(),
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      maxPoints: json['maxPoints'] as int? ?? 100,
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      status: AssignmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AssignmentStatus.pending,
      ),
      submittedScore: json['submittedScore'] as int?,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : null,
    );
  }

  Assignment copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    int? maxPoints,
    String? courseId,
    String? courseName,
    DateTime? createdAt,
    AssignmentStatus? status,
    int? submittedScore,
    DateTime? submittedAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      maxPoints: maxPoints ?? this.maxPoints,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      submittedScore: submittedScore ?? this.submittedScore,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}

enum AssignmentStatus {
  pending,
  submitted,
  graded,
  overdue,
}
