import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/downloads.dart';

/// Provider for managing downloads
/// Follows Single Responsibility Principle - only manages download state
class DownloadsNotifier extends Notifier<List<DownloadItem>> {
  @override
  List<DownloadItem> build() {
    // Sample downloads for demonstration
    return [
      DownloadItem(
        id: '1',
        title: 'Introduction to Cybersecurity (Video)',
        courseId: '5',
        courseName: 'Cybersecurity',
        type: DownloadType.video,
        fileSize: 45 * 1024 * 1024, // 45 MB
        thumbnail: 'assets/images/cybersec.png',
      ),
      DownloadItem(
        id: '2',
        title: 'Network Basics Overview (Video)',
        courseId: '5',
        courseName: 'Cybersecurity',
        type: DownloadType.video,
        fileSize: 38 * 1024 * 1024, // 38 MB
        thumbnail: 'assets/images/cybersec.png',
      ),
      DownloadItem(
        id: '3',
        title: 'Understanding Firewalls (Video)',
        courseId: '5',
        courseName: 'Cybersecurity',
        type: DownloadType.video,
        fileSize: 52 * 1024 * 1024, // 52 MB
        thumbnail: 'assets/images/cybersec.png',
      ),
      DownloadItem(
        id: '4',
        title: 'Cybersecurity Basics - Module 1 PDF',
        courseId: '5',
        courseName: 'Cybersecurity',
        type: DownloadType.pdf,
        fileSize: 2 * 1024 * 1024, // 2 MB
      ),
      DownloadItem(
        id: '5',
        title: 'Network Threats & Defenses Module 2 PDF',
        courseId: '5',
        courseName: 'Cybersecurity',
        type: DownloadType.pdf,
        fileSize: 3 * 1024 * 1024, // 3 MB
      ),
      DownloadItem(
        id: '6',
        title: 'Password Security Guidelines (Handout)',
        courseId: '5',
        courseName: 'Cybersecurity',
        type: DownloadType.document,
        fileSize: 512 * 1024, // 512 KB
      ),
    ];
  }

  /// Get downloads by course
  List<DownloadItem> getDownloadsByCourse(String courseId) {
    return state.where((download) => download.courseId == courseId).toList();
  }

  /// Get downloads by type
  List<DownloadItem> getDownloadsByType(DownloadType type) {
    return state.where((download) => download.type == type).toList();
  }

  /// Get video downloads
  List<DownloadItem> getVideoDownloads() {
    return state
        .where((download) => download.type == DownloadType.video)
        .toList();
  }

  /// Get file downloads (PDFs and documents)
  List<DownloadItem> getFileDownloads() {
    return state
        .where((download) =>
            download.type == DownloadType.pdf ||
            download.type == DownloadType.document)
        .toList();
  }

  /// Add download
  void addDownload(DownloadItem download) {
    state = [...state, download];
  }

  /// Remove download
  void removeDownload(String downloadId) {
    state = state.where((download) => download.id != downloadId).toList();
  }

  /// Clear all downloads
  void clearAllDownloads() {
    state = [];
  }

  /// Get total storage used
  int getTotalStorageUsed() {
    return state.fold<int>(
        0, (sum, download) => sum + (download.fileSize ?? 0));
  }

  /// Get storage used formatted
  String getTotalStorageFormatted() {
    final total = getTotalStorageUsed();
    if (total < 1024 * 1024) return '${(total / 1024).toStringAsFixed(1)} KB';
    if (total < 1024 * 1024 * 1024)
      return '${(total / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(total / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

final downloadsProvider =
    NotifierProvider<DownloadsNotifier, List<DownloadItem>>(
  DownloadsNotifier.new,
);
