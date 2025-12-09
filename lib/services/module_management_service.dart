import 'dart:io';
import '../models/module.dart';
import '../repositories/interfaces/i_module_repository.dart';
import '../services/interfaces/i_file_storage_service.dart';

/// Data class for creating a module
class ModuleCreateData {
  final String courseId;
  final String teacherId;
  final String title;
  final String description;
  final int order;

  ModuleCreateData({
    required this.courseId,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.order,
  });
}

/// Data class for resource upload
class ResourceUploadData {
  final File file;
  final String title;
  final String description;
  final String teacherId;

  ResourceUploadData({
    required this.file,
    required this.title,
    required this.description,
    required this.teacherId,
  });
}

/// Service for managing module operations (Teacher operations)
/// Single Responsibility Principle: Handles business logic for module management
class ModuleManagementService {
  final IModuleRepository _moduleRepository;
  final IFileStorageService _fileStorageService;

  ModuleManagementService(
    this._moduleRepository,
    this._fileStorageService,
  );

  /// Create a new module
  Future<Module> createModule(ModuleCreateData data) async {
    try {
      // Validate authorization
      final isAuthorized = await _moduleRepository.isTeacherAuthorized(
        data.teacherId,
        data.courseId,
      );

      if (!isAuthorized) {
        throw Exception('Teacher is not authorized to create module in this course');
      }

      // Validate input
      if (data.title.trim().isEmpty) {
        throw Exception('Module title cannot be empty');
      }

      if (data.description.trim().isEmpty) {
        throw Exception('Module description cannot be empty');
      }

      // Create module
      final module = Module(
        id: _generateModuleId(),
        courseId: data.courseId,
        title: data.title.trim(),
        description: data.description.trim(),
        order: data.order,
        createdBy: data.teacherId,
        isPublished: false,
      );

      return await _moduleRepository.createModule(module);
    } catch (e) {
      throw Exception('Failed to create module: $e');
    }
  }

  /// Add a resource to a module
  Future<ModuleResource> addResourceToModule({
    required String moduleId,
    required ResourceUploadData data,
  }) async {
    try {
      // Get module
      final module = await _moduleRepository.getModuleById(moduleId);
      if (module == null) {
        throw Exception('Module not found');
      }

      // Validate authorization
      final isAuthorized = await _moduleRepository.isTeacherAuthorized(
        data.teacherId,
        module.courseId,
      );

      if (!isAuthorized) {
        throw Exception('Teacher is not authorized to add resources to this module');
      }

      // Validate file
      final fileName = data.file.path.split('/').last;
      final allowedTypes = [
        ResourceType.pdf,
        ResourceType.pptx,
        ResourceType.docx,
        ResourceType.xlsx,
        ResourceType.image,
        ResourceType.video,
        ResourceType.audio,
      ];

      if (!_fileStorageService.isValidFileType(fileName, allowedTypes)) {
        throw Exception('Invalid file type. Only PDF, PPT, DOC, XLS, images, videos, and audio files are allowed.');
      }

      // Save file
      final filePath = await _fileStorageService.saveFile(
        file: data.file,
        moduleId: moduleId,
        fileName: fileName,
      );

      // Get file metadata
      final metadata = await _fileStorageService.getFileMetadata(filePath);

      // Generate thumbnail if applicable
      final thumbnailPath = await _fileStorageService.generateThumbnail(
        filePath,
        metadata.type,
      );

      // Create resource
      final resource = ModuleResource(
        id: _generateResourceId(),
        moduleId: moduleId,
        title: data.title.trim(),
        description: data.description.trim(),
        type: metadata.type,
        filePath: filePath,
        fileSizeBytes: metadata.sizeBytes,
        thumbnailPath: thumbnailPath,
        uploadedBy: data.teacherId,
      );

      // Add to module
      await _moduleRepository.addResourceToModule(moduleId, resource);

      return resource;
    } catch (e) {
      throw Exception('Failed to add resource to module: $e');
    }
  }

