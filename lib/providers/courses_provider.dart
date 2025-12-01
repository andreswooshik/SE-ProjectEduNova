import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../repositories/interfaces/i_course_repository.dart';
import '../repositories/course_repository.dart';
import 'auth_provider.dart';

/// Course repository provider
/// Dependency Inversion: Depends on IStorageService abstraction
final courseRepositoryProvider = Provider<ICourseRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return CourseRepository(storageService);
});

/// Courses state
class CoursesState {
  final bool isLoading;
  final List<Course> courses;
  final Course? selectedCourse;
  final String? errorMessage;

  const CoursesState({
    this.isLoading = false,
    this.courses = const [],
    this.selectedCourse,
    this.errorMessage,
  });

  CoursesState copyWith({
    bool? isLoading,
    List<Course>? courses,
    Course? selectedCourse,
    String? errorMessage,
  }) {
    return CoursesState(
      isLoading: isLoading ?? this.isLoading,
      courses: courses ?? this.courses,
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
    return const CoursesState();
  }

  /// Load all courses
  Future<void> loadAllCourses() async {
    state = state.copyWith(isLoading: true);

    try {
      final courses = await _courseRepository.getAllCourses();
      state = state.copyWith(isLoading: false, courses: courses);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Load courses for a specific student
  Future<void> loadCoursesForStudent(String studentId) async {
    state = state.copyWith(isLoading: true);

    try {
      final courses = await _courseRepository.getCoursesForStudent(studentId);
      state = state.copyWith(isLoading: false, courses: courses);
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
      final success = await _courseRepository.enrollStudent(courseId, studentId);
      if (success) {
        await loadAllCourses(); // Refresh the list
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
