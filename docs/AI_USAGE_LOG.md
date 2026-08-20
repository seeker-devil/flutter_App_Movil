# Registro de Uso de Inteligencia Artificial — SafeAccess 90

Este documento registra la participación transparente de herramientas de Inteligencia Artificial (Google Antigravity AI Assistant) durante la ejecución del taller de Sistema de Diseño, Catálogo de Componentes, Accesibilidad y Comportamiento Adaptativo.

---

## Resumen de Asistencia de IA

- **Auditoría e Inspección de Código**: Asistencia en la exploración estructurada del repositorio Flutter (`training_quiz_app`) y el backend NestJS (`backend/src`) para mapear pantallas y endpoints sin asumir componentes inexistentes.
- **Cálculo de Accesibilidad (WCAG 2.1)**: Apoyo en el cómputo matemático de luminancia relativa y relaciones de contraste de color para garantizar que todas las combinaciones semánticas superen la relación 4.5:1 exigida por el nivel AA.
- **Propuesta Arquitectónica del Sistema de Tokens**: Asistencia en la estructuración de la jerarquía de tokens primitivos (colores, espaciados, radios, tipografías) y tokens semánticos desacoplados en `lib/design_system/`.
- **Diseño del Catálogo de Componentes**: Generación e implementación de componentes reutilizables (`SafeAccessButton`, `SafeAccessStatusCard`, `SafeAccessAsyncState`, `SafeAccessSectionCard`) bajo la regla de desacoplamiento total respecto a rutas y endpoints.
- **Refactorización Adaptativa y Pruebas**: Asistencia en el refactor de `TrainingPage` para lograr diseño responsivo (390 px / 800 px) y redacción de pruebas unitarias automatizadas (`flutter test`).

---

## Verificación Humana y Responsabilidad

1. Todo el código generado e integrado fue auditado y verificado en la estructura real del proyecto.
2. Las pruebas unitarias fueron diseñadas para comprobar comportamientos empíricos reales.
3. Las decisiones finales de arquitectura, accesibilidad y autoría pertenecen al equipo de desarrollo.
