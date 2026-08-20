# Guía de Código Fuente para el Informe PDF — SafeAccess 90

Este documento especifica los archivos y fragmentos exactos de código fuente que deben incluirse en el informe técnico final en PDF como texto seleccionable.

---

## 1. Sistema de Tokens Primitivos y Semánticos

- **Colores Semánticos y Primitivos**:
  - Archivo: [`lib/design_system/tokens/app_colors.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/tokens/app_colors.dart)
  - Extracto clave: Definición de paletas primitives (`slate`, `blue`, `green`, `red`) y semánticas (`colorPrimary`, `colorSurface`, `colorSuccess`, `colorError`).

- **Espaciados y Radios**:
  - Archivo: [`lib/design_system/tokens/app_spacing.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/tokens/app_spacing.dart)
  - Archivo: [`lib/design_system/tokens/app_radius.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/tokens/app_radius.dart)

---

## 2. Configuración Central de Tema Accesible

- **ThemeData y ColorScheme**:
  - Archivo: [`lib/design_system/theme/app_theme.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/theme/app_theme.dart)
  - Extracto clave: Integración de `ColorScheme` basado en tokens con soporte WCAG 2.1 AA.

---

## 3. Catálogo de Componentes Reutilizables

1. **`SafeAccessButton`**:
   - Archivo: [`lib/design_system/components/safe_access_button.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/components/safe_access_button.dart)
   - Contenido a incluir: Clase principal, variantes enum, `ConstrainedBox` de toque mínimo y envoltorio `Semantics`.

2. **`SafeAccessStatusCard`**:
   - Archivo: [`lib/design_system/components/safe_access_status_card.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/components/safe_access_status_card.dart)
   - Contenido a incluir: Mapeo de íconos/colores semánticos y soporte para acciones secundarias.

3. **`SafeAccessAsyncState`**:
   - Archivo: [`lib/design_system/components/safe_access_async_state.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/components/safe_access_async_state.dart)
   - Contenido a incluir: Manejo declarativo de los 4 estados (`isLoading`, `error`, `isEmpty`, `child`).

4. **`SafeAccessSectionCard`**:
   - Archivo: [`lib/design_system/components/safe_access_section_card.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/components/safe_access_section_card.dart)
   - Contenido a incluir: Estructura de agrupación modular con tokens de espaciado y radio.

---

## 4. Pantalla Real Ensamblada

- **`TrainingPage` Refactorizada**:
  - Archivo: [`lib/features/training/training_page.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/features/training/training_page.dart)
  - Extracto clave: Método `build()` demostrando cómo se componen `SafeAccessSectionCard`, `SafeAccessButton`, `SafeAccessStatusCard` y `SafeAccessAsyncState` manteniendo la lógica de negocio desacoplada.
