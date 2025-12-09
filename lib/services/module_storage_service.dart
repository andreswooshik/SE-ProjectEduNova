import 'dart:convert';
import '../core/constants/app_constants.dart';
import '../models/module.dart';
import 'interfaces/i_storage_service.dart';
import 'interfaces/i_module_storage_service.dart';

/// Concrete implementation of IModuleStorageService
/// Single Responsibility Principle: Handles only module data persistence
class ModuleStorageService implements IModuleStorageService {
  final IStorageService _storageService;
  final String _modulesListKey = '${AppConstants.storagePrefix}modules_list';

  ModuleStorageService(this._storageService);

  @override
  Future<List<Module>> getAllModules() async {
    try {
      final modulesJson = await _storageService.getStringList(_modulesListKey);
      if (modulesJson == null || modulesJson.isEmpty) {
        return [];
      }

      return modulesJson.map((json) {
        final Map<String, dynamic> data = jsonDecode(json);
        return Module.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get all modules: $e');
    }
  }

  @override
  Future<List<Module>> getModulesByCourseId(String courseId) async {
    try {
      final allModules = await getAllModules();
      return allModules.where((m) => m.courseId == courseId).toList()
        ..sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      throw Exception('Failed to get modules by course ID: $e');
    }
  }

  @override
  Future<Module?> getModuleById(String moduleId) async {
    try {
      final allModules = await getAllModules();
      return allModules.cast<Module?>().firstWhere(
            (m) => m?.id == moduleId,
            orElse: () => null,
          );
    } catch (e) {
      throw Exception('Failed to get module by ID: $e');
    }
  }

  @override
  Future<void> saveModule(Module module) async {
    try {
      final modules = await getAllModules();

      // Check if module already exists
      final existingIndex = modules.indexWhere((m) => m.id == module.id);
      if (existingIndex != -1) {
        throw Exception('Module already exists. Use updateModule instead.');
      }

      modules.add(module);
      await saveModules(modules);
    } catch (e) {
      throw Exception('Failed to save module: $e');
    }
  }

  @override
  Future<void> updateModule(Module module) async {
    try {
      final modules = await getAllModules();
      final index = modules.indexWhere((m) => m.id == module.id);

      if (index == -1) {
        throw Exception('Module not found');
      }

      modules[index] = module.copyWith(updatedAt: DateTime.now());
      await saveModules(modules);
    } catch (e) {
      throw Exception('Failed to update module: $e');
    }
  }

  @override
  Future<void> deleteModule(String moduleId) async {
    try {
      final modules = await getAllModules();
      modules.removeWhere((m) => m.id == moduleId);
      await saveModules(modules);
    } catch (e) {
      throw Exception('Failed to delete module: $e');
    }
  }

  @override
  Future<void> saveModules(List<Module> modules) async {
    try {
      final modulesJson = modules.map((m) => jsonEncode(m.toJson())).toList();
      await _storageService.saveStringList(_modulesListKey, modulesJson);
    } catch (e) {
      throw Exception('Failed to save modules: $e');
    }
  }

  @override
  Future<bool> moduleExists(String moduleId) async {
    try {
      final module = await getModuleById(moduleId);
      return module != null;
    } catch (e) {
      throw Exception('Failed to check module existence: $e');
    }
  }
}
