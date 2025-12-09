# Backend Module System Implementation Plan

## Overview
This plan outlines the implementation of a comprehensive backend system that allows **teachers** to create and manage course modules with file attachments (PPTs, PDFs, etc.) and enables **students** to view and access these materials.

---

## 📋 Current State Analysis

### ✅ What We Have
- Basic `Course` model with `CourseMaterial` and `Assignment` classes
- `CourseRepository` for CRUD operations on courses
- `CourseStorageService` for data persistence
- User models (Student, Teacher, Admin) with role-based authentication
- Local storage infrastructure using shared preferences

### ❌ What We Need
- Enhanced Module model for structured course content
- File upload/storage service for handling PDFs, PPTs, documents
- Module management service (teacher-only operations)
- Module viewing service (student access)
- Enhanced repository patterns for module operations
- UI components for teachers to add/edit modules
- UI components for students to view/download modules

---

## 🏗️ Architecture Design

### 1. **Data Models** (lib/models/)

#### A. Enhanced Module Model (`module.dart`)
```dart
class Module {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order; // For sequential ordering
  final List<ModuleResource> resources; // PPTs, PDFs, etc.
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy; // Teacher ID
  final bool isPublished; // Draft vs Published state
}

class ModuleResource {
  final String id;
  final String moduleId;
  final String title;
  final String description;
  final ResourceType type; // PDF, PPT, DOCX, etc.
  final String filePath; // Local file path or URL
  final int fileSizeBytes;
  final String? thumbnailPath;
  final DateTime uploadedAt;
  final String uploadedBy; // Teacher ID
}

enum ResourceType {
  pdf,
  pptx,
  docx,
  xlsx,
  image,
  video,
  audio,
  link,
  other
}
```

#### B. Course Enhancement
- Add `List<String> moduleIds` to existing Course model
- Maintain relationship between courses and modules

---

### 2. **Services Layer** (lib/services/)

#### A. File Storage Service (`file_storage_service.dart`)
**Purpose:** Handle file operations for module resources

```dart
interface IFileStorageService {
  // Save file to local storage
  Future<String> saveFile(File file, String moduleId, String fileName);
  
  // Get file from storage
  Future<File?> getFile(String filePath);
  
  // Delete file from storage
  Future<bool> deleteFile(String filePath);
  
  // Get file metadata
  Future<FileMetadata> getFileMetadata(String filePath);
  
  // Generate thumbnail for supported files
  Future<String?> generateThumbnail(String filePath);
  
  // Calculate file size
  int getFileSize(File file);
  
  // Validate file type
  bool isValidFileType(String fileName, List<ResourceType> allowedTypes);
}
```

**Implementation Details:**
- Use `path_provider` package to get app documents directory
- Store files in organized structure: `documents/{courseId}/{moduleId}/{filename}`
- Generate unique filenames to avoid conflicts
- Support file size limits (e.g., max 50MB per file)
- Implement file validation (check extensions, MIME types)

#### B. Module Storage Service (`module_storage_service.dart`)
**Purpose:** Persist module data to local storage

```dart
interface IModuleStorageService {
  Future<List<Module>> getAllModules();
  Future<List<Module>> getModulesByCourseId(String courseId);
  Future<Module?> getModuleById(String moduleId);
  Future<void> saveModule(Module module);
  Future<void> updateModule(Module module);
  Future<void> deleteModule(String moduleId);
}
```

**Implementation:**
- Store modules as JSON in SharedPreferences
- Key structure: `modules_list` for all modules
- Implement caching for performance

#### C. Module Management Service (`module_management_service.dart`)
**Purpose:** Business logic for teacher module operations

