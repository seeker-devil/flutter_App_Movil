# Inventario de Pantallas y Endpoints — SafeAccess 90

Este documento contiene la matriz real que relaciona las pantallas actuales y previstas de la aplicación móvil **SafeAccess 90** con los endpoints reales implementados en el backend NestJS (`backend/src`).

## Matriz de Pantallas y Endpoints Reales

| Pantalla / Módulo | Propósito | Endpoint | Método | Estado Backend | Estado UI |
| ----------------- | --------- | -------- | ------ | -------------- | --------- |
| **Capacitación / Inducción** (`/`) | Verificar el estado operativo e infraestructura del backend | `/api/health` | `GET` | Implementado (`HealthController.checkHealth`) | Refactorizada con Catálogo de Componentes |
| **Inicio de Sesión** (`/login`) *(Prevista)* | Autenticación de usuarios mediante credenciales | `/api/auth/login` | `POST` | Implementado (`AuthController.login`) | Backend disponible / Pantalla UI prevista |
| **Perfil / Sesión** (`/profile`) *(Prevista)* | Consultar información del usuario autenticado | `/api/auth/me` | `GET` | Implementado (`AuthController.getProfile`) | Backend disponible (JWT) / Pantalla UI prevista |
| **Administración** (`/admin`) *(Prevista)* | Validar permisos de rol administrativo | `/api/auth/admin-check` | `GET` | Implementado (`AuthController.checkAdmin`) | Backend disponible (JWT + Admin) / Pantalla UI prevista |
| **Evaluación / Quiz** (`/quiz`) | Presentar cuestionario interactivo de capacitación | N/A *(Lógica local por Riverpod)* | N/A | Lógica cliente local | Implementado (`QuizPage`) |
| **Certificado** (`/certificate`) | Emitir constancia digital de aprobación | N/A *(Lógica local por Riverpod)* | N/A | Lógica cliente local | Implementado (`CertificatePage`) |

## Notas Técnicas y Reglas de Integración

1. **Endpoints Confirmados**: Solo se han incluido los endpoints reales encontrados en los controladores de NestJS (`backend/src/health/health.controller.ts` y `backend/src/auth/auth.controller.ts`).
2. **Desacoplamiento**: Ningún componente del catálogo de diseño conoce estos endpoints. La llamada HTTP la realiza el servicio `HealthApiService` y la pantalla `TrainingPage` inyecta los callbacks hacia los componentes del catálogo.
