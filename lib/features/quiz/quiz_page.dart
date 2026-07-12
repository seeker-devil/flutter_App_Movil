import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/app_scaffold.dart';
import 'quiz_controller.dart';
import 'quiz_data.dart';

class QuizPage extends ConsumerWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);
    final notifier = ref.read(quizProvider.notifier);

    if (!quizState.hasReviewedMaterial) {
      return AppScaffold(
        title: 'Acceso denegado',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Debes confirmar que revisaste el material.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Volver al material'),
              )
            ],
          ),
        ),
      );
    }

    if (quizState.isFinished) {
      return _buildResult(context, quizState, notifier);
    }

    final currentQuestion = quizQuestions[quizState.currentQuestionIndex];
    final selectedAnswer = quizState.selectedAnswers[currentQuestion.id];
    final isLastQuestion =
        quizState.currentQuestionIndex == quizQuestions.length - 1;

    return AppScaffold(
      title: 'Evaluación',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value:
                  (quizState.currentQuestionIndex + 1) / quizQuestions.length,
            ),
            const SizedBox(height: 16),
            Text(
              'Pregunta ${quizState.currentQuestionIndex + 1} de ${quizQuestions.length}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            Text(
              currentQuestion.text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: RadioGroup<int>(
                groupValue: selectedAnswer,
                onChanged: (value) {
                  if (value != null) {
                    notifier.selectAnswer(currentQuestion.id, value);
                  }
                },
                child: ListView.builder(
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    final option = currentQuestion.options[index];

                    return RadioListTile<int>(
                      title: Text(option),
                      value: index,
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: quizState.currentQuestionIndex > 0
                      ? notifier.previousQuestion
                      : null,
                  child: const Text('Anterior'),
                ),
                FilledButton(
                  onPressed: selectedAnswer == null
                      ? null
                      : (isLastQuestion
                          ? () => _confirmFinish(context, notifier)
                          : notifier.nextQuestion),
                  child:
                      Text(isLastQuestion ? 'Finalizar prueba' : 'Siguiente'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _confirmFinish(BuildContext context, QuizNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Finalizar prueba?'),
        content:
            const Text('¿Estás seguro de que deseas enviar tus respuestas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.finishQuiz();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(
      BuildContext context, QuizState state, QuizNotifier notifier) {
    if (state.isApproved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/certificate');
      });
      return const AppScaffold(
          title: 'Procesando...',
          child: Center(child: CircularProgressIndicator()));
    }

    return AppScaffold(
      title: 'Resultado',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cancel_outlined, color: Colors.red, size: 80),
              const SizedBox(height: 24),
              Text(
                'No has aprobado',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text('Puntaje: ${state.percentage.toStringAsFixed(0)}%'),
              Text('Respuestas correctas: ${state.correctAnswers}'),
              Text('Respuestas incorrectas: ${state.incorrectAnswers}'),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: notifier.resetQuiz,
                child: const Text('Intentar nuevamente'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  notifier.fullReset();
                  context.go('/');
                },
                child: const Text('Volver al material'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
