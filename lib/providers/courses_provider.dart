import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../repositories/interfaces/i_course_repository.dart';
import '../repositories/course_repository.dart';
import '../services/interfaces/i_course_storage_service.dart';
import '../services/course_storage_service.dart';
import 'auth_provider.dart';
import 'search_provider.dart';

/// Course storage service provider
final courseStorageServiceProvider = Provider<ICourseStorageService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return CourseStorageService(storageService);
});

/// Course repository provider
/// Dependency Inversion: Depends on abstractions
final courseRepositoryProvider = Provider<ICourseRepository>((ref) {
  final courseStorageService = ref.watch(courseStorageServiceProvider);
  return CourseRepository(courseStorageService);
});

/// Default courses - hardcoded for demo purposes
final defaultCoursesProvider = Provider<List<Course>>((ref) {
  return [
    Course(
      id: '1',
      title: 'Graphic Design',
      description: 'Learn the fundamentals of graphic design',
      teacherId: 'teacher_1',
      instructor: 'Kendrick Capusco',
      progress: '45%',
      accentColor: const Color(0xFF2196F3),
      thumbnailAsset: 'assets/images/graphDesign.png',
    ),
    Course(
      id: '2',
      title: 'Wireframing',
      description: 'Master wireframing techniques',
      teacherId: 'teacher_2',
      instructor: 'Shoaib Atto',
      progress: '45%',
      accentColor: const Color(0xFFB42986),
      thumbnailAsset: 'assets/images/wireframe.png',
    ),
    Course(
      id: '3',
      title: 'Website Design',
      description: 'Create beautiful websites',
      teacherId: 'teacher_3',
      instructor: 'Dwayne Wade',
      progress: '45%',
      accentColor: const Color(0xFFFF9800),
      thumbnailAsset: 'assets/images/webDesign.png',
    ),
    Course(
      id: '4',
      title: 'Video Editing',
      description: 'Professional video editing skills',
      teacherId: 'teacher_4',
      instructor: 'Ammer Cruz',
      progress: '45%',
      accentColor: const Color(0xFF000000),
      thumbnailAsset: 'assets/images/VideoEditing.png',
    ),
    Course(
      id: '5',
      title: 'Cybersecurity',
      description: 'Secure systems and networks',
      teacherId: 'teacher_5',
      instructor: 'John Anderson',
      progress: '45%',
      accentColor: const Color(0xFF9C27B0),
      thumbnailAsset: 'assets/images/cybersec.png',
    ),
    Course(
      id: '6',
      title: 'MySql Basics',
      description: 'Database fundamentals',
      teacherId: 'teacher_6',
      instructor: 'Sarah Johnson',
      progress: '45%',
      accentColor: const Color(0xFF4CAF50),
      thumbnailAsset: 'assets/images/sql.png',
    ),
    Course(
      id: '7',
      title: 'Flutter Development',
      description: 'Build mobile apps with Flutter',
      teacherId: 'teacher_7',
      instructor: 'Adhz Formentera',
      progress: '45%',
      accentColor: const Color(0xFF67747E),
      thumbnailAsset: 'assets/images/flutter.png',
    ),
  ];
});

/// Courses state
class CoursesState {
  final bool isLoading;
  final List<Course> courses;
  final List<Course> myCourses;
  final Course? selectedCourse;
  final String? errorMessage;

  const CoursesState({
    this.isLoading = false,
    this.courses = const [],
    this.myCourses = const [],
    this.selectedCourse,
    this.errorMessage,
  });

  CoursesState copyWith({
    bool? isLoading,
    List<Course>? courses,
    List<Course>? myCourses,
    Course? selectedCourse,
    String? errorMessage,
  }) {
    return CoursesState(
      isLoading: isLoading ?? this.isLoading,
      courses: courses ?? this.courses,
      myCourses: myCourses ?? this.myCourses,
      selectedCourse: selectedCourse ?? this.selectedCourse,
      errorMessage: errorMessage,
    );
  }
}

