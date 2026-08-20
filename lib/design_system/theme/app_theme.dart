import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Tema accesible y centralizado para SafeAccess 90.
abstract class AppTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.colorPrimary,
      onPrimary: AppColors.colorOnPrimary,
      primaryContainer: AppColors.colorPrimaryContainer,
      onPrimaryContainer: AppColors.colorOnPrimaryContainer,
      secondary: AppColors.slate700,
      onSecondary: AppColors.white,
      surface: AppColors.colorSurface,
      onSurface: AppColors.colorOnSurface,
      surfaceContainerHighest: AppColors.colorSurfaceVariant,
      onSurfaceVariant: AppColors.colorOnSurfaceVariant,
      error: AppColors.colorError,
      onError: AppColors.colorOnError,
      errorContainer: AppColors.colorErrorContainer,
      onErrorContainer: AppColors.colorOnErrorContainer,
      outline: AppColors.colorBorder,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.colorBackground,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Tipografía centralizada
      textTheme: const TextTheme(
        headlineMedium: AppTypography.headline,
        titleLarge: AppTypography.title,
        bodyMedium: AppTypography.body,
        bodySmall: AppTypography.caption,
        labelLarge: AppTypography.button,
      ),

      // Estilos por omisión para tarjetas
      cardTheme: CardThemeData(
        color: AppColors.colorSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusCard,
          side: const BorderSide(color: AppColors.colorBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Estilos por omisión para botones
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.colorPrimary,
          foregroundColor: AppColors.colorOnPrimary,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusButton,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.colorPrimary,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          side: const BorderSide(color: AppColors.colorPrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusButton,
          ),
        ),
      ),
    );
  }
}
