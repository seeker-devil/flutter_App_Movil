import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/api_config.dart';
import '../../services/health_api_service.dart';
import '../../shared/app_scaffold.dart';
import '../quiz/quiz_controller.dart';

const String trainingUrl = 'https://www.example.com';

class TrainingPage extends ConsumerStatefulWidget {
  const TrainingPage({super.key});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
  final HealthApiService _healthApiService = HealthApiService();
  bool _isLoadingApi = false;
  HealthResponse? _apiResult;

  Future<void> _testApiConnection() async {
    setState(() {
      _isLoadingApi = true;
      _apiResult = null;
    });

    final result = await _healthApiService.checkHealth();

    if (mounted) {
      setState(() {
        _isLoadingApi = false;
        _apiResult = result;
      });
    }
  }

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
      title: 'SafeAccess 90 - Capacitación',
      child: SingleChildScrollView(
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
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Material de capacitación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'El material se abrirá en una nueva pestaña del navegador.',
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
            Card(
              elevation: 2,
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.api, color: Colors.indigo),
                        SizedBox(width: 8),
                        Text(
                          'Estado del Backend (API)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'URL Base: ${ApiConfig.baseUrl}',
                      style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _isLoadingApi ? null : _testApiConnection,
                      icon: _isLoadingApi
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.sync_outlined),
                      label: const Text('Probar conexión con API'),
                    ),
                    if (_apiResult != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _apiResult!.success
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _apiResult!.success
                                ? Colors.green.shade400
                                : Colors.red.shade400,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _apiResult!.success
                                      ? Icons.check_circle_outline
                                      : Icons.error_outline,
                                  color: _apiResult!.success
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _apiResult!.success
                                        ? 'Backend conectado correctamente'
                                        : 'No fue posible conectar con el backend',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _apiResult!.success
                                          ? Colors.green.shade900
                                          : Colors.red.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _apiResult!.message,
                              style: TextStyle(
                                fontSize: 13,
                                color: _apiResult!.success
                                    ? Colors.green.shade900
                                    : Colors.red.shade900,
                              ),
                            ),
                            if (_apiResult!.timestamp != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Timestamp: ${_apiResult!.timestamp}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 16),
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
