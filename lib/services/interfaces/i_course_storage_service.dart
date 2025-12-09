import '../../models/course.dart';

/// Interface for course storage operations
/// Interface Segregation Principle: Specific interface for course data access
abstract class ICourseStorageService {
  Future<List<Course>> getAllCourses();
  Future<void> saveCourses(List<Course> courses);
}