/// Courses state notifier following Single Responsibility Principle
/// Only handles course list state changes
/// Uses Riverpod 3.x Notifier pattern
class CoursesNotifier extends Notifier<CoursesState> {
  late ICourseRepository _courseRepository;

  @override
  CoursesState build() {
    _courseRepository = ref.watch(courseRepositoryProvider);
    // Initialize with default courses
    final defaultCourses = ref.watch(defaultCoursesProvider);
    return CoursesState(courses: defaultCourses);
  }

  /// Load all courses
  Future<void> loadAllCourses() async {
    state = state.copyWith(isLoading: true);

    try {
      final courses = await _courseRepository.getAllCourses();
      // If no courses from repository, use default courses
      if (courses.isEmpty) {
        final defaultCourses = ref.read(defaultCoursesProvider);
        state = state.copyWith(isLoading: false, courses: defaultCourses);
      } else {
        state = state.copyWith(isLoading: false, courses: courses);
      }
    } catch (e) {
      // On error, use default courses
      final defaultCourses = ref.read(defaultCoursesProvider);
      state = state.copyWith(
        isLoading: false,
        courses: defaultCourses,
        errorMessage: null, // Don't show error if we have default courses
      );
    }
  }

  /// Load courses for a specific student
  Future<void> loadCoursesForStudent(String studentId) async {
    state = state.copyWith(isLoading: true);

    try {
      final myCourses = await _courseRepository.getCoursesForStudent(studentId);
      state = state.copyWith(isLoading: false, myCourses: myCourses);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Load courses for a specific teacher
  Future<void> loadCoursesForTeacher(String teacherId) async {
    state = state.copyWith(isLoading: true);

    try {
      final courses = await _courseRepository.getCoursesForTeacher(teacherId);
      state = state.copyWith(isLoading: false, courses: courses);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Create a new course
  Future<bool> createCourse({
    required String title,
    required String description,
    required String teacherId,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final course = Course(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        teacherId: teacherId,
      );

      await _courseRepository.createCourse(course);
      state = state.copyWith(
        isLoading: false,
        courses: [...state.courses, course],
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Enroll a student in a course
  Future<bool> enrollStudent(String courseId, String studentId) async {
    try {
      final success =
          await _courseRepository.enrollStudent(courseId, studentId);
      if (success) {
        // Refresh my courses
        await loadCoursesForStudent(studentId);
      }
      return success;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Select a course
  void selectCourse(Course? course) {
    state = state.copyWith(selectedCourse: course);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Courses provider using Riverpod 3.x NotifierProvider
final coursesProvider = NotifierProvider<CoursesNotifier, CoursesState>(() {
  return CoursesNotifier();
});

/// Convenience provider to get selected course
final selectedCourseProvider = Provider<Course?>((ref) {
  return ref.watch(coursesProvider).selectedCourse;
});

/// Convenience provider to get course by ID
final courseByIdProvider = Provider.family<Course?, String>((ref, courseId) {
  final courses = ref.watch(coursesProvider).courses;
  try {
    return courses.firstWhere((c) => c.id == courseId);
  } catch (e) {
    return null;
  }
});

/// Filtered courses provider based on search query
/// Follows Open/Closed Principle - open for extension via search logic
final filteredCoursesProvider = Provider<List<Course>>((ref) {
  final coursesState = ref.watch(coursesProvider);
  final searchQuery = ref.watch(searchProvider);

  // Use all courses from the state
  final allCourses = coursesState.courses;

  if (searchQuery.isEmpty) {
    return allCourses;
  }

  return allCourses.where((course) {
    final titleMatch = course.title.toLowerCase().contains(searchQuery);
    final instructorMatch =
        course.instructor?.toLowerCase().contains(searchQuery) ?? false;
    final descriptionMatch =
        course.description.toLowerCase().contains(searchQuery);

    return titleMatch || instructorMatch || descriptionMatch;
  }).toList();
});
