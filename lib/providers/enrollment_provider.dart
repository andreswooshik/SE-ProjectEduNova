import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';

class EnrollmentNotifier extends Notifier<List<Course>> {
  @override
  List<Course> build() => [];

  void enrollCourse(Course course) {
    if (!state.any((c) => c.id == course.id)) {
      state = [...state, course];
    }
  }

  void unenrollCourse(String courseId) {
    state = state.where((c) => c.id != courseId).toList();
  }

  bool isEnrolled(String courseId) {
    return state.any((c) => c.id == courseId);
  }

  List<Course> get enrolledCourses => state;
}

final enrollmentProvider = NotifierProvider<EnrollmentNotifier, List<Course>>(
  EnrollmentNotifier.new,
);
