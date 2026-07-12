import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/app_scaffold.dart';
import '../quiz/quiz_controller.dart';

const String trainingUrl = 'https://www.example.com';

class TrainingPage extends ConsumerStatefulWidget {
  const TrainingPage({super.key});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
  Future<void> _openTrainingMaterial() async {
    final uri = Uri.parse(trainingUrl);

    final opened = await launchUrl(
      uri,
      webOnlyWindowName: '_blank',
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No fue posible abrir el material de capacitación.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasReviewed = ref.watch(quizProvider).hasReviewedMaterial;

    return AppScaffold(
      title: 'Capacitación',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Por favor, revisa el siguiente material de capacitación '
              'antes de proceder a la evaluación.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 56,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Material de capacitación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'El material se abrirá en una nueva pestaña '
                      'del navegador.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _openTrainingMaterial,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Revisar material'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: hasReviewed,
              onChanged: (value) {
                ref
                    .read(quizProvider.notifier)
                    .setMaterialReviewed(value ?? false);
              },
              title: const Text(
                'Confirmo que revisé el material',
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const Spacer(),
            FilledButton(
              onPressed: hasReviewed
                  ? () {
                      context.go('/quiz');
                    }
                  : null,
              child: const Text('Iniciar prueba'),
            ),
          ],
        ),
      ),
    );
  }
}
