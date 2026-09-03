import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../config/api_config.dart';
import '../../design_system/components/safe_access_async_state.dart';
import '../../design_system/components/safe_access_button.dart';
import '../../design_system/components/safe_access_section_card.dart';
import '../../design_system/components/safe_access_status_card.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../local/database/app_database.dart';
import '../../providers/app_providers.dart';
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
  bool _isSyncing = false;

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
    final opened = await launchUrl(uri, webOnlyWindowName: '_blank');

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No fue posible abrir el material de capacitación.'),
        ),
      );
    }
  }

  /// Create offline attempt immediately in SQLite and enqueue in PendingOperations
  Future<void> _createOfflineAttempt() async {
    final db = ref.read(appDatabaseProvider);
    final clientId = const Uuid().v4();
    final now = DateTime.now();

    // 1. Insert into local AttemptsTable
    await db.saveAttempt(
      AttemptsTableCompanion.insert(
        clientId: clientId,
        evaluationId: 1,
        score: const drift.Value(95),
        status: const drift.Value('APPROVED'),
        startedAt: now,
        finishedAt: drift.Value(now),
        createdAtLocal: now,
        updatedAtLocal: now,
        syncStatus: const drift.Value('PENDING_CREATE'),
      ),
    );

    // 2. Enqueue into PendingOperationsTable
    final payloadJson = '{"evaluationId":1,"score":95,"status":"APPROVED","startedAt":"${now.toIso8601String()}","finishedAt":"${now.toIso8601String()}"}';
    await db.enqueuePendingOperation(
      PendingOperationsTableCompanion.insert(
        clientId: clientId,
        entityType: 'ATTEMPT',
        operationType: 'CREATE',
        payload: payloadJson,
        createdAt: now,
        status: const drift.Value('PENDING'),
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Intento offline guardado en SQLite (clientId: ${clientId.substring(0, 8)}...)'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
    }

    // Try automatic sync trigger
    _triggerSync();
  }

  /// Trigger sync process
  Future<void> _triggerSync() async {
    setState(() {
      _isSyncing = true;
    });

    try {
      final syncService = ref.read(syncServiceProvider);
      final syncedCount = await syncService.processPendingQueue();
      if (mounted && syncedCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Operación(es) sincronizada(s) exitosamente con backend NestJS'),
            backgroundColor: AppColors.colorSuccess,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al sincronizar: $e'),
            backgroundColor: AppColors.colorError,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  /// Handle Logout
  Future<void> _handleLogout() async {
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) {
      context.go('/login');
    }
  }

  String _formatAge(DateTime? date) {
    if (date == null) return 'Sin datos de sincronización';
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Hace ${diff.inSeconds} segundos';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} minutos';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final hasReviewed = ref.watch(quizProvider).hasReviewedMaterial;
    final attemptsAsync = ref.watch(attemptsStreamProvider);
    final userState = ref.watch(authControllerProvider);
    final user = userState.valueOrNull;

    return AppScaffold(
      title: 'SafeAccess 90 — Capacitación & Persistencia',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacingPage),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // TOP BAR: User profile info & Logout button
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.colorSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.colorBorder),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.colorPrimary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.email ?? 'Usuario Autenticado',
                              style: AppTypography.title,
                            ),
                            Text(
                              'Rol: ${user?.role ?? 'PARTICIPANT'} | Token guardado en KeyStore cifrado',
                              style: AppTypography.caption.copyWith(color: AppColors.colorTextSecondary),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _handleLogout,
                        icon: const Icon(Icons.logout, color: AppColors.colorError),
                        label: const Text('Logout', style: TextStyle(color: AppColors.colorError)),
                      ),
                    ],
                  ),
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

                // SECCIÓN 2: Demostración Semana 12 — Base Relacional Drift y Sync Offline
                SafeAccessSectionCard(
                  title: 'Persistencia Local y Sincronización (Semana 12)',
                  leadingIcon: Icons.storage_outlined,
                  subtitle: 'Demostración de lectura local (Drift SQLite), estado de red y cola offline.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Status Bar: Connection & Last Sync Age
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.colorBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.colorBorder),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _apiResult?.success == true ? Icons.wifi : Icons.wifi_off,
                              color: _apiResult?.success == true ? AppColors.colorSuccess : Colors.orange.shade800,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                _apiResult?.success == true
                                    ? 'Estado: En Línea (Backend Disponible)'
                                    : 'Estado: Modo Offline / Local',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _apiResult?.success == true ? AppColors.colorSuccess : Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Actions: Create Offline Attempt & Sync
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          SafeAccessButton(
                            label: 'Registrar Intento Offline (Drift)',
                            icon: Icons.add_circle_outline,
                            onPressed: _createOfflineAttempt,
                            variant: SafeAccessButtonVariant.primary,
                          ),
                          SafeAccessButton(
                            label: 'Sincronizar Cola',
                            icon: Icons.sync,
                            isLoading: _isSyncing,
                            onPressed: _triggerSync,
                            variant: SafeAccessButtonVariant.outline,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      const Text('Intentos Registrados en Base SQLite Local:', style: AppTypography.title),
                      const SizedBox(height: AppSpacing.xs),

                      // List of Local Attempts from Drift
                      attemptsAsync.when(
                        data: (attempts) {
                          if (attempts.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                              child: Text(
                                'No hay intentos en la base de datos local. Presiona "Registrar Intento Offline" para crear uno.',
                                style: TextStyle(color: AppColors.colorTextSecondary),
                              ),
                            );
                          }

                          final lastSyncedAt = attempts.first.serverUpdatedAt ?? attempts.first.createdAtLocal;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Antigüedad de datos: ${_formatAge(lastSyncedAt)}',
                                style: AppTypography.caption.copyWith(color: AppColors.colorTextSecondary),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              ...attempts.map((attempt) {
                                final isSynced = attempt.syncStatus == 'SYNCED';
                                final isPending = attempt.syncStatus == 'PENDING_CREATE';

                                return Card(
                                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: isSynced
                                          ? AppColors.colorSuccessContainer
                                          : isPending
                                              ? AppColors.colorWarningContainer
                                              : AppColors.colorErrorContainer,
                                      child: Icon(
                                        isSynced
                                            ? Icons.check_circle_outline
                                            : isPending
                                                ? Icons.pending_actions
                                                : Icons.error_outline,
                                        color: isSynced
                                            ? AppColors.colorSuccess
                                            : isPending
                                                ? AppColors.colorWarning
                                                : AppColors.colorError,
                                      ),
                                    ),
                                    title: Text(
                                      'Intento #${attempt.localId} (Puntaje: ${attempt.score}%)',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('clientId: ${attempt.clientId}'),
                                        if (attempt.serverId != null)
                                          Text('serverId Backend: ${attempt.serverId}'),
                                        Text('Creado local: ${_formatAge(attempt.createdAtLocal)}'),
                                      ],
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isSynced
                                            ? AppColors.colorSuccessContainer
                                            : isPending
                                                ? AppColors.colorWarningContainer
                                                : AppColors.colorErrorContainer,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isSynced
                                              ? AppColors.colorSuccess
                                              : isPending
                                                  ? AppColors.colorWarning
                                                  : AppColors.colorError,
                                        ),
                                      ),
                                      child: Text(
                                        attempt.syncStatus,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isSynced
                                              ? AppColors.colorSuccess
                                              : isPending
                                                  ? AppColors.colorWarning
                                                  : AppColors.colorError,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (err, _) => Text('Error al leer Drift SQLite: $err', style: const TextStyle(color: AppColors.colorError)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingSection),

                // SECCIÓN 3: Estado del Backend (API Health)
                SafeAccessSectionCard(
                  title: 'Estado de Infraestructura Backend (API)',
                  leadingIcon: Icons.api_outlined,
                  subtitle: 'URL Base: ${ApiConfig.baseUrl}',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SafeAccessButton(
                        label: 'Probar conexión con API Health',
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

                // SECCIÓN 4: Confirmación e Inicio de Evaluación
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
