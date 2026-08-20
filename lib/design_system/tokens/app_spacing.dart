/// Tokens Primitivos y Semánticos de Espaciado para SafeAccess 90.
abstract class AppSpacing {
  // ==========================================
  // TOKENS PRIMITIVOS
  // ==========================================
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Shortcuts breves
  static const double xs = space4;
  static const double sm = space8;
  static const double md = space12;
  static const double lg = space16;
  static const double xl = space24;
  static const double xxl = space32;

  // ==========================================
  // TOKENS SEMÁNTICOS
  // ==========================================
  static const double spacingPage = lg;       // 16.0 - Margen exterior de la página
  static const double spacingSection = lg;    // 16.0 - Distancia entre tarjetas/secciones
  static const double spacingComponent = md;  // 12.0 - Espacio entre controles dentro de un módulo
  static const double spacingInline = sm;     // 8.0  - Espacio entre ícono y texto
}
