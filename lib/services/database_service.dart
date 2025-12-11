import '../models/user.dart';
import '../models/course.dart';
import 'database_helper.dart';

/// Database service following Dependency Inversion Principle
/// Provides high-level abstraction for database operations
class DatabaseService {
  final DatabaseHelper _dbHelper;

  DatabaseService(this._dbHelper);

  // Factory constructor for easy instantiation
  factory DatabaseService.instance() {
    return DatabaseService(DatabaseHelper.instance);
  }

  // ============== USER OPERATIONS ==============

  Future<bool> createUser(User user) async {
    try {
      await _dbHelper.insertUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> authenticateUser(String email, String password) async {
    final user = await _dbHelper.getUserByEmail(email);
    if (user != null && user.passwordHash == password) {
      return user;
    }
    return null;
  }

  Future<User?> findUserByEmail(String email) async {
    return await _dbHelper.getUserByEmail(email);
  }

  Future<User?> findUserById(String id) async {
    return await _dbHelper.getUserById(id);
  }

  Future<List<User>> fetchAllUsers() async {
    return await _dbHelper.getAllUsers();
  }

  Future<bool> updateUserInfo(User user) async {
    try {
      await _dbHelper.updateUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeUser(String id) async {
    try {
      await _dbHelper.deleteUser(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ============== COURSE OPERATIONS ==============

  Future<bool> createCourse(Course course) async {
    try {
      await _dbHelper.insertCourse(course);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Course?> findCourseById(String id) async {
    return await _dbHelper.getCourseById(id);
  }

  Future<List<Course>> fetchAllCourses() async {
    return await _dbHelper.getAllCourses();
  }

  Future<List<Course>> fetchTeacherCourses(String teacherId) async {
    return await _dbHelper.getCoursesForTeacher(teacherId);
  }

  Future<bool> updateCourseInfo(Course course) async {
    try {
      await _dbHelper.updateCourse(course);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeCourse(String id) async {
    try {
      await _dbHelper.deleteCourse(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ============== ENROLLMENT OPERATIONS ==============

  Future<bool> enrollStudentInCourse(String studentId, String courseId) async {
    try {
      await _dbHelper.enrollStudent(studentId, courseId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unenrollStudentFromCourse(
      String studentId, String courseId) async {
    try {
      await _dbHelper.unenrollStudent(studentId, courseId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Course>> fetchStudentCourses(String studentId) async {
    return await _dbHelper.getCoursesForStudent(studentId);
  }

  Future<bool> checkEnrollmentStatus(String studentId, String courseId) async {
    return await _dbHelper.isStudentEnrolled(studentId, courseId);
  }

  // ============== DATABASE MANAGEMENT ==============

  Future<void> resetDatabase() async {
    await _dbHelper.clearAllData();
  }

  Future<void> closeDatabase() async {
    await _dbHelper.close();
  }
}