```dart
class ModuleManagementService {
  // Teacher creates a new module
  Future<Module> createModule({
    required String courseId,
    required String teacherId,
    required String title,
    required String description,
    required int order,
  });
  
  // Teacher adds resource to module
  Future<ModuleResource> addResourceToModule({
    required String moduleId,
    required String teacherId,
    required File file,
    required String title,
    required String description,
    required ResourceType type,
  });
  
  // Teacher updates module
  Future<Module> updateModule(String moduleId, Map<String, dynamic> updates);
  
  // Teacher deletes module
  Future<bool> deleteModule(String moduleId, String teacherId);
  
  // Teacher removes resource from module
  Future<bool> removeResource(String moduleId, String resourceId, String teacherId);
  
  // Teacher publishes/unpublishes module
  Future<Module> togglePublishStatus(String moduleId, String teacherId);
  
  // Reorder modules
  Future<void> reorderModules(String courseId, List<String> orderedModuleIds);
  
  // Validate teacher authorization
  bool validateTeacherAccess(String teacherId, String courseId);
}
```

---

### 3. **Repository Layer** (lib/repositories/)

#### A. Module Repository (`module_repository.dart`)
**Purpose:** Data access abstraction for modules

```dart
interface IModuleRepository {
  // Get operations
  Future<List<Module>> getModulesByCourseId(String courseId);
  Future<Module?> getModuleById(String moduleId);
  Future<List<Module>> getPublishedModules(String courseId);
  
  // Create/Update operations
  Future<Module> createModule(Module module);
  Future<Module> updateModule(Module module);
  Future<bool> deleteModule(String moduleId);
  
  // Resource operations
  Future<Module> addResourceToModule(String moduleId, ModuleResource resource);
  Future<Module> removeResourceFromModule(String moduleId, String resourceId);
  Future<List<ModuleResource>> getResourcesByModuleId(String moduleId);
  
  // Authorization checks
  Future<bool> isTeacherAuthorized(String teacherId, String courseId);
}
```

---

### 4. **State Management** (lib/providers/)

#### A. Module Provider (`module_provider.dart`)
**Purpose:** Manage module state across the app

```dart
class ModuleProvider extends ChangeNotifier {
  List<Module> _modules = [];
  Module? _selectedModule;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Module> get modules => _modules;
  Module? get selectedModule => _selectedModule;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Load modules for a course
  Future<void> loadModulesForCourse(String courseId);
  
  // Teacher operations
  Future<void> createModule(ModuleCreateData data);
  Future<void> updateModule(String moduleId, Map<String, dynamic> updates);
  Future<void> deleteModule(String moduleId);
  Future<void> addResourceToModule(String moduleId, File file, ResourceData data);
  Future<void> removeResource(String moduleId, String resourceId);
  Future<void> togglePublishStatus(String moduleId);
  Future<void> reorderModules(String courseId, List<String> orderedIds);
  
  // Student operations
  Future<File?> downloadResource(String resourceId);
  Future<void> openResource(ModuleResource resource);
  
  // Helper methods
  void selectModule(String moduleId);
  void clearError();
}
```

---

### 5. **UI Components** (lib/widgets/)

#### A. Teacher-Side Widgets

**`module_editor_card.dart`**
- Card for creating/editing a module
- Fields: title, description, order, publish status
- Actions: Save, Cancel, Delete

**`resource_uploader.dart`**
- File picker interface
- Drag-and-drop support (if web)
- File type validation
- Progress indicator for uploads
- Preview thumbnail generation

**`module_list_item.dart`**
- Display module in a list
- Show resource count
- Quick actions (Edit, Delete, Publish/Unpublish)
- Drag handles for reordering

**`resource_list_item.dart`**
- Display individual resource
- Show file type icon, size, upload date
- Actions: Download, Delete, Edit metadata

#### B. Student-Side Widgets

**`module_card.dart`**
- Display module information
- Show resource count
- Expand/collapse to show resources
- Indicate if module is locked/unlocked

**`resource_download_card.dart`**
- Display resource with download button
- Show file type, size
- Download progress indicator
- Open file button after download

**`resource_viewer.dart`**
- In-app viewer for supported file types
- PDF viewer integration
- Image viewer
- Video player for videos

---

### 6. **Screen Implementations** (lib/screens/)

#### A. Teacher Screens

