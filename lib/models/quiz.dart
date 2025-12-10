/// Quiz model representing a course quiz
class Quiz {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String courseName;
  final DateTime dueDate;
  final int duration; // in minutes
  final int totalQuestions;
  final int? score;
  final bool isCompleted;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.courseName,
    required this.dueDate,
    this.duration = 30,
    this.totalQuestions = 10,
    this.score,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'courseName': courseName,
      'dueDate': dueDate.toIso8601String(),
      'duration': duration,
      'totalQuestions': totalQuestions,
      'score': score,
      'isCompleted': isCompleted,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      duration: json['duration'] as int? ?? 30,
      totalQuestions: json['totalQuestions'] as int? ?? 10,
      score: json['score'] as int?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    String? courseId,
    String? courseName,
    DateTime? dueDate,
    int? duration,
    int? totalQuestions,
    int? score,
    bool? isCompleted,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      dueDate: dueDate ?? this.dueDate,
      duration: duration ?? this.duration,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      score: score ?? this.score,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
