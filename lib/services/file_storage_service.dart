import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/module.dart';
import 'interfaces/i_file_storage_service.dart';

/// Concrete implementation of IFileStorageService
/// Single Responsibility Principle: Handles only file storage operations
class FileStorageService implements IFileStorageService {
  static const String _documentsFolder = 'course_documents';
  static const int _maxFileSizeBytes = 52428800; // 50 MB

  @override
  Future<String> saveFile({
    required File file,
    required String moduleId,
    required String fileName,
  }) async {
    try {
      // Validate file size
      final fileSize = getFileSize(file);
      if (fileSize > _maxFileSizeBytes) {
        throw Exception(
            'File size exceeds maximum allowed size of ${(_maxFileSizeBytes / (1024 * 1024)).toStringAsFixed(0)} MB');
      }

      // Get storage directory
      final storageDir = await getStorageDirectory();
      final moduleDir = path.join(storageDir, moduleId);

      // Create module directory if it doesn't exist
      final moduleDirEntity = Directory(moduleDir);
      if (!await moduleDirEntity.exists()) {
        await moduleDirEntity.create(recursive: true);
      }

      // Generate unique filename to avoid conflicts
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(fileName);
      final nameWithoutExt = path.basenameWithoutExtension(fileName);
      final sanitizedName = _sanitizeFileName(nameWithoutExt);
      final uniqueFileName = '${sanitizedName}_$timestamp$extension';

      // Save file
      final filePath = path.join(moduleDir, uniqueFileName);
      await file.copy(filePath);

      return filePath;
    } catch (e) {
      throw Exception('Failed to save file: $e');
    }
  }

  @override
  Future<File?> getFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get file: $e');
    }
  }

  @override
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  @override
  Future<FileMetadata> getFileMetadata(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final stat = await file.stat();
      final fileName = path.basename(filePath);
      final extension = path.extension(filePath).replaceAll('.', '');
      final type = ResourceType.fromExtension(extension);

      return FileMetadata(
        path: filePath,
        name: fileName,
        extension: extension,
        sizeBytes: stat.size,
        lastModified: stat.modified,
        type: type,
      );
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  @override
  Future<String?> generateThumbnail(String filePath, ResourceType type) async {
    // TODO: Implement thumbnail generation for images and videos
    // This would require additional packages like flutter_image_compress
    // For now, return null
    return null;
  }

  @override
  int getFileSize(File file) {
    try {
      return file.lengthSync();
    } catch (e) {
      throw Exception('Failed to get file size: $e');
    }
  }

  @override
  bool isValidFileType(String fileName, List<ResourceType> allowedTypes) {
    final extension = path.extension(fileName).replaceAll('.', '').toLowerCase();
    if (extension.isEmpty) return false;

    for (final type in allowedTypes) {
      if (type.extensions.contains(extension)) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<String> getStorageDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final storageDir = path.join(appDir.path, _documentsFolder);

      // Create directory if it doesn't exist
      final directory = Directory(storageDir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      return storageDir;
    } catch (e) {
      throw Exception('Failed to get storage directory: $e');
    }
  }

  @override
  Future<int> cleanupOrphanedFiles(List<String> validFilePaths) async {
    try {
      final storageDir = await getStorageDirectory();
      final directory = Directory(storageDir);

      if (!await directory.exists()) {
        return 0;
      }

      int deletedCount = 0;
      final validPaths = validFilePaths.toSet();

      // Recursively find all files
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) {
          // If file is not in the valid list, delete it
          if (!validPaths.contains(entity.path)) {
            try {
              await entity.delete();
              deletedCount++;
            } catch (e) {
              // Continue even if deletion fails
              debugPrint('Failed to delete orphaned file ${entity.path}: $e');
            }
          }
        }
      }

      // Clean up empty directories
      await _cleanupEmptyDirectories(directory);

      return deletedCount;
    } catch (e) {
      throw Exception('Failed to cleanup orphaned files: $e');
    }
  }

  /// Sanitize filename to remove invalid characters
  String _sanitizeFileName(String fileName) {
    // Remove or replace invalid characters
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Clean up empty directories recursively
  Future<void> _cleanupEmptyDirectories(Directory directory) async {
    try {
      await for (final entity in directory.list()) {
        if (entity is Directory) {
          await _cleanupEmptyDirectories(entity);

          // Try to delete if empty
          final isEmpty = await entity.list().isEmpty;
          if (isEmpty) {
            try {
              await entity.delete();
            } catch (e) {
              // Ignore errors when deleting directories
            }
          }
        }
      }
    } catch (e) {
      // Ignore errors
    }
  }
}
