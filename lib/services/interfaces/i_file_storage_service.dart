import 'dart:io';
import '../../models/module.dart';

/// Interface for file storage operations
/// Interface Segregation Principle: Defines only file-related operations
abstract class IFileStorageService {
  /// Save file to local storage
  /// Returns the file path where the file is saved
  Future<String> saveFile({
    required File file,
    required String moduleId,
    required String fileName,
  });

  /// Get file from storage
  /// Returns the file if found, null otherwise
  Future<File?> getFile(String filePath);

  /// Delete file from storage
  /// Returns true if file was deleted successfully
  Future<bool> deleteFile(String filePath);

  /// Get file metadata (size, type, etc.)
  Future<FileMetadata> getFileMetadata(String filePath);

  /// Generate thumbnail for supported file types
  /// Returns thumbnail path if generated, null otherwise
  Future<String?> generateThumbnail(String filePath, ResourceType type);

  /// Calculate file size
  int getFileSize(File file);

  /// Validate file type
  /// Returns true if file type is allowed
  bool isValidFileType(String fileName, List<ResourceType> allowedTypes);

  /// Get storage directory path
  Future<String> getStorageDirectory();

  /// Clean up orphaned files (files not referenced in any module)
  Future<int> cleanupOrphanedFiles(List<String> validFilePaths);
}

/// File metadata model
class FileMetadata {
  final String path;
  final String name;
  final String extension;
  final int sizeBytes;
  final DateTime lastModified;
  final ResourceType type;

  FileMetadata({
    required this.path,
    required this.name,
    required this.extension,
    required this.sizeBytes,
    required this.lastModified,
    required this.type,
  });

  /// Get human-readable file size
  String get sizeFormatted {
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    } else if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    } else if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
