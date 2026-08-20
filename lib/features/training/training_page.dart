import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/api_config.dart';
import '../../design_system/components/safe_access_async_state.dart';
import '../../design_system/components/safe_access_button.dart';
import '../../design_system/components/safe_access_section_card.dart';
import '../../design_system/components/safe_access_status_card.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacingPage),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Por favor, revisa el siguiente material de capacitación '
                  'antes de proceder a la evaluación.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.colorTextPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.spacingSection),
                
                // SECCIÓN 1: Material de capacitación
                SafeAccessSectionCard(
                  title: 'Material de capacitación',
                  leadingIcon: Icons.menu_book_outlined,
                  subtitle: 'El material se abrirá en una nueva pestaña del navegador.',
                  child: Column(
                    children: [
                      const Icon(
                        Icons.menu_book_outlined,
                        size: 48,
                        color: AppColors.colorPrimary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SafeAccessButton(
                        label: 'Revisar material',
                        icon: Icons.open_in_new,
                        onPressed: _openTrainingMaterial,
                        variant: SafeAccessButtonVariant.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingSection),

                // SECCIÓN 2: Estado del Backend (API)
                SafeAccessSectionCard(
                  title: 'Estado del Backend (API)',
                  leadingIcon: Icons.api_outlined,
                  subtitle: 'URL Base: ${ApiConfig.baseUrl}',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SafeAccessButton(
                        label: 'Probar conexión con API',
                        icon: Icons.sync_outlined,
                        isLoading: _isLoadingApi,
                        onPressed: _testApiConnection,
                        variant: SafeAccessButtonVariant.outline,
                      ),
                      if (_apiResult != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        SafeAccessAsyncState(
                          isLoading: false,
                          error: null,
                          child: SafeAccessStatusCard(
                            title: _apiResult!.success
                                ? 'Backend conectado correctamente'
                                : 'Error de conexión con el backend',
                            message: '${_apiResult!.message}${_apiResult!.timestamp != null ? '\nTimestamp: ${_apiResult!.timestamp}' : ''}',
                            status: _apiResult!.success
                                ? SafeAccessStatus.success
                                : SafeAccessStatus.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingSection),

                // SECCIÓN 3: Confirmación e Inicio de Evaluación
                SafeAccessSectionCard(
                  title: 'Confirmación de Lectura',
                  leadingIcon: Icons.assignment_turned_in_outlined,
                  child: Column(
                    children: [
                      CheckboxListTile(
                        value: hasReviewed,
                        onChanged: (value) {
                          ref
                              .read(quizProvider.notifier)
                              .setMaterialReviewed(value ?? false);
                        },
                        title: const Text(
                          'Confirmo que revisé el material',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.colorTextPrimary,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.colorPrimary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SafeAccessButton(
                        label: 'Iniciar prueba',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: hasReviewed
                            ? () {
                                context.go('/quiz');
                              }
                            : null,
                        variant: SafeAccessButtonVariant.primary,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
