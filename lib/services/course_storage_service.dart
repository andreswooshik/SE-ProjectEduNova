import 'dart:convert';
import '../core/constants/app_constants.dart';
import '../models/course.dart';
import 'interfaces/i_storage_service.dart';
import 'interfaces/i_course_storage_service.dart';

/// Service responsible for course data persistence
/// Single Responsibility Principle: Handles only course storage logic
class CourseStorageService implements ICourseStorageService {
  final IStorageService _storageService;

  CourseStorageService(this._storageService);

  @override
  Future<List<Course>> getAllCourses() async {
    final coursesJson = await _storageService.getStringList(AppConstants.coursesListKey);
    if (coursesJson == null || coursesJson.isEmpty) return [];

    return coursesJson.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return Course.fromJson(data);
    }).toList();
  }

  @override
  Future<void> saveCourses(List<Course> courses) async {
    final coursesJson = courses.map((c) => jsonEncode(c.toJson())).toList();
    await _storageService.saveStringList(AppConstants.coursesListKey, coursesJson);
  }
}
