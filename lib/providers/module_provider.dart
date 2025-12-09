import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/module.dart';
import '../services/module_management_service.dart';
import '../repositories/interfaces/i_module_repository.dart';
import '../services/interfaces/i_file_storage_service.dart';
import 'app_providers.dart'; // Import to access shared providers

/// Module state class
class ModuleState {
  final List<Module> modules;
  final Module? selectedModule;
  final bool isLoading;
  final String? error;

  ModuleState({
    this.modules = const [],
    this.selectedModule,
    this.isLoading = false,
    this.error,
  });

  ModuleState copyWith({
    List<Module>? modules,
    Module? selectedModule,
    bool? isLoading,
    String? error,
    bool clearSelectedModule = false,
    bool clearError = false,
  }) {
    return ModuleState(
      modules: modules ?? this.modules,
      selectedModule: clearSelectedModule ? null : (selectedModule ?? this.selectedModule),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Module notifier using Notifier
/// Single Responsibility: Manages module state and coordinates operations
class ModuleNotifier extends Notifier<ModuleState> {
  late final IModuleRepository _moduleRepository;
  late final ModuleManagementService _moduleManagementService;
  late final IFileStorageService _fileStorageService;

  @override
  ModuleState build() {
    // Initialize dependencies from other providers
    _moduleRepository = ref.read(moduleRepositoryProvider);
    _moduleManagementService = ref.read(moduleManagementServiceProvider);
    _fileStorageService = ref.read(fileStorageServiceProvider);
    
    return ModuleState();
  }

  /// Load modules for a specific course
  Future<void> loadModulesForCourse(String courseId, {bool publishedOnly = false}) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final modules = publishedOnly
          ? await _moduleRepository.getPublishedModules(courseId)
          : await _moduleRepository.getModulesByCourseId(courseId);

      state = state.copyWith(
        modules: modules,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Create a new module (Teacher operation)
  Future<Module?> createModule(ModuleCreateData data) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final module = await _moduleManagementService.createModule(data);

      // Add to current state
      state = state.copyWith(
        modules: [...state.modules, module],
        isLoading: false,
      );

      return module;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Update an existing module (Teacher operation)
  Future<Module?> updateModule({
    required String moduleId,
    required String teacherId,
    String? title,
    String? description,
    int? order,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final updatedModule = await _moduleManagementService.updateModule(
        moduleId: moduleId,
        teacherId: teacherId,
        title: title,
        description: description,
        order: order,
      );

      // Update in state
      final updatedModules = state.modules.map((m) {
        return m.id == moduleId ? updatedModule : m;
      }).toList();

      state = state.copyWith(
        modules: updatedModules,
        selectedModule: state.selectedModule?.id == moduleId ? updatedModule : null,
        isLoading: false,
      );

      return updatedModule;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Delete a module (Teacher operation)
  Future<bool> deleteModule(String moduleId, String teacherId) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final success = await _moduleManagementService.deleteModule(moduleId, teacherId);

      if (success) {
        // Remove from state
        final updatedModules = state.modules.where((m) => m.id != moduleId).toList();
        state = state.copyWith(
          modules: updatedModules,
          isLoading: false,
          clearSelectedModule: state.selectedModule?.id == moduleId,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to delete module',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Add a resource to a module (Teacher operation)
  Future<ModuleResource?> addResourceToModule({
    required String moduleId,
    required ResourceUploadData data,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final resource = await _moduleManagementService.addResourceToModule(
        moduleId: moduleId,
        data: data,
      );

      // Update module in state
      final updatedModules = state.modules.map((m) {
        if (m.id == moduleId) {
          return m.copyWith(resources: [...m.resources, resource]);
        }
        return m;
      }).toList();

      state = state.copyWith(
        modules: updatedModules,
        isLoading: false,
      );

      return resource;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Remove a resource from a module (Teacher operation)
  Future<bool> removeResource({
    required String moduleId,
    required String resourceId,
    required String teacherId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final success = await _moduleManagementService.removeResource(
        moduleId: moduleId,
        resourceId: resourceId,
        teacherId: teacherId,
      );

      if (success) {
        // Update module in state
        final updatedModules = state.modules.map((m) {
          if (m.id == moduleId) {
            final updatedResources = m.resources.where((r) => r.id != resourceId).toList();
            return m.copyWith(resources: updatedResources);
          }
          return m;
        }).toList();

        state = state.copyWith(
          modules: updatedModules,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to remove resource',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Toggle publish status (Teacher operation)
  Future<Module?> togglePublishStatus(String moduleId, String teacherId) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      final updatedModule = await _moduleManagementService.togglePublishStatus(
        moduleId,
        teacherId,
      );

      // Update in state
      final updatedModules = state.modules.map((m) {
        return m.id == moduleId ? updatedModule : m;
      }).toList();

      state = state.copyWith(
        modules: updatedModules,
        selectedModule: state.selectedModule?.id == moduleId ? updatedModule : null,
        isLoading: false,
      );

      return updatedModule;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Reorder modules (Teacher operation)
  Future<bool> reorderModules({
    required String courseId,
    required String teacherId,
    required List<String> orderedModuleIds,
  }) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      await _moduleManagementService.reorderModules(
        courseId: courseId,
        teacherId: teacherId,
        orderedModuleIds: orderedModuleIds,
      );

      // Reload modules to get updated order
      await loadModulesForCourse(courseId);

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Get file from storage (Student operation)
  Future<File?> getResourceFile(String filePath) async {
    try {
      return await _fileStorageService.getFile(filePath);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Select a module
  void selectModule(String moduleId) {
    final module = state.modules.cast<Module?>().firstWhere(
          (m) => m?.id == moduleId,
          orElse: () => null,
        );

    state = state.copyWith(selectedModule: module);
  }

  /// Clear selected module
  void clearSelectedModule() {
    state = state.copyWith(clearSelectedModule: true);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Get modules sorted by order
  List<Module> getModulesSorted() {
    final modules = List<Module>.from(state.modules);
    modules.sort((a, b) => a.order.compareTo(b.order));
    return modules;
  }
}
