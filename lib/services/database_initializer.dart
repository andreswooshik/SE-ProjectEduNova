import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/user.dart';
import 'database_service.dart';

/// Database initializer following Open/Closed Principle
/// Initializes database with default data on first run
class DatabaseInitializer {
  static final DatabaseService _dbService = DatabaseService.instance();

  /// Initialize default data if database is empty
  static Future<void> initializeDefaultData() async {
    try {
      // Check if data already exists
      final existingCourses = await _dbService.fetchAllCourses();
      if (existingCourses.isNotEmpty) {
        print(
            'Database already initialized with ${existingCourses.length} courses');
        return;
      }

      print('Initializing database with default data...');

      // Create default teacher
      final defaultTeacher = Teacher(
        id: 'teacher-1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@edunova.edu',
        school: 'EduNova University',
        passwordHash: 'teacher123',
        employeeId: 10001,
        createdAt: DateTime.now(),
      );
      await _dbService.createUser(defaultTeacher);

      // Create default courses
      final defaultCourses = [
        Course(
          id: 'course-1',
          title: 'Introduction to Flutter',
          description:
              'Learn the basics of Flutter development and build beautiful cross-platform apps.',
          teacherId: defaultTeacher.id,
          instructor: 'John Doe',
          progress: '0%',
          thumbnailAsset: 'assets/images/courses/flutter.png',
          accentColor: Colors.blue,
          createdAt: DateTime.now(),
        ),
        Course(
          id: 'course-2',
          title: 'Advanced Dart Programming',
          description:
              'Master advanced Dart concepts including async programming, streams, and isolates.',
          teacherId: defaultTeacher.id,
          instructor: 'John Doe',
          progress: '0%',
          thumbnailAsset: 'assets/images/courses/dart.png',
          accentColor: Colors.teal,
          createdAt: DateTime.now(),
        ),
        Course(
          id: 'course-3',
          title: 'Mobile UI/UX Design',
          description:
              'Create stunning user interfaces and experiences for mobile applications.',
          teacherId: defaultTeacher.id,
          instructor: 'John Doe',
          progress: '0%',
          thumbnailAsset: 'assets/images/courses/design.png',
          accentColor: Colors.purple,
          createdAt: DateTime.now(),
        ),
        Course(
          id: 'course-4',
          title: 'Firebase Integration',
          description:
              'Learn how to integrate Firebase services into your Flutter applications.',
          teacherId: defaultTeacher.id,
          instructor: 'John Doe',
          progress: '0%',
          thumbnailAsset: 'assets/images/courses/firebase.png',
          accentColor: Colors.orange,
          createdAt: DateTime.now(),
        ),
        Course(
          id: 'course-5',
          title: 'State Management',
          description:
              'Master state management in Flutter using Provider, Riverpod, and Bloc.',
          teacherId: defaultTeacher.id,
          instructor: 'John Doe',
          progress: '0%',
          thumbnailAsset: 'assets/images/courses/state.png',
          accentColor: Colors.green,
          createdAt: DateTime.now(),
        ),
        Course(
          id: 'course-6',
          title: 'API Integration',
          description:
              'Learn to integrate RESTful APIs and handle network requests in Flutter.',
          teacherId: defaultTeacher.id,
          instructor: 'John Doe',
          progress: '0%',
          thumbnailAsset: 'assets/images/courses/api.png',
          accentColor: Colors.red,
          createdAt: DateTime.now(),
        ),
        Course(
          id: 'course-7',
          title: 'Testing in Flutter',
          description:
              'Master unit testing, widget testing, and integration testing in Flutter.',
          teacherId: defaultTeacher.id,
          instructor: 'John Doe',
          progress: '0%',
          thumbnailAsset: 'assets/images/courses/testing.png',
          accentColor: Colors.indigo,
          createdAt: DateTime.now(),
        ),
      ];

      // Insert all courses
      for (var course in defaultCourses) {
        await _dbService.createCourse(course);
      }

      print(
          'Database initialized successfully with ${defaultCourses.length} courses');
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  /// Create a sample student for testing
  static Future<User?> createSampleStudent() async {
    final student = Student(
      id: 'student-1',
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'jane.smith@edunova.edu',
      school: 'EduNova University',
      passwordHash: 'student123',
      schoolId: 1001,
      createdAt: DateTime.now(),
    );

    final success = await _dbService.createUser(student);
    return success ? student : null;
  }

  /// Enroll sample student in all courses
  static Future<void> enrollSampleStudent(String studentId) async {
    final courses = await _dbService.fetchAllCourses();
    for (var course in courses) {
      await _dbService.enrollStudentInCourse(studentId, course.id);
    }
    print('Enrolled student in ${courses.length} courses');
  }
}
