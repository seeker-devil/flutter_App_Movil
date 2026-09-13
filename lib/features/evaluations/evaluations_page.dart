import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/components/safe_access_button.dart';
import '../../design_system/components/safe_access_section_card.dart';
import '../../design_system/components/safe_access_status_card.dart';
import '../../design_system/tokens/app_colors.dart';
import '../../design_system/tokens/app_spacing.dart';
import '../../design_system/tokens/app_typography.dart';
import '../../providers/app_providers.dart';
import '../../services/evaluations_api_service.dart';
import '../../shared/app_scaffold.dart';

class EvaluationsPage extends ConsumerStatefulWidget {
  const EvaluationsPage({super.key});

  @override
  ConsumerState<EvaluationsPage> createState() => _EvaluationsPageState();
}

class _EvaluationsPageState extends ConsumerState<EvaluationsPage> {
  bool _isLoading = false;
  String? _errorMessage;
  List<EvaluationItem> _evaluations = [];

  @override
  void initState() {
    super.initState();
    _loadEvaluations();
  }

  Future<void> _loadEvaluations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(evaluationsApiServiceProvider);
      final list = await api.fetchEvaluations();
      if (mounted) {
        setState(() {
          _evaluations = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showCreateDialog() async {
    final titleController = TextEditingController();
    final scoreController = TextEditingController(text: '80');
    bool isActive = true;

    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Evaluación'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título de la evaluación',
                    hintText: 'Ej. Evaluación de Seguridad Industrial',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: scoreController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Puntaje de aprobación (%)',
                    hintText: 'Ej. 70 - 100',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  title: const Text('Estado Activo'),
                  value: isActive,
                  onChanged: (val) {
                    setDialogState(() => isActive = val);
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final score = int.tryParse(scoreController.text) ?? 80;
              if (title.isEmpty) return;

              try {
                final api = ref.read(evaluationsApiServiceProvider);
                await api.createEvaluation(
                  title: title,
                  passingScore: score,
                  active: isActive,
                );
                if (ctx.mounted) Navigator.pop(ctx, true);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (created == true) {
      _loadEvaluations();
    }
  }

  Future<void> _showEditDialog(EvaluationItem item) async {
    final titleController = TextEditingController(text: item.title);
    final scoreController =
        TextEditingController(text: item.passingScore.toString());
    bool isActive = item.active;

    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Editar Evaluación #${item.id}'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título de la evaluación',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: scoreController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Puntaje de aprobación (%)',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  title: const Text('Estado Activo'),
                  value: isActive,
                  onChanged: (val) {
                    setDialogState(() => isActive = val);
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final score = int.tryParse(scoreController.text) ?? item.passingScore;

              try {
                final api = ref.read(evaluationsApiServiceProvider);
                await api.updateEvaluation(
                  item.id,
                  title: title,
                  passingScore: score,
                  active: isActive,
                );
                if (ctx.mounted) Navigator.pop(ctx, true);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (updated == true) {
      _loadEvaluations();
    }
  }

  Future<void> _showDeleteConfirm(EvaluationItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Desactivar Evaluación?'),
        content: Text(
          'La evaluación "${item.title}" será marcada como inactiva (baja lógica, active = false). No se eliminará físicamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.colorError),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final api = ref.read(evaluationsApiServiceProvider);
        await api.deleteEvaluation(item.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Evaluación desactivada exitosamente (active = false).'),
            ),
          );
        }
        _loadEvaluations();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al desactivar: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Gestión de Evaluaciones (CRUD)',
      child: RefreshIndicator(
        onRefresh: _loadEvaluations,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeAccessSectionCard(
                title: 'Administración de Cuestionarios',
                subtitle:
                    'Gestión CRUD directa contra la REST API NestJS (Creación, Lectura, Edición y Baja Lógica).',
                leadingIcon: Icons.assignment_turned_in,
                child: Row(
                  children: [
                    Expanded(
                      child: SafeAccessButton(
                        label: 'Nueva Evaluación',
                        icon: Icons.add,
                        onPressed: _showCreateDialog,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Actualizar lista',
                      onPressed: _loadEvaluations,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                SafeAccessStatusCard(
                  title: 'Error de Red / Carga',
                  message: _errorMessage!,
                  status: SafeAccessStatus.error,
                  actionLabel: 'Reintentar',
                  onAction: _loadEvaluations,
                )
              else if (_evaluations.isEmpty)
                const SafeAccessStatusCard(
                  title: 'Sin Evaluaciones',
                  message: 'No existen evaluaciones registradas en el backend.',
                  status: SafeAccessStatus.info,
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _evaluations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = _evaluations[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.active
                              ? AppColors.colorSuccessContainer
                              : AppColors.colorErrorContainer,
                          child: Icon(
                            item.active ? Icons.check_circle : Icons.block,
                            color: item.active ? AppColors.colorSuccess : AppColors.colorError,
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: AppTypography.title.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration:
                                item.active ? null : TextDecoration.lineThrough,
                          ),
                        ),
                        subtitle: Text(
                          'ID: ${item.id} | Puntaje Mínimo: ${item.passingScore}% | Estado: ${item.active ? "ACTIVA" : "DESACTIVADA"}',
                          style: AppTypography.caption,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Editar',
                              onPressed: () => _showEditDialog(item),
                            ),
                            if (item.active)
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                tooltip: 'Desactivar (Baja lógica)',
                                onPressed: () => _showDeleteConfirm(item),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver a Capacitación'),
                  onPressed: () => context.go('/'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