**`teacher_module_management_page.dart`**
- View all modules for a course
- Add new module button
- Edit existing modules
- Reorder modules (drag and drop)
- Publish/unpublish modules
- Delete modules (with confirmation)

**`module_create_edit_page.dart`**
- Form for module details
- Resource upload section
- Resource list with actions
- Save/Cancel buttons
- Validation

**`resource_upload_page.dart`**
- Dedicated page for adding resources
- Multiple file upload support
- Metadata entry (title, description)
- Upload progress
- Success/error feedback

#### B. Student Screens

**`student_module_view_page.dart`**
- List of all modules in a course
- Filter by published status
- Search functionality
- Expand/collapse modules
- Resource access

**`resource_detail_page.dart`**
- Full resource details
- Download button
- View/preview if supported
- Related resources

---

## 🔧 Implementation Steps

### Phase 1: Foundation (Models & Storage)
**Priority: HIGH** | **Estimated Time: 2-3 hours**

1. ✅ **Create Module Model**
   - Define `Module` class with all fields
   - Define `ModuleResource` class
   - Add `ResourceType` enum
   - Implement JSON serialization/deserialization
   - Add copyWith methods for immutability

2. ✅ **Create File Storage Service**
   - Implement `IFileStorageService` interface
   - Create `FileStorageService` concrete implementation
   - Add file saving logic with directory structure
   - Implement file retrieval
   - Add file deletion with cleanup
   - Add file metadata extraction
   - Implement file validation

3. ✅ **Create Module Storage Service**
   - Implement `IModuleStorageService` interface
   - Create `ModuleStorageService` implementation
   - Implement CRUD operations using SharedPreferences
   - Add error handling

### Phase 2: Business Logic Layer
**Priority: HIGH** | **Estimated Time: 3-4 hours**

4. ✅ **Create Module Repository**
   - Implement `IModuleRepository` interface
   - Create `ModuleRepository` class
   - Integrate with storage services
   - Add authorization checks
   - Implement all CRUD operations

5. ✅ **Create Module Management Service**
   - Implement teacher-specific operations
   - Add authorization validation
   - Implement resource management
   - Add publish/unpublish logic
   - Implement module reordering

6. ✅ **Enhance Course Repository**
   - Add module-related methods to `CourseRepository`
   - Implement course-module relationship management
   - Add cascade operations (delete course → delete modules)

### Phase 3: State Management
**Priority: HIGH** | **Estimated Time: 2-3 hours**

7. ✅ **Create Module Provider**
   - Implement `ModuleProvider` with ChangeNotifier
   - Add state management for modules
   - Implement loading/error states
   - Add all CRUD operation methods
   - Integrate with repositories

8. ✅ **Integrate with App**
   - Add `ModuleProvider` to main.dart
   - Update provider dependencies
   - Test provider functionality

### Phase 4: UI Components (Teacher)
**Priority: MEDIUM** | **Estimated Time: 4-5 hours**

9. ✅ **Create Teacher Module Widgets**
   - `module_editor_card.dart`
   - `resource_uploader.dart`
   - `module_list_item.dart`
   - `resource_list_item.dart`

10. ✅ **Create Teacher Screens**
    - `teacher_module_management_page.dart`
    - `module_create_edit_page.dart`
    - `resource_upload_page.dart`

11. ✅ **Integrate with Navigation**
    - Add routes for new screens
    - Update teacher dashboard to show module management
    - Add navigation from course details to module management

### Phase 5: UI Components (Student)
**Priority: MEDIUM** | **Estimated Time: 3-4 hours**

12. ✅ **Create Student Module Widgets**
    - `module_card.dart`
    - `resource_download_card.dart`
    - `resource_viewer.dart`

13. ✅ **Create Student Screens**
    - `student_module_view_page.dart`
    - `resource_detail_page.dart`

14. ✅ **Integrate with Navigation**
    - Update student course view to show modules
    - Add navigation to module content
    - Implement resource viewing/downloading

### Phase 6: Advanced Features
**Priority: LOW** | **Estimated Time: 3-4 hours**

