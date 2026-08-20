import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Tipos semánticos de estado para SafeAccessStatusCard.
enum SafeAccessStatus {
  info,
  success,
  warning,
  error,
}

/// COMPONENTE 2: SafeAccessStatusCard
///
/// Tarjeta para comunicar retroalimentación del sistema (Información, Éxito, Advertencia, Error).
/// Cumple WCAG 1.4.1 al combinar color semántico, ícono característico y texto descriptivo.
///
/// NO consulta backend, NO conoce rutas de navegación ni endpoints.
class SafeAccessStatusCard extends StatelessWidget {
  final String title;
  final String message;
  final SafeAccessStatus status;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onAction;
  final String? actionLabel;

  const SafeAccessStatusCard({
    super.key,
    required this.title,
    required this.message,
    this.status = SafeAccessStatus.info,
    this.icon,
    this.trailing,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final style = _getStatusStyle(status);

    return Semantics(
      container: true,
      liveRegion: true,
      label: '${style.semanticPrefix}: $title. $message',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: AppRadius.radiusCard,
          border: Border.all(color: style.borderColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon ?? style.defaultIcon,
                  color: style.contentColor,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: style.contentColor,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 14,
                          color: style.contentColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  trailing!,
                ],
              ],
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(actionLabel!),
                  style: TextButton.styleFrom(
                    foregroundColor: style.contentColor,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _StatusStyle _getStatusStyle(SafeAccessStatus status) {
    switch (status) {
      case SafeAccessStatus.info:
        return _StatusStyle(
          backgroundColor: AppColors.colorPrimaryContainer,
          borderColor: AppColors.blue500,
          contentColor: AppColors.colorOnPrimaryContainer,
          defaultIcon: Icons.info_outline,
          semanticPrefix: 'Información',
        );
      case SafeAccessStatus.success:
        return _StatusStyle(
          backgroundColor: AppColors.colorSuccessContainer,
          borderColor: AppColors.green700,
          contentColor: AppColors.colorOnSuccessContainer,
          defaultIcon: Icons.check_circle_outline,
          semanticPrefix: 'Éxito',
        );
      case SafeAccessStatus.warning:
        return _StatusStyle(
          backgroundColor: AppColors.colorWarningContainer,
          borderColor: AppColors.amber700,
          contentColor: AppColors.colorOnWarningContainer,
          defaultIcon: Icons.warning_amber_rounded,
          semanticPrefix: 'Advertencia',
        );
      case SafeAccessStatus.error:
        return _StatusStyle(
          backgroundColor: AppColors.colorErrorContainer,
          borderColor: AppColors.red700,
          contentColor: AppColors.colorOnErrorContainer,
          defaultIcon: Icons.error_outline,
          semanticPrefix: 'Error',
        );
    }
  }
}

class _StatusStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color contentColor;
  final IconData defaultIcon;
  final String semanticPrefix;

  _StatusStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.contentColor,
    required this.defaultIcon,
    required this.semanticPrefix,
  });
}
