import '../models/course.dart';
import '../services/interfaces/i_course_storage_service.dart';
import 'interfaces/i_course_repository.dart';

/// Concrete implementation of ICourseRepository
/// Open/Closed Principle: Can be extended or replaced without modifying clients
class CourseRepository implements ICourseRepository {
  final ICourseStorageService _courseStorageService;

  CourseRepository(this._courseStorageService);

  @override
  Future<List<Course>> getAllCourses() async {
    return await _courseStorageService.getAllCourses();
  }

  @override
  Future<List<Course>> getCoursesForStudent(String studentId) async {
    final allCourses = await getAllCourses();
    return allCourses.where((c) => c.enrolledStudentIds.contains(studentId)).toList();
  }

  @override
  Future<List<Course>> getCoursesForTeacher(String teacherId) async {
    final allCourses = await getAllCourses();
    return allCourses.where((c) => c.teacherId == teacherId).toList();
  }

  @override
  Future<Course?> getCourseById(String courseId) async {
    final allCourses = await getAllCourses();
    try {
      return allCourses.firstWhere((c) => c.id == courseId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Course> createCourse(Course course) async {
    final courses = await getAllCourses();
    courses.add(course);
    await _courseStorageService.saveCourses(courses);
    return course;
  }

  @override
  Future<Course> updateCourse(Course course) async {
    final courses = await getAllCourses();
    final index = courses.indexWhere((c) => c.id == course.id);
    
    if (index == -1) {
      throw Exception('Course not found');
    }

    courses[index] = course.copyWith(updatedAt: DateTime.now());
    await _courseStorageService.saveCourses(courses);
    return courses[index];
  }

  @override
  Future<bool> deleteCourse(String courseId) async {
    final courses = await getAllCourses();
    final initialLength = courses.length;
    courses.removeWhere((c) => c.id == courseId);
    
    if (courses.length == initialLength) {
      return false;
    }

    await _courseStorageService.saveCourses(courses);
    return true;
  }

  @override
  Future<bool> enrollStudent(String courseId, String studentId) async {
    final course = await getCourseById(courseId);
    if (course == null) return false;

    if (course.enrolledStudentIds.contains(studentId)) {
      return true; // Already enrolled
    }

    final updatedCourse = course.copyWith(
      enrolledStudentIds: [...course.enrolledStudentIds, studentId],
    );
    await updateCourse(updatedCourse);
    return true;
  }

  @override
  Future<bool> unenrollStudent(String courseId, String studentId) async {
    final course = await getCourseById(courseId);
    if (course == null) return false;

    final updatedStudentIds = List<String>.from(course.enrolledStudentIds)
      ..remove(studentId);
    
    final updatedCourse = course.copyWith(enrolledStudentIds: updatedStudentIds);
    await updateCourse(updatedCourse);
    return true;
  }

  @override
  Future<Course> addMaterial(String courseId, CourseMaterial material) async {
    final course = await getCourseById(courseId);
    if (course == null) {
      throw Exception('Course not found');
    }

    final updatedCourse = course.copyWith(
      materials: [...course.materials, material],
    );
    return updateCourse(updatedCourse);
  }

  @override
  Future<Course> addAssignment(String courseId, Assignment assignment) async {
    final course = await getCourseById(courseId);
    if (course == null) {
      throw Exception('Course not found');
    }

    final updatedCourse = course.copyWith(
      assignments: [...course.assignments, assignment],
    );
    return updateCourse(updatedCourse);
  }
}
