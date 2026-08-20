import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// COMPONENTE 4: SafeAccessSectionCard
///
/// Tarjeta de sección modular para estructurar bloques temáticos de interfaz.
/// Utiliza tokens semánticos de color, radio de borde (`radiusCard`) y espaciado.
///
/// NO consulta backend, NO conoce rutas ni endpoints.
class SafeAccessSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final String? subtitle;
  final IconData? leadingIcon;
  final EdgeInsetsGeometry? padding;

  const SafeAccessSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.leadingIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.colorSurface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusCard,
        side: const BorderSide(color: AppColors.colorBorder, width: 1),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    color: AppColors.colorPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.colorTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.colorTextSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