15. ✅ **Add File Previews**
    - PDF preview using `flutter_pdfview` or similar
    - Image preview
    - Video player integration

16. ✅ **Add Download Management**
    - Track downloaded files
    - Show download progress
    - Implement offline access

17. ✅ **Add Search & Filter**
    - Search modules by title
    - Filter by published status
    - Sort by date, order, etc.

### Phase 7: Testing & Polish
**Priority: MEDIUM** | **Estimated Time: 2-3 hours**

18. ✅ **Test Authorization**
    - Verify teacher can only edit their courses
    - Verify students can only view published modules
    - Test edge cases

19. ✅ **Test File Operations**
    - Test upload with various file types
    - Test file size limits
    - Test deletion and cleanup
    - Test concurrent operations

20. ✅ **Add Error Handling**
    - User-friendly error messages
    - Validation feedback
    - Loading states
    - Empty states

---

## 📦 Required Dependencies

Add these to `pubspec.yaml`:

```yaml
dependencies:
  # Current dependencies...
  
  # File handling
  file_picker: ^8.0.0+1  # For picking files from device
  path_provider: ^2.1.2  # For getting app directories
  path: ^1.9.0          # For path manipulation
  
  # File viewing
  flutter_pdfview: ^1.3.2  # For PDF preview
  open_file: ^3.3.2       # For opening files with system apps
  
  # Icons for file types
  file_icon: ^1.0.0
  
  # Optional: Better file info
  mime: ^1.0.5           # For MIME type detection
  
  # Optional: Download progress
  dio: ^5.4.0            # If you plan to support cloud storage later
```

---

## 🔐 Security Considerations

### 1. **Authorization**
- **Verify teacher ownership** before any write operation
- **Check course enrollment** before students access modules
- **Validate user roles** at service layer, not just UI

### 2. **File Validation**
- **Whitelist allowed file types** (PDF, PPT, DOC, etc.)
- **Limit file sizes** (e.g., max 50MB)
- **Scan file extensions** and MIME types
- **Sanitize file names** to prevent path traversal attacks

### 3. **Data Integrity**
- **Validate all inputs** (titles, descriptions, etc.)
- **Use transactions** when updating related data
- **Implement proper error handling** for storage failures
- **Add data backup mechanisms**

---

## 📱 User Experience Flow

### Teacher Flow: Adding Module with Resources

1. **Navigate** to Course Details
2. **Click** "Manage Modules" button
3. **View** list of existing modules (if any)
4. **Click** "Add New Module" button
5. **Enter** module details (title, description, order)
6. **Click** "Add Resources" button
7. **Select** files from device (PDF, PPT, etc.)
8. **Enter** resource metadata (title, description)
9. **Upload** files (show progress)
10. **Review** uploaded resources
11. **Publish** module (or save as draft)
12. **Confirm** success message

### Student Flow: Viewing Module Resources

1. **Navigate** to Enrolled Course
2. **View** list of published modules
3. **Expand** module to see resources
4. **Click** on resource to view details
5. **Download** resource (if not already downloaded)
6. **View progress** indicator
7. **Open** file using in-app viewer or system app
8. **Navigate** back to module list

---

## 🎨 UI/UX Mockup Ideas

