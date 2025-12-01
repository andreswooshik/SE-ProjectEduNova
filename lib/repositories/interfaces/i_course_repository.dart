import '../../models/course.dart';

/// Interface Segregation Principle: Focused interface for course operations
/// Dependency Inversion Principle: Providers depend on this abstraction
abstract class ICourseRepository {
  /// Get all courses
  Future<List<Course>> getAllCourses();

  /// Get courses for a specific student
  Future<List<Course>> getCoursesForStudent(String studentId);

  /// Get courses created by a specific teacher
  Future<List<Course>> getCoursesForTeacher(String teacherId);

  /// Get a course by ID
  Future<Course?> getCourseById(String courseId);

  /// Create a new course
  Future<Course> createCourse(Course course);

  /// Update an existing course
  Future<Course> updateCourse(Course course);

  /// Delete a course
  Future<bool> deleteCourse(String courseId);

  /// Enroll a student in a course
  Future<bool> enrollStudent(String courseId, String studentId);

  /// Unenroll a student from a course
  Future<bool> unenrollStudent(String courseId, String studentId);

  /// Add material to a course
  Future<Course> addMaterial(String courseId, CourseMaterial material);

  /// Add assignment to a course
  Future<Course> addAssignment(String courseId, Assignment assignment);
}
