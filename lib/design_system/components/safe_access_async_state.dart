import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import 'safe_access_button.dart';
import 'safe_access_status_card.dart';

/// COMPONENTE 3: SafeAccessAsyncState (OBLIGATORIO)
///
/// Gestor declarativo para resolver los 4 estados de flujos asíncronos en UI:
/// - Cargando (Loading)
/// - Vacío (Empty)
/// - Error (Error con opción de reintentar)
/// - Contenido (Content delegado mediante `child`)
///
/// NO consulta backend, NO conoce rutas ni endpoints.
class SafeAccessAsyncState extends StatelessWidget {
  final bool isLoading;
  final Object? error;
  final bool isEmpty;
  final Widget child;
  final VoidCallback? onRetry;
  final String? loadingMessage;
  final String? emptyMessage;
  final String? errorMessage;

  const SafeAccessAsyncState({
    super.key,
    this.isLoading = false,
    this.error,
    this.isEmpty = false,
    required this.child,
    this.onRetry,
    this.loadingMessage,
    this.emptyMessage,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                loadingMessage ?? 'Cargando datos del servidor...',
                style: const TextStyle(
                  color: AppColors.colorTextSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      final messageText = errorMessage ?? error.toString();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeAccessStatusCard(
              title: 'Error de conexión',
              message: messageText,
              status: SafeAccessStatus.error,
              onAction: onRetry,
              actionLabel: 'Reintentar conexión',
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              SafeAccessButton(
                label: 'Reintentar',
                icon: Icons.refresh,
                variant: SafeAccessButtonVariant.outline,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      );
    }

    if (isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: SafeAccessStatusCard(
          title: 'Sin información',
          message: emptyMessage ?? 'No se encontraron registros disponibles.',
          status: SafeAccessStatus.info,
          icon: Icons.inbox_outlined,
        ),
      );
    }

    return child;
  }
}
