# Quick Reference: Using the Module System

## 🚀 Quick Start Guide

### Setup in Your Widget

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/app_providers.dart';
import '../services/module_management_service.dart';

// Use ConsumerWidget or ConsumerStatefulWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access providers here
  }
}
```

---

## 👨‍🏫 Teacher Operations

### 1. Create a Module

```dart
Future<void> createModule(WidgetRef ref, String courseId) async {
  final notifier = ref.read(moduleProvider.notifier);
  final user = ref.read(currentUserProvider);
  
  final module = await notifier.createModule(
    ModuleCreateData(
      courseId: courseId,
      teacherId: user!.id,
      title: 'Week 1: Introduction',
      description: 'Getting started with the course',
      order: 1,
    ),
  );
  
  if (module != null) {
    print('Module created: ${module.id}');
  } else {
    // Check error
    final error = ref.read(moduleProvider).error;
    print('Error: $error');
  }
}
```

### 2. Upload a File Resource

```dart
Future<void> uploadResource(WidgetRef ref, String moduleId) async {
  // Pick file
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx'],
  );
  
  if (result != null && result.files.single.path != null) {
    final file = File(result.files.single.path!);
    final notifier = ref.read(moduleProvider.notifier);
    final user = ref.read(currentUserProvider);
    
    final resource = await notifier.addResourceToModule(
      moduleId: moduleId,
      data: ResourceUploadData(
        file: file,
        title: 'Lecture Slides',
        description: 'Week 1 presentation',
        teacherId: user!.id,
      ),
    );
    
    if (resource != null) {
      print('Resource uploaded: ${resource.id}');
    }
  }
}
```

### 3. Update Module

```dart
Future<void> updateModule(WidgetRef ref, String moduleId) async {
  final notifier = ref.read(moduleProvider.notifier);
  final user = ref.read(currentUserProvider);
  
  final updated = await notifier.updateModule(
    moduleId: moduleId,
    teacherId: user!.id,
    title: 'Updated Title',
    description: 'Updated Description',
  );
}
```

### 4. Publish/Unpublish Module

```dart
Future<void> togglePublish(WidgetRef ref, String moduleId) async {
  final notifier = ref.read(moduleProvider.notifier);
  final user = ref.read(currentUserProvider);
  
  await notifier.togglePublishStatus(moduleId, user!.id);
}
```

### 5. Delete Module

```dart
Future<void> deleteModule(WidgetRef ref, String moduleId) async {
  final notifier = ref.read(moduleProvider.notifier);
  final user = ref.read(currentUserProvider);
  
  final success = await notifier.deleteModule(moduleId, user!.id);
  if (success) {
    print('Module deleted');
  }
}
```

### 6. Remove Resource

```dart
Future<void> removeResource(
  WidgetRef ref,
  String moduleId,
  String resourceId,
) async {
  final notifier = ref.read(moduleProvider.notifier);
  final user = ref.read(currentUserProvider);
  
  await notifier.removeResource(
    moduleId: moduleId,
    resourceId: resourceId,
    teacherId: user!.id,
  );
}
```

### 7. Reorder Modules

```dart
Future<void> reorderModules(WidgetRef ref, String courseId) async {
  final notifier = ref.read(moduleProvider.notifier);
  final user = ref.read(currentUserProvider);
  
  await notifier.reorderModules(
    courseId: courseId,
    teacherId: user!.id,
    orderedModuleIds: ['module-3', 'module-1', 'module-2'],
  );
}
```

---

## 👨‍🎓 Student Operations

### 1. Load Published Modules

```dart
// Method 1: Using notifier
Future<void> loadModules(WidgetRef ref, String courseId) async {
  final notifier = ref.read(moduleProvider.notifier);
  await notifier.loadModulesForCourse(courseId, publishedOnly: true);
}

