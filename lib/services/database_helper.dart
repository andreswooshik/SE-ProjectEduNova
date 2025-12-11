import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/course.dart';

/// Database helper following Single Responsibility Principle
/// Handles all database operations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('edunova.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const intType = 'INTEGER NOT NULL';

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        firstName $textType,
        lastName $textType,
        email $textType UNIQUE,
        password $textType,
        role $textType,
        createdAt $textType
      )
    ''');

    // Courses table
    await db.execute('''
      CREATE TABLE courses (
        id $idType,
        title $textType,
        description $textTypeNullable,
        teacherId $textType,
        instructor $textTypeNullable,
        progress $textTypeNullable,
        thumbnailAsset $textTypeNullable,
        thumbnailUrl $textTypeNullable,
        accentColorValue $intType,
        createdAt $textType,
        FOREIGN KEY (teacherId) REFERENCES users (id)
      )
    ''');

    // Enrollments table (Many-to-Many relationship)
    await db.execute('''
      CREATE TABLE enrollments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId $textType,
        courseId $textType,
        enrolledAt $textType,
        FOREIGN KEY (studentId) REFERENCES users (id),
        FOREIGN KEY (courseId) REFERENCES courses (id),
        UNIQUE(studentId, courseId)
      )
    ''');

    // Modules table
    await db.execute('''
      CREATE TABLE modules (
        id $idType,
        courseId $textType,
        title $textType,
        description $textTypeNullable,
        orderNum $intType,
        createdAt $textType,
        FOREIGN KEY (courseId) REFERENCES courses (id)
      )
    ''');

    // Assignments table
    await db.execute('''
      CREATE TABLE assignments (
        id $idType,
        courseId $textType,
        title $textType,
        description $textTypeNullable,
        dueDate $textTypeNullable,
        createdAt $textType,
        FOREIGN KEY (courseId) REFERENCES courses (id)
      )
    ''');

    // Announcements table
    await db.execute('''
      CREATE TABLE announcements (
        id $idType,
        courseId $textType,
        title $textType,
        content $textType,
        createdAt $textType,
        FOREIGN KEY (courseId) REFERENCES courses (id)
      )
    ''');
  }

  // ============== USER OPERATIONS ==============

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toJson());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<User?> getUserById(String id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(String id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============== COURSE OPERATIONS ==============

  Future<int> insertCourse(Course course) async {
    final db = await database;
    final courseMap = {
      'id': course.id,
      'title': course.title,
      'description': course.description,
      'teacherId': course.teacherId,
      'instructor': course.instructor,
      'progress': course.progress,
      'thumbnailAsset': course.thumbnailAsset,
      'thumbnailUrl': course.thumbnailUrl,
      'accentColorValue': course.accentColor?.value ?? 0xFF2196F3,
      'createdAt': course.createdAt.toIso8601String(),
    };
    return await db.insert('courses', courseMap);
  }

  Future<Course?> getCourseById(String id) async {
    final db = await database;
    final maps = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _courseFromMap(maps.first);
    }
    return null;
  }

  Future<List<Course>> getAllCourses() async {
    final db = await database;
    final result = await db.query('courses', orderBy: 'createdAt DESC');
    return result.map((map) => _courseFromMap(map)).toList();
  }

  Future<List<Course>> getCoursesForTeacher(String teacherId) async {
    final db = await database;
    final result = await db.query(
      'courses',
      where: 'teacherId = ?',
      whereArgs: [teacherId],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => _courseFromMap(map)).toList();
  }

  Future<int> updateCourse(Course course) async {
    final db = await database;
    final courseMap = {
      'id': course.id,
      'title': course.title,
      'description': course.description,
      'teacherId': course.teacherId,
      'instructor': course.instructor,
      'progress': course.progress,
      'thumbnailAsset': course.thumbnailAsset,
      'thumbnailUrl': course.thumbnailUrl,
      'accentColorValue': course.accentColor?.value ?? 0xFF2196F3,
      'createdAt': course.createdAt.toIso8601String(),
    };
    return await db.update(
      'courses',
      courseMap,
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  Future<int> deleteCourse(String id) async {
    final db = await database;
    return await db.delete(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============== ENROLLMENT OPERATIONS ==============

  Future<int> enrollStudent(String studentId, String courseId) async {
    final db = await database;
    return await db.insert('enrollments', {
      'studentId': studentId,
      'courseId': courseId,
      'enrolledAt': DateTime.now().toIso8601String(),
    });
  }

  Future<int> unenrollStudent(String studentId, String courseId) async {
    final db = await database;
    return await db.delete(
      'enrollments',
      where: 'studentId = ? AND courseId = ?',
      whereArgs: [studentId, courseId],
    );
  }

  Future<List<Course>> getCoursesForStudent(String studentId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT c.* FROM courses c
      INNER JOIN enrollments e ON c.id = e.courseId
      WHERE e.studentId = ?
      ORDER BY e.enrolledAt DESC
    ''', [studentId]);
    return result.map((map) => _courseFromMap(map)).toList();
  }

  Future<bool> isStudentEnrolled(String studentId, String courseId) async {
    final db = await database;
    final result = await db.query(
      'enrollments',
      where: 'studentId = ? AND courseId = ?',
      whereArgs: [studentId, courseId],
    );
    return result.isNotEmpty;
  }

  // ============== HELPER METHODS ==============

  Course _courseFromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as String,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      teacherId: map['teacherId'] as String,
      instructor: map['instructor'] as String?,
      progress: map['progress'] as String?,
      thumbnailAsset: map['thumbnailAsset'] as String?,
      thumbnailUrl: map['thumbnailUrl'] as String?,
      accentColor: Color(map['accentColorValue'] as int),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }

  // ============== DATABASE MANAGEMENT ==============

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('enrollments');
    await db.delete('announcements');
    await db.delete('assignments');
    await db.delete('modules');
    await db.delete('courses');
    await db.delete('users');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