  /// Update a module
  Future<Module> updateModule({
    required String moduleId,
    required String teacherId,
    String? title,
    String? description,
    int? order,
  }) async {
    try {
      // Get existing module
      final module = await _moduleRepository.getModuleById(moduleId);
      if (module == null) {
        throw Exception('Module not found');
      }

      // Validate authorization
      final isAuthorized = await _moduleRepository.isTeacherAuthorized(
        teacherId,
        module.courseId,
      );

      if (!isAuthorized) {
        throw Exception('Teacher is not authorized to update this module');
      }

      // Update module
      final updatedModule = module.copyWith(
        title: title ?? module.title,
        description: description ?? module.description,
        order: order ?? module.order,
        updatedAt: DateTime.now(),
      );

      return await _moduleRepository.updateModule(updatedModule);
    } catch (e) {
      throw Exception('Failed to update module: $e');
    }
  }

  /// Delete a module
  Future<bool> deleteModule(String moduleId, String teacherId) async {
    try {
      // Get module
      final module = await _moduleRepository.getModuleById(moduleId);
      if (module == null) {
        return false;
      }

      // Validate authorization
      final isAuthorized = await _moduleRepository.isTeacherAuthorized(
        teacherId,
        module.courseId,
      );

      if (!isAuthorized) {
        throw Exception('Teacher is not authorized to delete this module');
      }

      return await _moduleRepository.deleteModule(moduleId);
    } catch (e) {
      throw Exception('Failed to delete module: $e');
    }
  }

  /// Remove a resource from a module
  Future<bool> removeResource({
    required String moduleId,
    required String resourceId,
    required String teacherId,
  }) async {
    try {
      // Get module
      final module = await _moduleRepository.getModuleById(moduleId);
      if (module == null) {
        return false;
      }

      // Validate authorization
      final isAuthorized = await _moduleRepository.isTeacherAuthorized(
        teacherId,
        module.courseId,
      );

      if (!isAuthorized) {
        throw Exception('Teacher is not authorized to remove resources from this module');
      }

      await _moduleRepository.removeResourceFromModule(moduleId, resourceId);
      return true;
    } catch (e) {
      throw Exception('Failed to remove resource: $e');
    }
  }

  /// Toggle publish status of a module
  Future<Module> togglePublishStatus(String moduleId, String teacherId) async {
    try {
      // Get module
      final module = await _moduleRepository.getModuleById(moduleId);
      if (module == null) {
        throw Exception('Module not found');
      }

      // Validate authorization
      final isAuthorized = await _moduleRepository.isTeacherAuthorized(
        teacherId,
        module.courseId,
      );

      if (!isAuthorized) {
        throw Exception('Teacher is not authorized to publish/unpublish this module');
      }

      return await _moduleRepository.togglePublishStatus(moduleId);
    } catch (e) {
      throw Exception('Failed to toggle publish status: $e');
    }
  }

  /// Reorder modules within a course
  Future<void> reorderModules({
    required String courseId,
    required String teacherId,
    required List<String> orderedModuleIds,
  }) async {
    try {
      // Validate authorization
      final isAuthorized = await _moduleRepository.isTeacherAuthorized(
        teacherId,
        courseId,
      );

      if (!isAuthorized) {
        throw Exception('Teacher is not authorized to reorder modules in this course');
      }

      await _moduleRepository.reorderModules(courseId, orderedModuleIds);
    } catch (e) {
      throw Exception('Failed to reorder modules: $e');
    }
  }

  /// Validate teacher access to a course
  Future<bool> validateTeacherAccess(String teacherId, String courseId) async {
    try {
      return await _moduleRepository.isTeacherAuthorized(teacherId, courseId);
    } catch (e) {
      throw Exception('Failed to validate teacher access: $e');
    }
  }

  /// Generate unique module ID
  String _generateModuleId() {
    return 'module_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Generate unique resource ID
  String _generateResourceId() {
    return 'resource_${DateTime.now().millisecondsSinceEpoch}';
  }
}
