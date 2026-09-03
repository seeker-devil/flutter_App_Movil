# Código Fuente para el Informe Técnico (Text Content) — SafeAccess 90

Este documento consolida todo el código fuente del Sistema de Diseño, Tokens, Tema, Catálogo de Componentes y Pantalla Refactorizada para el proyecto **SafeAccess 90** en formato de texto seleccionable.

---

## 1. TOKENS PRIMITIVOS Y SEMÁNTICOS

### 1.1 `lib/design_system/tokens/app_colors.dart`
```dart
import 'package:flutter/material.dart';

/// Tokens Primitivos y Semánticos de Color para SafeAccess 90.
abstract class AppColors {
  // TOKENS PRIMITIVOS
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue900 = Color(0xFF1E3A8A);

  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate900 = Color(0xFF0F172A);

  static const Color white = Color(0xFFFFFFFF);

  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green700 = Color(0xFF15803D);
  static const Color green900 = Color(0xFF14532D);

  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red700 = Color(0xFFB91C1C);
  static const Color red900 = Color(0xFF7F1D1D);

  static const Color amber50 = Color(0xFFFFFBEB);
  static const Color amber100 = Color(0xFFFEF3C7);
  static const Color amber700 = Color(0xFFB45309);
  static const Color amber900 = Color(0xFF78350F);

  // TOKENS SEMÁNTICOS
  static const Color colorPrimary = blue700;
  static const Color colorOnPrimary = white;
  static const Color colorPrimaryContainer = blue50;
  static const Color colorOnPrimaryContainer = blue900;

  static const Color colorBackground = slate50;
  static const Color colorOnBackground = slate900;
  static const Color colorSurface = white;
  static const Color colorOnSurface = slate900;
  static const Color colorSurfaceVariant = slate100;
  static const Color colorOnSurfaceVariant = slate600;

  static const Color colorTextPrimary = slate900;
  static const Color colorTextSecondary = slate600;

  static const Color colorBorder = slate200;

  static const Color colorSuccess = green700;
  static const Color colorOnSuccess = white;
  static const Color colorSuccessContainer = green50;
  static const Color colorOnSuccessContainer = green900;

  static const Color colorError = red700;
  static const Color colorOnError = white;
  static const Color colorErrorContainer = red50;
  static const Color colorOnErrorContainer = red900;

  static const Color colorWarning = amber700;
  static const Color colorOnWarning = white;
  static const Color colorWarningContainer = amber50;
  static const Color colorOnWarningContainer = amber900;
}
```

### 1.2 `lib/design_system/tokens/app_spacing.dart`
```dart
/// Tokens Primitivos y Semánticos de Espaciado para SafeAccess 90.
abstract class AppSpacing {
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  static const double xs = space4;
  static const double sm = space8;
  static const double md = space12;
  static const double lg = space16;
  static const double xl = space24;
  static const double xxl = space32;

  static const double spacingPage = lg;       // 16.0
  static const double spacingSection = lg;    // 16.0
  static const double spacingComponent = md;  // 12.0
  static const double spacingInline = sm;     // 8.0
}
```

### 1.3 `lib/design_system/tokens/app_radius.dart`
```dart
import 'package:flutter/material.dart';

/// Tokens Primitivos y Semánticos de Radios de Borde para SafeAccess 90.
abstract class AppRadius {
  static const double radiusSmallValue = 4.0;
  static const double radiusMediumValue = 8.0;
  static const double radiusLargeValue = 16.0;

  static final BorderRadius radiusSmall = BorderRadius.circular(radiusSmallValue);
  static final BorderRadius radiusMedium = BorderRadius.circular(radiusMediumValue);
  static final BorderRadius radiusLarge = BorderRadius.circular(radiusLargeValue);

  static final BorderRadius radiusButton = radiusMedium;  // 8.0
  static final BorderRadius radiusCard = radiusLarge;     // 16.0
  static final BorderRadius radiusBadge = radiusSmall;    // 4.0
}
```

### 1.4 `lib/design_system/tokens/app_typography.dart`
```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tokens Primitivos y Semánticos de Tipografía para SafeAccess 90.
abstract class AppTypography {
  static const double fontSizeSmall = 12.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeTitle = 18.0;
  static const double fontSizeHeadline = 22.0;

  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightBold = FontWeight.w700;

  static const TextStyle headline = TextStyle(
    fontSize: fontSizeHeadline,
    fontWeight: fontWeightBold,
    color: AppColors.colorTextPrimary,
    height: 1.3,
  );

  static const TextStyle title = TextStyle(
    fontSize: fontSizeTitle,
    fontWeight: fontWeightMedium,
    color: AppColors.colorTextPrimary,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: fontSizeBody,
    fontWeight: fontWeightRegular,
    color: AppColors.colorTextPrimary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: fontWeightRegular,
    color: AppColors.colorTextSecondary,
    height: 1.4,
  );

  static const TextStyle button = TextStyle(
    fontSize: fontSizeBody,
    fontWeight: fontWeightMedium,
    color: AppColors.colorOnPrimary,
  );
}
```

---

## 2. CONFIGURACIÓN DEL TEMA CENTRALIZADO

### 2.1 `lib/design_system/theme/app_theme.dart`
```dart
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
      
      textTheme: const TextTheme(
        headlineMedium: AppTypography.headline,
        titleLarge: AppTypography.title,
        bodyMedium: AppTypography.body,
        bodySmall: AppTypography.caption,
        labelLarge: AppTypography.button,
      ),

      cardTheme: CardThemeData(
        color: AppColors.colorSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusCard,
          side: const BorderSide(color: AppColors.colorBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

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
```

---

## 3. CATÁLOGO DE COMPONENTES REUTILIZABLES

### 3.1 `lib/design_system/components/safe_access_button.dart`
```dart
import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

enum SafeAccessButtonVariant {
  primary,
  secondary,
  outline,
}

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
```

### 3.2 `lib/design_system/components/safe_access_status_card.dart`
```dart
import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

enum SafeAccessStatus {
  info,
  success,
  warning,
  error,
}

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
```

### 3.3 `lib/design_system/components/safe_access_async_state.dart`
```dart
import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import 'safe_access_button.dart';
import 'safe_access_status_card.dart';

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
```

### 3.4 `lib/design_system/components/safe_access_section_card.dart`
```dart
import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

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
```

---

## 4. PANTALLA REAL REFACTORIZADA CON EL CATÁLOGO

### 4.1 `lib/features/training/training_page.dart`
```dart
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
```