// Method 2: Using family provider (recommended for UI)
Widget build(BuildContext context, WidgetRef ref) {
  final modulesAsync = ref.watch(publishedModulesProvider(courseId));
  
  return modulesAsync.when(
    data: (modules) => ListView.builder(
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return ListTile(
          title: Text(module.title),
          subtitle: Text('${module.resources.length} resources'),
        );
      },
    ),
    loading: () => CircularProgressIndicator(),
    error: (error, stack) => Text('Error: $error'),
  );
}
```

### 2. View Module Resources

```dart
Widget buildResourcesList(Module module) {
  return ListView.builder(
    itemCount: module.resources.length,
    itemBuilder: (context, index) {
      final resource = module.resources[index];
      return ListTile(
        leading: Icon(_getIconForType(resource.type)),
        title: Text(resource.title),
        subtitle: Text(resource.fileSizeFormatted),
        trailing: IconButton(
          icon: Icon(Icons.download),
          onPressed: () => _downloadResource(resource),
        ),
      );
    },
  );
}

IconData _getIconForType(ResourceType type) {
  switch (type) {
    case ResourceType.pdf: return Icons.picture_as_pdf;
    case ResourceType.pptx: return Icons.slideshow;
    case ResourceType.docx: return Icons.description;
    case ResourceType.image: return Icons.image;
    case ResourceType.video: return Icons.video_file;
    default: return Icons.file_present;
  }
}
```

### 3. Download and Open Resource

```dart
import 'package:open_file/open_file.dart';

Future<void> downloadAndOpen(WidgetRef ref, ModuleResource resource) async {
  final notifier = ref.read(moduleProvider.notifier);
  
  // Get file
  final file = await notifier.getResourceFile(resource.filePath);
  
  if (file != null && await file.exists()) {
    // Open with system app
    await OpenFile.open(file.path);
  } else {
    print('File not found');
  }
}
```

---

## 📊 Watching State

### 1. Watch Loading State

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final moduleState = ref.watch(moduleProvider);
  
  if (moduleState.isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  
  // ... rest of UI
}
```

### 2. Watch Error State

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final moduleState = ref.watch(moduleProvider);
  
  if (moduleState.error != null) {
    return Center(
      child: Column(
        children: [
          Text('Error: ${moduleState.error}'),
          ElevatedButton(
            onPressed: () {
              ref.read(moduleProvider.notifier).clearError();
            },
            child: Text('Clear Error'),
          ),
        ],
      ),
    );
  }
  
  // ... rest of UI
}
```

### 3. Watch Modules List

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final modules = ref.watch(moduleProvider).modules;
  
  return ListView.builder(
    itemCount: modules.length,
    itemBuilder: (context, index) {
      final module = modules[index];
      return Card(
        child: ListTile(
          title: Text(module.title),
          subtitle: Text(module.description),
          trailing: module.isPublished
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.drafts, color: Colors.orange),
        ),
      );
    },
  );
}
```

### 4. Watch Selected Module

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final selectedModule = ref.watch(moduleProvider).selectedModule;
  
  if (selectedModule == null) {
    return Text('No module selected');
  }
  
  return Column(
    children: [
      Text(selectedModule.title),
      Text(selectedModule.description),
      Text('Resources: ${selectedModule.resources.length}'),
    ],
  );
}
```

---

## 🔍 Querying Data

### 1. Get Module by ID

```dart
// Using family provider
Widget build(BuildContext context, WidgetRef ref) {
  final moduleAsync = ref.watch(moduleByIdProvider(moduleId));
  
  return moduleAsync.when(
    data: (module) {
      if (module == null) return Text('Module not found');
      return Text(module.title);
    },
    loading: () => CircularProgressIndicator(),
    error: (error, stack) => Text('Error: $error'),
  );
}
```

### 2. Check User Role

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final isTeacher = ref.watch(isTeacherProvider);
  final isStudent = ref.watch(isStudentProvider);
  
  if (isTeacher) {
    return TeacherView();
  } else if (isStudent) {
    return StudentView();
  } else {
    return Text('Unknown role');
  }
}
```

