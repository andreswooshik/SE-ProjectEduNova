import '../../models/module.dart';

/// Interface for module repository operations
/// Dependency Inversion Principle: High-level modules depend on abstractions
abstract class IModuleRepository {
  /// Get all modules for a course
  Future<List<Module>> getModulesByCourseId(String courseId);

  /// Get published modules for a course (student view)
  Future<List<Module>> getPublishedModules(String courseId);

  /// Get a single module by ID
  Future<Module?> getModuleById(String moduleId);

  /// Create a new module
  Future<Module> createModule(Module module);

  /// Update an existing module
  Future<Module> updateModule(Module module);

  /// Delete a module
  Future<bool> deleteModule(String moduleId);

  /// Add a resource to a module
  Future<Module> addResourceToModule(String moduleId, ModuleResource resource);

  /// Remove a resource from a module
  Future<Module> removeResourceFromModule(String moduleId, String resourceId);

  /// Get all resources for a module
  Future<List<ModuleResource>> getResourcesByModuleId(String moduleId);

  /// Toggle publish status of a module
  Future<Module> togglePublishStatus(String moduleId);

  /// Reorder modules within a course
  Future<void> reorderModules(String courseId, List<String> orderedModuleIds);

  /// Check if teacher is authorized to modify module
  Future<bool> isTeacherAuthorized(String teacherId, String courseId);

  /// Delete all modules for a course (cascade delete)
  Future<void> deleteModulesByCourseId(String courseId);
}
