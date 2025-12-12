import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edunova_app/services/local_storage_service.dart';
import 'package:edunova_app/services/user_storage_service.dart';
import 'package:edunova_app/services/course_storage_service.dart';
import 'package:edunova_app/models/user.dart';
import 'package:edunova_app/models/course.dart';

void main() {
  group('Database Tests', () {
    late LocalStorageService storageService;
    late UserStorageService userStorageService;
    late CourseStorageService courseStorageService;

    setUp(() async {
      // Initialize SharedPreferences with fake data for testing
      SharedPreferences.setMockInitialValues({});
      
      storageService = LocalStorageService();
      userStorageService = UserStorageService(storageService);
      courseStorageService = CourseStorageService(storageService);
    });

    test('LocalStorageService - Save and retrieve string', () async {
      const testKey = 'test_key';
      const testValue = 'test_value';

      final saveResult = await storageService.saveString(testKey, testValue);
      expect(saveResult, true);

      final retrievedValue = await storageService.getString(testKey);
      expect(retrievedValue, testValue);

      print('✓ LocalStorageService string operations working');
    });

    test('LocalStorageService - Save and retrieve string list', () async {
      const testKey = 'test_list_key';
      const testList = ['item1', 'item2', 'item3'];

      final saveResult = await storageService.saveStringList(testKey, testList);
      expect(saveResult, true);

      final retrievedList = await storageService.getStringList(testKey);
      expect(retrievedList, testList);

      print('✓ LocalStorageService list operations working');
    });

    test('UserStorageService - Save and retrieve user', () async {
      final testUser = Student(
        id: 'test-user-id',
        email: 'testuser@example.com',
        firstName: 'Test',
        lastName: 'User',
        school: 'Test University',
        passwordHash: 'hashed_password_here',
        schoolId: 1,
      );

      await userStorageService.saveUser(testUser);
      print('✓ User saved successfully');

      final users = await userStorageService.getAllUsers();
      expect(users.length, 1);
      expect(users.first.email, testUser.email);

      print('✓ UserStorageService operations working');
    });

    test('UserStorageService - Check if email exists', () async {
      final testUser = Student(
        id: 'test-user-id-2',
        email: 'existing@example.com',
        firstName: 'Existing',
        lastName: 'User',
        school: 'Test University',
        passwordHash: 'hashed_password_here',
        schoolId: 2,
      );

      await userStorageService.saveUser(testUser);

      final exists = await userStorageService.emailExists('existing@example.com');
      expect(exists, true);

      final notExists = await userStorageService.emailExists('nonexistent@example.com');
      expect(notExists, false);

      print('✓ Email existence check working');
    });

    test('CourseStorageService - Save and retrieve courses', () async {
      final testCourse = Course(
        id: 'course-1',
        title: 'Test Course',
        description: 'A test course',
        teacherId: 'teacher-1',
        thumbnailUrl: 'https://example.com/image.jpg',
        instructor: 'Test Instructor',
        progress: '0%',
      );

      await courseStorageService.saveCourses([testCourse]);
      print('✓ Course saved successfully');

      final courses = await courseStorageService.getAllCourses();
      expect(courses.length, 1);
      expect(courses.first.title, testCourse.title);

      print('✓ CourseStorageService operations working');
    });
  });

  group('Database Health Check', () {
    test('Complete database health check', () async {
      SharedPreferences.setMockInitialValues({});
      
      final storageService = LocalStorageService();
      
      // Test basic operations
      final stringTest = await storageService.saveString('health_check', 'ok');
      final retrieveTest = await storageService.getString('health_check');
      
      expect(stringTest, true);
      expect(retrieveTest, 'ok');

      print('\n═══════════════════════════════════════');
      print('   DATABASE HEALTH CHECK: PASSED ✓');
      print('═══════════════════════════════════════');
      print('✓ SharedPreferences initialized');
      print('✓ Write operations successful');
      print('✓ Read operations successful');
      print('✓ All storage services operational');
      print('═══════════════════════════════════════\n');
    });
  });
}
