import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quiz_data.dart';

const double passingPercentage = 70;
const int certificateValidityDays = 30;

class QuizState {
  final bool hasReviewedMaterial;
  final int currentQuestionIndex;
  final Map<String, int> selectedAnswers;
  final bool isFinished;
  final DateTime? issueDate;

  QuizState({
    this.hasReviewedMaterial = false,
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const {},
    this.isFinished = false,
    this.issueDate,
  });

  QuizState copyWith({
    bool? hasReviewedMaterial,
    int? currentQuestionIndex,
    Map<String, int>? selectedAnswers,
    bool? isFinished,
    DateTime? issueDate,
  }) {
    return QuizState(
      hasReviewedMaterial: hasReviewedMaterial ?? this.hasReviewedMaterial,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isFinished: isFinished ?? this.isFinished,
      issueDate: issueDate ?? this.issueDate,
    );
  }

  int get correctAnswers {
    int count = 0;
    for (int i = 0; i < quizQuestions.length; i++) {
      final q = quizQuestions[i];
      if (selectedAnswers[q.id] == q.correctAnswerIndex) {
        count++;
      }
    }
    return count;
  }

  int get incorrectAnswers => quizQuestions.length - correctAnswers;

  double get percentage =>
      quizQuestions.isEmpty ? 0 : (correctAnswers / quizQuestions.length) * 100;

  bool get isApproved => percentage >= passingPercentage;
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(QuizState());

  void setMaterialReviewed(bool value) {
    state = state.copyWith(hasReviewedMaterial: value);
  }

  void selectAnswer(String questionId, int answerIndex) {
    final newAnswers = Map<String, int>.from(state.selectedAnswers);
    newAnswers[questionId] = answerIndex;
    state = state.copyWith(selectedAnswers: newAnswers);
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < quizQuestions.length - 1) {
      state =
          state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state =
          state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1);
    }
  }

  void finishQuiz() {
    state = state.copyWith(
      isFinished: true,
      issueDate: state.percentage >= passingPercentage ? DateTime.now() : null,
    );
  }

  void resetQuiz() {
    state = QuizState(hasReviewedMaterial: true); // Mantenemos la revisión
  }

  void fullReset() {
    state = QuizState();
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});