### Teacher Module Management Screen
```
┌─────────────────────────────────────┐
│ ← Course: Introduction to Flutter   │
│                                     │
│ [+ Add New Module]                  │
│                                     │
│ ┌─ Module 1: Getting Started ──┐   │
│ │ 📄 3 Resources | Published ✓  │   │
│ │ [Edit] [Delete] [⋮]          │   │
│ │                              │   │
│ │ Resources:                   │   │
│ │ • intro.pdf (2.3 MB)        │   │
│ │ • setup.pptx (5.1 MB)       │   │
│ │ • guide.docx (1.2 MB)       │   │
│ └──────────────────────────────┘   │
│                                     │
│ ┌─ Module 2: Widgets ──────────┐   │
│ │ 📄 2 Resources | Draft       │   │
│ │ [Edit] [Delete] [⋮]          │   │
│ └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Student Module View Screen
```
┌─────────────────────────────────────┐
│ ← Course: Introduction to Flutter   │
│                                     │
│ 📚 Modules                          │
│                                     │
│ ┌─ Module 1: Getting Started ──┐   │
│ │ 3 resources available         │   │
│ │                              │   │
│ │ 📄 Introduction to Flutter    │   │
│ │    PDF · 2.3 MB              │   │
│ │    [Download] [View]         │   │
│ │                              │   │
│ │ 📊 Setup Guide               │   │
│ │    PPTX · 5.1 MB             │   │
│ │    [Download] [View]         │   │
│ │                              │   │
│ │ 📝 Getting Started Guide     │   │
│ │    DOCX · 1.2 MB · Downloaded│   │
│ │    [Open]                    │   │
│ └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

## ✅ Testing Checklist

### Unit Tests
- [ ] Module model serialization/deserialization
- [ ] File storage service operations
- [ ] Module storage service CRUD
- [ ] Repository methods
- [ ] Service layer business logic
- [ ] Provider state management

### Integration Tests
- [ ] Teacher creates module
- [ ] Teacher adds resources to module
- [ ] Teacher publishes module
- [ ] Student views published modules
- [ ] Student downloads resources
- [ ] Authorization checks
- [ ] File cleanup on deletion

### UI Tests
- [ ] Module list displays correctly
- [ ] File upload works
- [ ] Download shows progress
- [ ] Error messages display
- [ ] Loading states work
- [ ] Navigation flows correctly

---

## 🚀 Future Enhancements

### Short-term (Next Sprint)
- **Quiz Integration**: Add quizzes within modules
- **Progress Tracking**: Track student progress through modules
- **Due Dates**: Add deadlines for module completion
- **Notifications**: Notify students when new modules are published

### Medium-term
- **Cloud Storage**: Integrate Firebase Storage or AWS S3
- **Video Streaming**: Support video lectures
- **Interactive Content**: Embed interactive elements
- **Collaborative Notes**: Allow students to take shareable notes

### Long-term
- **Offline Mode**: Full offline support with sync
- **AI Recommendations**: Suggest relevant resources
- **Analytics**: Track engagement and completion rates
- **Multi-language**: Support content in multiple languages

---

## 📝 Implementation Notes

### Code Style Guidelines
- Follow **SOLID principles** throughout
- Use **dependency injection** for all services
- Implement **proper error handling** with try-catch
- Add **comprehensive documentation** to all public methods
- Use **meaningful variable names** and constants
- Keep methods **small and focused** (single responsibility)

### Performance Considerations
- **Lazy load** modules and resources
- **Cache** frequently accessed data
- **Paginate** large lists
- **Optimize file operations** (use isolates for large files)
- **Compress thumbnails** to reduce storage

### Accessibility
- Add **semantic labels** to all interactive elements
- Support **screen readers**
- Ensure **sufficient color contrast**
- Provide **keyboard navigation** support
- Add **haptic feedback** for actions

---

## 📞 Support & Resources

### Documentation References
- [Flutter File Picker](https://pub.dev/packages/file_picker)
- [Path Provider](https://pub.dev/packages/path_provider)
- [PDF View](https://pub.dev/packages/flutter_pdfview)
- [Provider Pattern](https://pub.dev/packages/provider)

### Design Resources
- Material Design Guidelines for File Uploads
- iOS Human Interface Guidelines for Document Handling

---

## ✨ Summary

This comprehensive plan provides a complete roadmap for implementing a robust module system where:
- **Teachers** can create modules, upload resources (PDFs, PPTs), manage content, and control publishing
- **Students** can view modules, download resources, and access learning materials seamlessly

The architecture follows **SOLID principles**, uses **clean architecture patterns**, and ensures **scalability** for future enhancements.

**Total Estimated Implementation Time: 19-26 hours**

---

*Last Updated: December 9, 2025*
*Version: 1.0*
*Author: GitHub Copilot*
