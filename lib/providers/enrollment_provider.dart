import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';

/// Notifier for managing student course enrollments.
/// 
/// This provider follows the Single Responsibility Principle by focusing
/// solely on enrollment state management.
/// 
/// CRITICAL: All enrollment operations use course.id as the unique identifier
/// to prevent issues with duplicate or similar course titles.
class EnrollmentNotifier extends Notifier<List<Course>> {
  @override
  List<Course> build() => [];

  /// Enrolls a student in a course.
  /// 
  /// Uses course.id to prevent duplicate enrollments of the same course.
  /// If the course is already enrolled, this operation is a no-op.
  /// 
  /// @param course The complete course object to enroll
  void enrollCourse(Course course) {
    // Prevent duplicate enrollment by checking course.id
    if (!state.any((c) => c.id == course.id)) {
      state = [...state, course];
    }
  }

  /// Unenrolls a student from a course.
  /// 
  /// @param courseId The unique ID of the course to unenroll from
  void unenrollCourse(String courseId) {
    state = state.where((c) => c.id != courseId).toList();
  }

  /// Checks if a student is enrolled in a course.
  /// 
  /// @param courseId The unique ID of the course to check
  /// @return true if enrolled, false otherwise
  bool isEnrolled(String courseId) {
    return state.any((c) => c.id == courseId);
  }

  /// Returns the list of all enrolled courses
  List<Course> get enrolledCourses => state;
}

final enrollmentProvider = NotifierProvider<EnrollmentNotifier, List<Course>>(
  EnrollmentNotifier.new,
);
