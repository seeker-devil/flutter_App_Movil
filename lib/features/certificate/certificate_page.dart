import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/app_scaffold.dart';
import '../quiz/quiz_controller.dart';

class CertificatePage extends ConsumerWidget {
  const CertificatePage({super.key});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizProvider);

    if (!state.isApproved || state.issueDate == null) {
      return AppScaffold(
        title: 'Certificado no disponible',
        child: Center(
          child: FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Volver al inicio'),
          ),
        ),
      );
    }

    final issueDate = state.issueDate!;
    final expirationDate =
        issueDate.add(const Duration(days: certificateValidityDays));

    return AppScaffold(
      title: 'Certificado',
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.amber, width: 8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5))
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.workspace_premium,
                          size: 80, color: Colors.amber),
                      const SizedBox(height: 24),
                      Text(
                        'CERTIFICADO DE APROBACIÓN',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const Text('Se otorga a:'),
                      const SizedBox(height: 8),
                      Text(
                        'Participante de demostración',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                          'Por haber completado con éxito la capacitación:'),
                      const SizedBox(height: 8),
                      Text(
                        'Capacitación Genérica',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Porcentaje obtenido: ${state.percentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Fecha de emisión:',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(_formatDate(issueDate),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Fecha de vencimiento:',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(_formatDate(expirationDate),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Validez: $certificateValidityDays días',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Este es un certificado de demostración.',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reiniciar proceso'),
                  onPressed: () {
                    ref.read(quizProvider.notifier).fullReset();
                    context.go('/');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
