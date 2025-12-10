import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assignment.dart';

/// Provider for managing assignments
/// Follows Single Responsibility Principle - only manages assignment state
class AssignmentNotifier extends Notifier<List<Assignment>> {
  @override
  List<Assignment> build() {
    // Sample assignments for demonstration
    return [
      Assignment(
        id: '1',
        title: 'Assignment 1',
        description:
            'Short written reflection about cybersecurity concepts and the CIA Triad',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        courseId: '5',
        courseName: 'Cybersecurity',
        maxPoints: 100,
      ),
      Assignment(
        id: '2',
        title: 'Assignment 2',
        description: 'Description here.',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        courseId: '5',
        courseName: 'Cybersecurity',
        maxPoints: 100,
      ),
      Assignment(
        id: '3',
        title: 'Assignment 3',
        description: 'Description here.',
        dueDate: DateTime.now().add(const Duration(days: 10)),
        courseId: '5',
        courseName: 'Cybersecurity',
        maxPoints: 100,
      ),
      Assignment(
        id: '4',
        title: 'Assignment 4',
        description: 'Description here.',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        courseId: '5',
        courseName: 'Cybersecurity',
        maxPoints: 100,
      ),
      Assignment(
        id: '5',
        title: 'Assignment 5',
        description: 'Description here.',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        courseId: '5',
        courseName: 'Cybersecurity',
        maxPoints: 100,
      ),
      Assignment(
        id: '6',
        title: 'Assignment 6',
        description: 'Description here.',
        dueDate: DateTime.now().add(const Duration(days: 21)),
        courseId: '5',
        courseName: 'Cybersecurity',
        maxPoints: 100,
      ),
      Assignment(
        id: '7',
        title: 'Assignment 7',
        description: 'Description here.',
        dueDate: DateTime.now().add(const Duration(days: 28)),
        courseId: '5',
        courseName: 'Cybersecurity',
        maxPoints: 100,
      ),
    ];
  }

  /// Get assignments for a specific course
  List<Assignment> getAssignmentsByCourse(String courseId) {
    return state
        .where((assignment) => assignment.courseId == courseId)
        .toList();
  }

  /// Submit an assignment
  void submitAssignment(String assignmentId) {
    state = [
      for (final assignment in state)
        if (assignment.id == assignmentId)
          assignment.copyWith(
            status: AssignmentStatus.submitted,
            submittedAt: DateTime.now(),
          )
        else
          assignment,
    ];
  }

  /// Grade an assignment
  void gradeAssignment(String assignmentId, int score) {
    state = [
      for (final assignment in state)
        if (assignment.id == assignmentId)
          assignment.copyWith(
            status: AssignmentStatus.graded,
            submittedScore: score,
          )
        else
          assignment,
    ];
  }
}

final assignmentProvider =
    NotifierProvider<AssignmentNotifier, List<Assignment>>(
  AssignmentNotifier.new,
);
