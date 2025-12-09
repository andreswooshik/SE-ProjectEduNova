import '../models/course.dart';
import '../models/course_analytics.dart';

/// Course Service
/// Single Responsibility: Handles all course-related operations
/// Following Repository Pattern for data access
class CourseService {
  // Simulated database - replace with actual backend calls
  static final List<Course> _courses = [];
  static final Map<String, CourseAnalytics> _analytics = {};
  static final Map<String, List<CourseResource>> _courseResources = {};

  /// Create a new course
  Future<Course> createCourse({
    required String title,
    required String description,
    required String teacherId,
    required CourseCategory category,
    String? thumbnailUrl,
  }) async {
    final course = Course(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      teacherId: teacherId,
      thumbnailUrl: thumbnailUrl,
    );

    _courses.add(course);
    
    // Initialize analytics
    _analytics[course.id] = CourseAnalytics(
      courseId: course.id,
      enrollmentCount: 0,
      completionRate: 0.0,
      averageGrade: 0.0,
      activeStudents: 0,
      totalAssignments: 0,
      submittedAssignments: 0,
      resourceViews: {},
    );

    return course;
  }

  /// Update an existing course
  Future<Course> updateCourse(Course course) async {
    final index = _courses.indexWhere((c) => c.id == course.id);
    if (index != -1) {
      _courses[index] = course;
    }
    return course;
  }

  /// Delete a course
  Future<void> deleteCourse(String courseId) async {
    _courses.removeWhere((c) => c.id == courseId);
    _analytics.remove(courseId);
    _courseResources.remove(courseId);
  }

  /// Archive a course
  Future<void> archiveCourse(String courseId) async {
    // In a real app, update the course status to archived
    // For now, just mark it in a separate list
  }

  /// Get all courses for a teacher
  Future<List<Course>> getCoursesByTeacher(String teacherId) async {
    return _courses.where((c) => c.teacherId == teacherId).toList();
  }

  /// Get course analytics
  Future<CourseAnalytics?> getCourseAnalytics(String courseId) async {
    return _analytics[courseId];
  }

  /// Search courses
  Future<List<Course>> searchCourses(String query) async {
    final lowerQuery = query.toLowerCase();
    return _courses.where((course) {
      return course.title.toLowerCase().contains(lowerQuery) ||
          course.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filter courses by category
  Future<List<Course>> filterCoursesByCategory(
      List<Course> courses, CourseCategory? category) async {
    if (category == null) return courses;
    // In real implementation, Course model should have category field
    return courses;
  }

  /// Sort courses
  List<Course> sortCourses(List<Course> courses, CourseSortOption sortBy) {
    final sortedCourses = List<Course>.from(courses);
    
    switch (sortBy) {
      case CourseSortOption.titleAsc:
        sortedCourses.sort((a, b) => a.title.compareTo(b.title));
        break;
      case CourseSortOption.titleDesc:
        sortedCourses.sort((a, b) => b.title.compareTo(a.title));
        break;
      case CourseSortOption.dateNewest:
        sortedCourses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case CourseSortOption.dateOldest:
        sortedCourses.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
    
    return sortedCourses;
  }

  /// Add resource to course
  Future<void> addResource(String courseId, CourseResource resource) async {
    if (!_courseResources.containsKey(courseId)) {
      _courseResources[courseId] = [];
    }
    _courseResources[courseId]!.add(resource);
  }

  /// Bulk add resources
  Future<void> bulkAddResources(
      String courseId, List<CourseResource> resources) async {
    if (!_courseResources.containsKey(courseId)) {
      _courseResources[courseId] = [];
    }
    _courseResources[courseId]!.addAll(resources);
  }

  /// Get resources for a course
  Future<List<CourseResource>> getCourseResources(String courseId) async {
    return _courseResources[courseId] ?? [];
  }

  /// Update resource view count
  Future<void> incrementResourceView(
      String courseId, String resourceId) async {
    final resources = _courseResources[courseId];
    if (resources != null) {
      final index = resources.indexWhere((r) => r.id == resourceId);
      if (index != -1) {
        resources[index] =
            resources[index].copyWith(viewCount: resources[index].viewCount + 1);
      }
    }
  }

  /// Get resource analytics
  Future<Map<String, int>> getResourceAnalytics(String courseId) async {
    final resources = _courseResources[courseId] ?? [];
    final analytics = <String, int>{};
    
    for (var resource in resources) {
      analytics[resource.id] = resource.viewCount;
    }
    
    return analytics;
  }

  // Mock data generator for demo
  static void generateMockData(String teacherId) {
    // Generate sample analytics
    _analytics['1'] = CourseAnalytics(
      courseId: '1',
      enrollmentCount: 42,
      completionRate: 0.68,
      averageGrade: 85.5,
      activeStudents: 38,
      totalAssignments: 12,
      submittedAssignments: 456,
      resourceViews: {'res1': 234, 'res2': 189, 'res3': 312},
    );

    _analytics['2'] = CourseAnalytics(
      courseId: '2',
      enrollmentCount: 35,
      completionRate: 0.72,
      averageGrade: 88.2,
      activeStudents: 32,
      totalAssignments: 10,
      submittedAssignments: 320,
      resourceViews: {'res4': 156, 'res5': 201},
    );

    _analytics['3'] = CourseAnalytics(
      courseId: '3',
      enrollmentCount: 38,
      completionRate: 0.65,
      averageGrade: 82.7,
      activeStudents: 35,
      totalAssignments: 11,
      submittedAssignments: 385,
      resourceViews: {'res6': 278, 'res7': 145},
    );

    _analytics['4'] = CourseAnalytics(
      courseId: '4',
      enrollmentCount: 29,
      completionRate: 0.70,
      averageGrade: 86.8,
      activeStudents: 27,
      totalAssignments: 9,
      submittedAssignments: 243,
      resourceViews: {'res8': 192, 'res9': 167},
    );

    _analytics['5'] = CourseAnalytics(
      courseId: '5',
      enrollmentCount: 45,
      completionRate: 0.75,
      averageGrade: 90.3,
      activeStudents: 42,
      totalAssignments: 13,
      submittedAssignments: 507,
      resourceViews: {'res10': 389, 'res11': 421},
    );
  }
}

/// Sort options for courses
enum CourseSortOption {
  titleAsc,
  titleDesc,
  dateNewest,
  dateOldest,
}
