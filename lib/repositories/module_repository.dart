import '../models/module.dart';
import '../services/interfaces/i_module_storage_service.dart';
import '../services/interfaces/i_file_storage_service.dart';
import 'interfaces/i_module_repository.dart';
import 'interfaces/i_course_repository.dart';

/// Concrete implementation of IModuleRepository
/// Open/Closed Principle: Can be extended without modifying clients
class ModuleRepository implements IModuleRepository {
  final IModuleStorageService _moduleStorageService;
  final IFileStorageService _fileStorageService;
  final ICourseRepository _courseRepository;

  ModuleRepository(
    this._moduleStorageService,
    this._fileStorageService,
    this._courseRepository,
  );

  @override
  Future<List<Module>> getModulesByCourseId(String courseId) async {
    try {
      return await _moduleStorageService.getModulesByCourseId(courseId);
    } catch (e) {
      throw Exception('Failed to get modules by course ID: $e');
    }
  }

  @override
  Future<List<Module>> getPublishedModules(String courseId) async {
    try {
      final modules = await getModulesByCourseId(courseId);
      return modules.where((m) => m.isPublished).toList();
    } catch (e) {
      throw Exception('Failed to get published modules: $e');
    }
  }

  @override
  Future<Module?> getModuleById(String moduleId) async {
    try {
      return await _moduleStorageService.getModuleById(moduleId);
    } catch (e) {
      throw Exception('Failed to get module by ID: $e');
    }
  }

  @override
  Future<Module> createModule(Module module) async {
    try {
      // Verify course exists
      final course = await _courseRepository.getCourseById(module.courseId);
      if (course == null) {
        throw Exception('Course not found');
      }

      await _moduleStorageService.saveModule(module);
      return module;
    } catch (e) {
      throw Exception('Failed to create module: $e');
    }
  }

  @override
  Future<Module> updateModule(Module module) async {
    try {
      final existingModule = await getModuleById(module.id);
      if (existingModule == null) {
        throw Exception('Module not found');
      }

      final updatedModule = module.copyWith(updatedAt: DateTime.now());
      await _moduleStorageService.updateModule(updatedModule);
      return updatedModule;
    } catch (e) {
      throw Exception('Failed to update module: $e');
    }
  }

  @override
  Future<bool> deleteModule(String moduleId) async {
    try {
      final module = await getModuleById(moduleId);
      if (module == null) {
        return false;
      }

      // Delete all associated resource files
      for (final resource in module.resources) {
        await _fileStorageService.deleteFile(resource.filePath);
        if (resource.thumbnailPath != null) {
          await _fileStorageService.deleteFile(resource.thumbnailPath!);
        }
      }

      await _moduleStorageService.deleteModule(moduleId);
      return true;
    } catch (e) {
      throw Exception('Failed to delete module: $e');
    }
  }

  @override
  Future<Module> addResourceToModule(
      String moduleId, ModuleResource resource) async {
    try {
      final module = await getModuleById(moduleId);
      if (module == null) {
        throw Exception('Module not found');
      }

      // Check if resource with same ID already exists
      if (module.resources.any((r) => r.id == resource.id)) {
        throw Exception('Resource with this ID already exists in the module');
      }

      final updatedResources = [...module.resources, resource];
      final updatedModule = module.copyWith(
        resources: updatedResources,
        updatedAt: DateTime.now(),
      );

      await _moduleStorageService.updateModule(updatedModule);
      return updatedModule;
    } catch (e) {
      throw Exception('Failed to add resource to module: $e');
    }
  }

  @override
  Future<Module> removeResourceFromModule(
      String moduleId, String resourceId) async {
    try {
      final module = await getModuleById(moduleId);
      if (module == null) {
        throw Exception('Module not found');
      }

      // Find the resource to delete its file
      final resource = module.resources.cast<ModuleResource?>().firstWhere(
            (r) => r?.id == resourceId,
            orElse: () => null,
          );

      if (resource != null) {
        // Delete the file
        await _fileStorageService.deleteFile(resource.filePath);
        if (resource.thumbnailPath != null) {
          await _fileStorageService.deleteFile(resource.thumbnailPath!);
        }
      }

      // Remove from module
      final updatedResources =
          module.resources.where((r) => r.id != resourceId).toList();
      final updatedModule = module.copyWith(
        resources: updatedResources,
        updatedAt: DateTime.now(),
      );

      await _moduleStorageService.updateModule(updatedModule);
      return updatedModule;
    } catch (e) {
      throw Exception('Failed to remove resource from module: $e');
    }
  }

  @override
  Future<List<ModuleResource>> getResourcesByModuleId(String moduleId) async {
    try {
      final module = await getModuleById(moduleId);
      return module?.resources ?? [];
    } catch (e) {
      throw Exception('Failed to get resources by module ID: $e');
    }
  }

  @override
  Future<Module> togglePublishStatus(String moduleId) async {
    try {
      final module = await getModuleById(moduleId);
      if (module == null) {
        throw Exception('Module not found');
      }

      final updatedModule = module.copyWith(
        isPublished: !module.isPublished,
        updatedAt: DateTime.now(),
      );

      await _moduleStorageService.updateModule(updatedModule);
      return updatedModule;
    } catch (e) {
      throw Exception('Failed to toggle publish status: $e');
    }
  }

  @override
  Future<void> reorderModules(
      String courseId, List<String> orderedModuleIds) async {
    try {
      final modules = await getModulesByCourseId(courseId);

      // Update order for each module
      for (int i = 0; i < orderedModuleIds.length; i++) {
        final moduleId = orderedModuleIds[i];
        final module = modules.cast<Module?>().firstWhere(
              (m) => m?.id == moduleId,
              orElse: () => null,
            );

        if (module != null) {
          final updatedModule = module.copyWith(
            order: i,
            updatedAt: DateTime.now(),
          );
          await _moduleStorageService.updateModule(updatedModule);
        }
      }
    } catch (e) {
      throw Exception('Failed to reorder modules: $e');
    }
  }

  @override
  Future<bool> isTeacherAuthorized(String teacherId, String courseId) async {
    try {
      final course = await _courseRepository.getCourseById(courseId);
      return course?.teacherId == teacherId;
    } catch (e) {
      throw Exception('Failed to check teacher authorization: $e');
    }
  }

  @override
  Future<void> deleteModulesByCourseId(String courseId) async {
    try {
      final modules = await getModulesByCourseId(courseId);

      // Delete all modules and their resources
      for (final module in modules) {
        await deleteModule(module.id);
      }
    } catch (e) {
      throw Exception('Failed to delete modules by course ID: $e');
    }
  }
}
