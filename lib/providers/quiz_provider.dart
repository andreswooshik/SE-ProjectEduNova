import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.dart';

class QuizNotifier extends Notifier<List<Quiz>> {
  @override
  List<Quiz> build() {
    return [
      Quiz(
        id: '1',
        title: 'Quiz 1',
        description: 'Description here.',
        courseId: '5',
        courseName: 'Cybersecurity',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        duration: 30,
        totalQuestions: 15,
      ),
      Quiz(
        id: '2',
        title: 'Quiz 2',
        description: 'Description here.',
        courseId: '5',
        courseName: 'Cybersecurity',
        dueDate: DateTime.now().add(const Duration(days: 14)),
        duration: 45,
        totalQuestions: 20,
      ),
    ];
  }

  List<Quiz> getQuizzesByCourse(String courseId) {
    return state.where((quiz) => quiz.courseId == courseId).toList();
  }

  void completeQuiz(String quizId, int score) {
    state = [
      for (final quiz in state)
        if (quiz.id == quizId)
          quiz.copyWith(isCompleted: true, score: score)
        else
          quiz,
    ];
  }
}

final quizProvider = NotifierProvider<QuizNotifier, List<Quiz>>(
  QuizNotifier.new,
);
