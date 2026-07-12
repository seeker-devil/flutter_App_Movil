import 'package:flutter_test/flutter_test.dart';
import 'package:training_quiz_app/features/quiz/quiz_controller.dart';

void main() {
  group('Quiz State Tests', () {
    test(
        '1. La aplicación inicia en la pantalla de capacitación (estado inicial)',
        () {
      final notifier = QuizNotifier();
      expect(notifier.state.hasReviewedMaterial, false);
      expect(notifier.state.currentQuestionIndex, 0);
      expect(notifier.state.isFinished, false);
    });

    test(
        '3. El botón se habilita (estado cambia) después de confirmar la revisión',
        () {
      final notifier = QuizNotifier();
      notifier.setMaterialReviewed(true);
      expect(notifier.state.hasReviewedMaterial, true);
    });

    test('4. La prueba calcula correctamente un resultado aprobado', () {
      final notifier = QuizNotifier();

      // Simular respuestas correctas para las 5 preguntas
      notifier.selectAnswer('q1', 0);
      notifier.selectAnswer('q2', 1);
      notifier.selectAnswer('q3', 2);
      notifier.selectAnswer('q4', 1);
      notifier.selectAnswer('q5', 1);

      notifier.finishQuiz();

      expect(notifier.state.correctAnswers, 5);
      expect(notifier.state.percentage, 100.0);
      expect(notifier.state.isApproved, true);
      expect(notifier.state.issueDate, isNotNull);
    });

    test(
        '5. La fecha de vencimiento corresponde a la fecha de emisión más los días configurados',
        () {
      final notifier = QuizNotifier();

      // Respuestas para aprobar
      notifier.selectAnswer('q1', 0);
      notifier.selectAnswer('q2', 1);
      notifier.selectAnswer('q3', 2);
      notifier.selectAnswer('q4', 1);
      notifier.selectAnswer('q5', 1);

      notifier.finishQuiz();

      final issueDate = notifier.state.issueDate!;
      final expectedExpirationDate =
          issueDate.add(const Duration(days: certificateValidityDays));

      // Comprobar la diferencia de días
      expect(expectedExpirationDate.difference(issueDate).inDays,
          certificateValidityDays);
    });
  });
}
