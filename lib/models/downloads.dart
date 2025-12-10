/// Download item model representing downloadable content
class DownloadItem {
  final String id;
  final String title;
  final String courseId;
  final String courseName;
  final DownloadType type;
  final String? filePath;
  final String? url;
  final DateTime downloadedAt;
  final int? fileSize; // in bytes
  final String? thumbnail;

  DownloadItem({
    required this.id,
    required this.title,
    required this.courseId,
    required this.courseName,
    required this.type,
    this.filePath,
    this.url,
    DateTime? downloadedAt,
    this.fileSize,
    this.thumbnail,
  }) : downloadedAt = downloadedAt ?? DateTime.now();

  String get fileSizeFormatted {
    if (fileSize == null) return 'Unknown';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024)
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get fileExtension {
    if (type == DownloadType.video) return 'MP4';
    if (type == DownloadType.pdf) return 'PDF';
    if (type == DownloadType.document) return 'DOC';
    return 'FILE';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courseId': courseId,
      'courseName': courseName,
      'type': type.name,
      'filePath': filePath,
      'url': url,
      'downloadedAt': downloadedAt.toIso8601String(),
      'fileSize': fileSize,
      'thumbnail': thumbnail,
    };
  }

  factory DownloadItem.fromJson(Map<String, dynamic> json) {
    return DownloadItem(
      id: json['id'] as String,
      title: json['title'] as String,
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      type: DownloadType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DownloadType.document,
      ),
      filePath: json['filePath'] as String?,
      url: json['url'] as String?,
      downloadedAt: DateTime.parse(json['downloadedAt'] as String),
      fileSize: json['fileSize'] as int?,
      thumbnail: json['thumbnail'] as String?,
    );
  }

  DownloadItem copyWith({
    String? id,
    String? title,
    String? courseId,
    String? courseName,
    DownloadType? type,
    String? filePath,
    String? url,
    DateTime? downloadedAt,
    int? fileSize,
    String? thumbnail,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      url: url ?? this.url,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      fileSize: fileSize ?? this.fileSize,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}

enum DownloadType {
  video,
  pdf,
  document,
  image,
}