### 3. Get Current User

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(currentUserProvider);
  
  if (user == null) {
    return Text('Not logged in');
  }
  
  return Text('Welcome, ${user.firstName}!');
}
```

---

## 🛠️ Common Patterns

### 1. Show Loading Dialog

```dart
Future<void> performAction(BuildContext context, WidgetRef ref) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );
  
  // Perform action
  await ref.read(moduleProvider.notifier).createModule(...);
  
  Navigator.of(context).pop(); // Close dialog
}
```

### 2. Show Error Snackbar

```dart
void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

// Usage
final error = ref.read(moduleProvider).error;
if (error != null) {
  showError(context, error);
  ref.read(moduleProvider.notifier).clearError();
}
```

### 3. Refresh Data

```dart
Future<void> refreshModules(WidgetRef ref, String courseId) async {
  // Using notifier
  await ref.read(moduleProvider.notifier).loadModulesForCourse(courseId);
  
  // Or invalidate family provider
  ref.invalidate(publishedModulesProvider(courseId));
}
```

### 4. Conditional Rendering

```dart
Widget buildModuleCard(Module module, WidgetRef ref) {
  final isTeacher = ref.watch(isTeacherProvider);
  
  return Card(
    child: Column(
      children: [
        Text(module.title),
        if (isTeacher) ...[
          ElevatedButton(
            onPressed: () => editModule(module),
            child: Text('Edit'),
          ),
          ElevatedButton(
            onPressed: () => deleteModule(ref, module.id),
            child: Text('Delete'),
          ),
        ],
      ],
    ),
  );
}
```

---

## 🎯 Best Practices

1. **Always check for null**
   ```dart
   final user = ref.read(currentUserProvider);
   if (user == null) return;
   ```

2. **Handle errors gracefully**
   ```dart
   final result = await notifier.createModule(...);
   if (result == null) {
     // Check error and show to user
   }
   ```

3. **Use family providers for specific data**
   ```dart
   // Good: Specific data
   ref.watch(moduleByIdProvider(id));
   
   // Less efficient: Load all then filter
   ref.watch(moduleProvider).modules.firstWhere(...);
   ```

4. **Clear state when appropriate**
   ```dart
   @override
   void dispose() {
     ref.read(moduleProvider.notifier).clearSelectedModule();
     super.dispose();
   }
   ```

5. **Use const constructors**
   ```dart
   const Text('Hello') // Better for performance
   ```

---

## 📝 File Type Support

### Supported File Types

- **Documents**: PDF, DOC, DOCX
- **Presentations**: PPT, PPTX
- **Spreadsheets**: XLS, XLSX
- **Images**: JPG, JPEG, PNG, GIF, BMP, WEBP
- **Videos**: MP4, MOV, AVI, MKV, WEBM
- **Audio**: MP3, WAV, OGG, M4A

### File Size Limit

- Maximum: **50 MB** per file

---

## 🔧 Troubleshooting

### Module not loading?
```dart
// Check if course ID is correct
print('Loading modules for course: $courseId');

// Check error state
final error = ref.read(moduleProvider).error;
print('Error: $error');
```

### File not uploading?
```dart
// Check file exists
print('File exists: ${await file.exists()}');

// Check file size
print('File size: ${file.lengthSync()} bytes');

// Check file type
print('File extension: ${path.extension(file.path)}');
```

### Authorization errors?
```dart
// Verify user is teacher
final isTeacher = ref.read(isTeacherProvider);
print('Is teacher: $isTeacher');

// Verify user owns course
final moduleRepo = ref.read(moduleRepositoryProvider);
final isAuthorized = await moduleRepo.isTeacherAuthorized(teacherId, courseId);
print('Is authorized: $isAuthorized');
```

---

**Happy Coding! 🚀**
