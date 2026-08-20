import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Variantes de diseño para SafeAccessButton.
enum SafeAccessButtonVariant {
  primary,
  secondary,
  outline,
}

/// COMPONENTE 1: SafeAccessButton
///
/// Botón estandarizado del sistema de diseño SafeAccess 90.
/// Garantiza un área táctil mínima accesible de 48x48 px,
/// soporte para estados de carga e inhabilitado, e integración con Semantics.
///
/// NO consulta backend, NO conoce rutas de navegación ni endpoints.
class SafeAccessButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final SafeAccessButtonVariant variant;
  final String? semanticLabel;
  final bool isFullWidth;

  const SafeAccessButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = SafeAccessButtonVariant.primary,
    this.semanticLabel,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    final Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingColor(isDisabled),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );

    Widget buttonWidget;

    switch (variant) {
      case SafeAccessButtonVariant.primary:
        buttonWidget = FilledButton(
          onPressed: isDisabled ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.colorPrimary,
            foregroundColor: AppColors.colorOnPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusButton),
          ),
          child: buttonChild,
        );
        break;
      case SafeAccessButtonVariant.secondary:
        buttonWidget = FilledButton.tonal(
          onPressed: isDisabled ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.slate200,
            foregroundColor: AppColors.slate900,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusButton),
          ),
          child: buttonChild,
        );
        break;
      case SafeAccessButtonVariant.outline:
        buttonWidget = OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.colorPrimary,
            side: const BorderSide(color: AppColors.colorPrimary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusButton),
          ),
          child: buttonChild,
        );
        break;
    }

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: semanticLabel ?? label,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 48,
          minWidth: isFullWidth ? double.infinity : 48,
        ),
        child: isFullWidth ? SizedBox(width: double.infinity, child: buttonWidget) : buttonWidget,
      ),
    );
  }

  Color _getLoadingColor(bool isDisabled) {
    if (variant == SafeAccessButtonVariant.outline) {
      return AppColors.colorPrimary;
    }
    return AppColors.colorOnPrimary;
  }
}
