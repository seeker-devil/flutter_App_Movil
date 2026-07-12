class QuizQuestion {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  const QuizQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });
}
