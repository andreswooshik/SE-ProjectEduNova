/// Module model following Single Responsibility Principle
/// This class represents a course module containing learning resources
class Module {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order;
  final List<ModuleResource> resources;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final bool isPublished;

  Module({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.order,
    List<ModuleResource>? resources,
    DateTime? createdAt,
    this.updatedAt,
    required this.createdBy,
    this.isPublished = false,
  })  : resources = resources ?? [],
        createdAt = createdAt ?? DateTime.now();

  /// Convert to JSON map (for storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'order': order,
      'resources': resources.map((r) => r.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'isPublished': isPublished,
    };
  }

  /// Create Module from JSON
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
      resources: (json['resources'] as List<dynamic>?)
              ?.map((r) => ModuleResource.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      createdBy: json['createdBy'] as String,
      isPublished: json['isPublished'] as bool? ?? false,
    );
  }

  /// Copy with method for immutability (Open/Closed Principle)
  Module copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    int? order,
    List<ModuleResource>? resources,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isPublished,
  }) {
    return Module(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      resources: resources ?? this.resources,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Module && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Module resource model representing files attached to a module
class ModuleResource {
  final String id;
  final String moduleId;
  final String title;
  final String description;
  final ResourceType type;
  final String filePath;
  final int fileSizeBytes;
  final String? thumbnailPath;
  final DateTime uploadedAt;
  final String uploadedBy;

  ModuleResource({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.type,
    required this.filePath,
    required this.fileSizeBytes,
    this.thumbnailPath,
    DateTime? uploadedAt,
    required this.uploadedBy,
  }) : uploadedAt = uploadedAt ?? DateTime.now();

  /// Get human-readable file size
  String get fileSizeFormatted {
    if (fileSizeBytes < 1024) {
      return '$fileSizeBytes B';
    } else if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    } else if (fileSizeBytes < 1024 * 1024 * 1024) {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Convert to JSON map (for storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'title': title,
      'description': description,
      'type': type.name,
      'filePath': filePath,
      'fileSizeBytes': fileSizeBytes,
      'thumbnailPath': thumbnailPath,
      'uploadedAt': uploadedAt.toIso8601String(),
      'uploadedBy': uploadedBy,
    };
  }

  /// Create ModuleResource from JSON
  factory ModuleResource.fromJson(Map<String, dynamic> json) {
    return ModuleResource(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: ResourceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ResourceType.other,
      ),
      filePath: json['filePath'] as String,
      fileSizeBytes: json['fileSizeBytes'] as int,
      thumbnailPath: json['thumbnailPath'] as String?,
      uploadedAt: DateTime.tryParse(json['uploadedAt'] ?? ''),
      uploadedBy: json['uploadedBy'] as String,
    );
  }

  /// Copy with method for immutability
  ModuleResource copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? description,
    ResourceType? type,
    String? filePath,
    int? fileSizeBytes,
    String? thumbnailPath,
    DateTime? uploadedAt,
    String? uploadedBy,
  }) {
    return ModuleResource(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleResource &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Resource type enumeration
enum ResourceType {
  pdf,
  pptx,
  docx,
  xlsx,
  image,
  video,
  audio,
  link,
  other;

  /// Get display name for the resource type
  String get displayName {
    switch (this) {
      case ResourceType.pdf:
        return 'PDF';
      case ResourceType.pptx:
        return 'PowerPoint';
      case ResourceType.docx:
        return 'Word Document';
      case ResourceType.xlsx:
        return 'Excel Spreadsheet';
      case ResourceType.image:
        return 'Image';
      case ResourceType.video:
        return 'Video';
      case ResourceType.audio:
        return 'Audio';
      case ResourceType.link:
        return 'Link';
      case ResourceType.other:
        return 'Other';
    }
  }

  /// Get file extension for the resource type
  List<String> get extensions {
    switch (this) {
      case ResourceType.pdf:
        return ['pdf'];
      case ResourceType.pptx:
        return ['ppt', 'pptx'];
      case ResourceType.docx:
        return ['doc', 'docx'];
      case ResourceType.xlsx:
        return ['xls', 'xlsx'];
      case ResourceType.image:
        return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
      case ResourceType.video:
        return ['mp4', 'mov', 'avi', 'mkv', 'webm'];
      case ResourceType.audio:
        return ['mp3', 'wav', 'ogg', 'm4a'];
      case ResourceType.link:
        return [];
      case ResourceType.other:
        return [];
    }
  }

  /// Get resource type from file extension
  static ResourceType fromExtension(String extension) {
    final ext = extension.toLowerCase().replaceAll('.', '');
    for (final type in ResourceType.values) {
      if (type.extensions.contains(ext)) {
        return type;
      }
    }
    return ResourceType.other;
  }
}
