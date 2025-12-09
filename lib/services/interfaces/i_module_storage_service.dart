import '../../models/module.dart';

/// Interface for module storage operations
/// Interface Segregation Principle: Defines only module storage operations
abstract class IModuleStorageService {
  /// Get all modules from storage
  Future<List<Module>> getAllModules();

  /// Get modules by course ID
  Future<List<Module>> getModulesByCourseId(String courseId);

  /// Get a single module by ID
  Future<Module?> getModuleById(String moduleId);

  /// Save a new module
  Future<void> saveModule(Module module);

  /// Update an existing module
  Future<void> updateModule(Module module);

  /// Delete a module
  Future<void> deleteModule(String moduleId);

  /// Save multiple modules at once
  Future<void> saveModules(List<Module> modules);

  /// Check if a module exists
  Future<bool> moduleExists(String moduleId);
}
