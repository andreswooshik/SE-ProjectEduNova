import 'package:flutter/material.dart';

/// Course Analytics Model
/// Single Responsibility: Represents analytics data for a course
class CourseAnalytics {
  final String courseId;
  final int enrollmentCount;
  final double completionRate;
  final double averageGrade;
  final int activeStudents;
  final int totalAssignments;
  final int submittedAssignments;
  final Map<String, int> resourceViews;
  final DateTime lastUpdated;

  CourseAnalytics({
    required this.courseId,
    required this.enrollmentCount,
    required this.completionRate,
    required this.averageGrade,
    required this.activeStudents,
    required this.totalAssignments,
    required this.submittedAssignments,
    required this.resourceViews,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'enrollmentCount': enrollmentCount,
      'completionRate': completionRate,
      'averageGrade': averageGrade,
      'activeStudents': activeStudents,
      'totalAssignments': totalAssignments,
      'submittedAssignments': submittedAssignments,
      'resourceViews': resourceViews,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory CourseAnalytics.fromJson(Map<String, dynamic> json) {
    return CourseAnalytics(
      courseId: json['courseId'] as String,
      enrollmentCount: json['enrollmentCount'] as int,
      completionRate: (json['completionRate'] as num).toDouble(),
      averageGrade: (json['averageGrade'] as num).toDouble(),
      activeStudents: json['activeStudents'] as int,
      totalAssignments: json['totalAssignments'] as int,
      submittedAssignments: json['submittedAssignments'] as int,
      resourceViews: Map<String, int>.from(json['resourceViews'] as Map),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

/// Resource Model
/// Single Responsibility: Represents a course resource
class CourseResource {
  final String id;
  final String title;
  final String description;
  final ResourceType type;
  final String? url;
  final String? filePath;
  final int viewCount;
  final int downloadCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final List<String> tags;

  CourseResource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.url,
    this.filePath,
    this.viewCount = 0,
    this.downloadCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.version = 1,
    List<String>? tags,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        tags = tags ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'url': url,
      'filePath': filePath,
      'viewCount': viewCount,
      'downloadCount': downloadCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
      'tags': tags,
    };
  }

  factory CourseResource.fromJson(Map<String, dynamic> json) {
    return CourseResource(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: ResourceType.values.firstWhere((e) => e.name == json['type']),
      url: json['url'] as String?,
      filePath: json['filePath'] as String?,
      viewCount: json['viewCount'] as int? ?? 0,
      downloadCount: json['downloadCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: json['version'] as int? ?? 1,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  CourseResource copyWith({
    String? title,
    String? description,
    int? viewCount,
    int? downloadCount,
    int? version,
    List<String>? tags,
  }) {
    return CourseResource(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type,
      url: url,
      filePath: filePath,
      viewCount: viewCount ?? this.viewCount,
      downloadCount: downloadCount ?? this.downloadCount,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      version: version ?? this.version,
      tags: tags ?? this.tags,
    );
  }
}

enum ResourceType {
  pdf,
  video,
  audio,
  document,
  link,
  zip,
  image,
  presentation,
}

/// Course Status Enum
enum CourseStatus {
  draft,
  published,
  archived,
  ongoing,
}

/// Course Category Enum
enum CourseCategory {
  programming,
  design,
  business,
  marketing,
  science,
  mathematics,
  language,
  cybersecurity,
  other,
}
