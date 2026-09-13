# Inventario Completo del Proyecto: SafeAccess 90

**Institución:** Universidad Estatal Amazónica  
**Asignatura:** Aplicaciones Móviles  
**Docente:** Ing. Julio Hurtado MSc.  
**Integrantes:** Daniel Hidalgo, Juliana Jumbo  
**Repositorio:** [flutter_App_Movil (branch: develop)](https://github.com/seeker-devil/flutter_App_Movil/tree/develop)  

---

## 1. Nombre y Propósito del Proyecto

* **Nombre del Proyecto:** SafeAccess 90
* **Propósito:** Aplicación móvil multiplataforma de inducción, capacitación, evaluación y certificación en Seguridad y Salud Ocupacional. El sistema permite a los trabajadores realizar el módulo de capacitación inductiva, presentar la evaluación de conocimientos (quiz), registrar sus intentos de evaluación de forma offline u online, administrar cuestionarios mediante un módulo CRUD completo y obtener un certificado digital de aprobación verificado por código único.

---

## 2. Usuarios y Roles

| Rol | Descripción | Permisos Principales |
| --- | --- | --- |
| `PARTICIPANT` | Usuario trabajador / participante de la inducción. | Acceso al material de capacitación, realización de evaluaciones (quiz), registro de intentos local/remoto, consulta de evaluaciones y visualización/descarga de certificados de aprobación. |
| `ADMIN` | Administrador del sistema de seguridad. | Verificación administrativa del sistema (`/api/auth/admin-check`), gestión CRUD completa de evaluaciones (`/api/evaluations`) desde la app móvil o API Swagger y supervisión de intentos de evaluación. |

---

## 3. Módulos del Sistema

1. **Autenticación y Gestión de Sesión Segura (`auth`)**: Login con JWT, restauración automática de sesión desde almacenamiento cifrado (`flutter_secure_storage`), control de guardias por roles (`RolesGuard`) y cierre de sesión seguro con limpieza total de base de datos.
2. **Capacitación Inductiva (`training`)**: Presentación del material educativo sobre normas de seguridad ocupacional, módulos temáticos e interfaz interactiva previa a la evaluación.
3. **Evaluación y Cuestionario (`quiz`)**: Cuestionario interactivo con preguntas de opción múltiple, cálculo de puntaje porcentual y conexión directa con la persistencia relacional local `AppDatabase` (Drift SQLite) y cola de sincronización, generando intentos reales con `clientId` UUID v4.
4. **Gestión Administrativa de Evaluaciones (`evaluations`)**: Módulo CRUD administrativo completo en Flutter (`EvaluationsPage`) y NestJS (`EvaluationsModule`) para creación, consulta, actualización y baja lógica de evaluaciones de seguridad.
5. **Certificación Digital (`certificate`)**: Emisión y visualización del certificado de aprobación con código alfanumérico único, fecha de emisión y estado de vigencia.
6. **Persistencia Local y Sincronización Offline (`local`)**: Almacenamiento SQLite mediante Drift ORM, cola de operaciones pendientes, algoritmo de Backoff Exponencial para reintentos de red e idempotencia mediante `clientId` UUID v4.

---

## 4. Pantallas en Flutter (`lib/features/`)

| Pantalla | Ruta | Archivo Source | Descripción |
| --- | --- | --- | --- |
| `LoginPage` | `/login` | [login_page.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/features/auth/login_page.dart) | Formulario de autenticación con campos de email y password, validación de estado asíncrono y mensajes de error. |
| `TrainingPage` | `/` | [training_page.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/features/training/training_page.dart) | Pantalla principal de bienvenida y capacitación inductiva. Presenta contenidos de seguridad, estado del participante, acceso al quiz y botón de administración de evaluaciones. |
| `QuizPage` | `/quiz` | [quiz_page.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/features/quiz/quiz_page.dart) | Interfaz de evaluación interactiva con preguntas de opción múltiple, temporizador, cálculo de resultado e inserción automática del intento en SQLite local + cola backend. |
| `CertificatePage` | `/certificate` | [certificate_page.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/features/certificate/certificate_page.dart) | Pantalla de visualización del certificado digital emitido tras aprobar la evaluación, mostrando código único, vigencia y opción de exportación. |
| `EvaluationsPage` | `/evaluations` | [evaluations_page.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/features/evaluations/evaluations_page.dart) | Pantalla de administración CRUD gráfica de evaluaciones en tiempo real contra la REST API NestJS (Listar, Crear, Editar, Desactivar). |

---

## 5. Servicios

### Cliente Móvil Flutter (`lib/services/` & `lib/local/sync/`)
* [AuthService](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/services/auth_service.dart): Peticiones de login a NestJS REST API, guardado/lectura de JWT y cierre de sesión.
* [EvaluationsApiService](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/services/evaluations_api_service.dart): Consumo de endpoints REST `/api/evaluations` (GET, POST, PATCH, DELETE por baja lógica `active = false`).
* [SecureSessionStorage](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/services/secure_session_storage.dart): Wrapper seguro utilizando `flutter_secure_storage` para guardar tokens y credenciales cifradas.
* [HealthApiService](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/services/health_api_service.dart): Consulta de estado operacional del backend (`/api/health`).
* [SyncService](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/local/sync/sync_service.dart): Procesamiento de la cola de operaciones SQLite, reintentos con algoritmo de Backoff Exponencial y sincronización de intentos locales.

### Backend NestJS (`backend/src/`)
* `AuthService` ([auth.service.ts](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/src/auth/auth.service.ts)): Validación de credenciales con Bcrypt y emisión de firmas JWT.
* `AttemptsService` ([attempts.service.ts](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/src/attempts/attempts.service.ts)): Creación idempotente de intentos con `clientId` y consulta de historial de evaluaciones por usuario.
* `EvaluationsService` ([evaluations.service.ts](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/src/evaluations/evaluations.service.ts)): Servicio CRUD para creación, listado, búsqueda, edición y baja lógica (`active = false`) de evaluaciones.
* `RedisService` ([redis.service.ts](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/src/redis/redis.service.ts)): Gestión de conexión `ioredis` para aceleración de datos en memoria y caché de sesiones.
* `PrismaService` ([prisma.service.ts](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/src/prisma/prisma.service.ts)): Capa de abstracción de datos para PostgreSQL.

---

## 6. Providers y Controladores (Riverpod)

* `appDatabaseProvider`: Singleton de la base local `AppDatabase` (Drift SQLite).
* `secureStorageProvider`: Proveedor de la capa de almacenamiento seguro `SecureSessionStorage`.
* `authServiceProvider`: Servicio de autenticación inyectado con dependencias locales.
* `evaluationsApiServiceProvider`: Servicio HTTP de administración de evaluaciones `EvaluationsApiService`.
* `syncServiceProvider`: Servicio de sincronización en segundo plano inyectado con `AppDatabase`.
* `authControllerProvider`: `StateNotifierProvider` manejando `AuthNotifier` con estado reactivo `AsyncValue<AuthUser?>`.
* `routerNotifierProvider` & `routerProvider`: Gestor de enrutamiento con `GoRouter`, con lógica de redirección basada en autenticación sin parpadeos de carga.
* `connectivityStreamProvider`: Stream reactivo de conectividad (`ConnectivityResult`).
* `attemptsStreamProvider`: Stream reactivo de lista de intentos desde SQLite Drift (`watchAllAttempts`).
* `QuizController`: Controlador de estado de la evaluación activa (`quiz_controller.dart`).

---

## 7. Componentes Reutilizables (Design System)

Ubicados en `lib/design_system/`:
* `SafeAccessButton` ([safe_access_button.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/components/safe_access_button.dart)): Botón estandarizado con variantes `primary`, `secondary` y `outline`, soporte para estados de carga, deshabilitado e íconos.
* `SafeAccessStatusCard` ([safe_access_status_card.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/components/safe_access_status_card.dart)): Tarjeta de retroalimentación con estilos semánticos (`success`, `warning`, `error`, `info`) y acciones secundarias.
* `SafeAccessAsyncState` ([safe_access_async_state.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/components/safe_access_async_state.dart)): Contenedor de interfaz para manejar estados `loading`, `error`, `empty` y `data`.
* `SafeAccessSectionCard` ([safe_access_section_card.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/components/safe_access_section_card.dart)): Contenedor de sección estructurado con encabezado, subtítulo e ícono.
* **Tokens de Diseño**: `AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`.

---

## 8. Persistencia Local (Drift SQLite)

Base de datos SQLite local `safeaccess_db` configurada mediante Drift ORM ([app_database.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/local/database/app_database.dart)):

1. **`AttemptsTable`**:
   * `localId` (Int, PK, Autoincrement)
   * `clientId` (Text, Unique, UUID v4)
   * `serverId` (Int, Nullable)
   * `evaluationId` (Int)
   * `score` (Int, default 100)
   * `status` (Text, default 'APPROVED')
   * `startedAt` (DateTime)
   * `finishedAt` (DateTime, Nullable)
   * `createdAtLocal` (DateTime)
   * `updatedAtLocal` (DateTime)
   * `serverUpdatedAt` (DateTime, Nullable)
   * `syncStatus` (Text: `'PENDING_CREATE'` / `'SYNCED'`)

2. **`PendingOperationsTable`**:
   * `id` (Int, PK, Autoincrement)
   * `clientId` (Text, Unique, UUID v4)
   * `entityType` (Text, ej. `'ATTEMPT'`)
   * `operationType` (Text, ej. `'CREATE'`)
   * `payload` (Text, JSON codificado)
   * `createdAt` (DateTime)
   * `retryCount` (Int, default 0)
   * `nextRetryAt` (DateTime, Nullable)
   * `lastError` (Text, Nullable)
   * `status` (Text: `'PENDING'` / `'FAILED'`)

---

## 9. Base de Datos Relacional (PostgreSQL - Prisma)

Estructurada en 3FN en [schema.prisma](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/prisma/schema.prisma):
* **`User`**: `id` (PK), `email` (Unique), `passwordHash`, `role` (`ADMIN` \| `PARTICIPANT`), `active`, `createdAt`.
* **`Evaluation`**: `id` (PK), `title`, `passingScore`, `active`, `createdAt`.
* **`Question`**: `id` (PK), `evaluationId` (FK), `text`, `order`, `active`.
* **`Option`**: `id` (PK), `questionId` (FK), `text`, `isCorrect`, `order`.
* **`Attempt`**: `id` (PK), `userId` (FK), `evaluationId` (FK), `clientId` (Unique, Nullable), `status` (`IN_PROGRESS` \| `APPROVED` \| `FAILED`), `score`, `startedAt`, `finishedAt`, `createdAt`, `updatedAt`.
* **`Certificate`**: `id` (PK), `attemptId` (FK Unique), `code` (Unique), `issuedAt`, `expiresAt`, `status` (`ACTIVE` \| `EXPIRED` \| `REVOKED`).

---

## 10. Endpoints Backend Reales (NestJS REST API & Swagger UI)

* **Documentación Interactiva Swagger:** `http://localhost:3000/api/docs`

| Método | Ruta | Descripción | Autenticación | Body / Params | Respuesta Exitosa |
| --- | --- | --- | --- | --- | --- |
| `GET` | `/api/health` | Estado del backend | Pública | Ninguno | `{"success": true, "message": "SafeAccess 90 backend is running", "timestamp": "..."}` |
| `POST` | `/api/auth/login` | Inicio de sesión | Pública | `{"email": "...", "password": "..."}` | `{"success": true, "data": {"accessToken": "...", "tokenType": "Bearer", "user": {...}}}` |
| `GET` | `/api/auth/me` | Obtener usuario actual | JWT (`JwtAuthGuard`) | Header `Authorization: Bearer <token>` | `{"success": true, "data": {"id": 1, "role": "PARTICIPANT", "active": true}}` |
| `GET` | `/api/auth/admin-check` | Verificación de admin | JWT + Role Admin (`RolesGuard`) | Header `Authorization: Bearer <token>` | `{"success": true, "message": "Acceso administrativo autorizado"}` |
| `GET` | `/api/attempts` | Historial de intentos | JWT (`JwtAuthGuard`) | Header `Authorization: Bearer <token>` | `{"success": true, "data": [{...}]}` |
| `POST` | `/api/attempts` | Registro de intento | JWT (`JwtAuthGuard`) | `{"clientId": "...", "evaluationId": 1, "score": 100}` | `{"success": true, "message": "...", "data": {...}}` |
| `POST` | `/api/evaluations` | Crear evaluación (CRUD) | JWT + Role Admin (`RolesGuard`) | `{"title": "...", "passingScore": 80}` | `{"success": true, "message": "Evaluación creada exitosamente", "data": {...}}` |
| `GET` | `/api/evaluations` | Listar evaluaciones (CRUD) | JWT (`JwtAuthGuard`) | Header `Authorization: Bearer <token>` | `{"success": true, "data": [{...}]}` |
| `GET` | `/api/evaluations/:id` | Ver evaluación (CRUD) | JWT (`JwtAuthGuard`) | Param: `:id` | `{"success": true, "data": {...}}` |
| `PATCH` | `/api/evaluations/:id` | Editar evaluación (CRUD) | JWT + Role Admin (`RolesGuard`) | Param: `:id`<br>Body: `{"passingScore": 85}` | `{"success": true, "message": "Evaluación actualizada exitosamente", "data": {...}}` |
| `DELETE` | `/api/evaluations/:id` | Baja lógica evaluación (CRUD) | JWT + Role Admin (`RolesGuard`) | Param: `:id` | `{"success": true, "message": "Evaluación desactivada exitosamente (Baja lógica)", "data": {...}}` |

---

## 11. Autenticación, Caché y Sincronización Offline

* **Autenticación**: Firmado y validación de tokens JWT en NestJS con expiración configurable; almacenamiento cifrado mediante `flutter_secure_storage` en Android (EncryptedSharedPreferences) e iOS (Keychain).
* **Caché**: Módulo `RedisModule` (`ioredis`) integrado en backend para revocación rápida de tokens y prevención de accesos concurrentes no autorizados.
* **Sincronización Offline**: Generación local de identificadores UUID v4 (`clientId`); encolamiento automático de intentos en `PendingOperationsTable`; reintentos en segundo plano mediante `SyncService` utilizando un algoritmo de Backoff Exponencial ($2^{\text{retryCount}}$ seg); resolución de duplicados mediante la restricción idempotente de `clientId` en PostgreSQL; actualización de estado a `SYNCED` con `serverId`; y borrado seguro de tablas e identificadores cifrados al ejecutar `logout()`.

---

## 12. Estado de Pruebas Automatizadas

1. **Cliente Flutter (`flutter test`)**:
   * **Resultado:** 29 de 29 pruebas pasadas exitosamente (100% efectividad).
   * **Áreas probadas:** Inicialización de app, navegación, componentes del catálogo visual, flujo de autenticación, prevención de condiciones de carrera en enrutador, operaciones CRUD en Drift SQLite y limpieza al cerrar sesión.
   * **Análisis estático (`flutter analyze`):** 0 errores, 0 advertencias.

2. **Backend NestJS (`npm run test`)**:
   * **Resultado:** **24 de 24 pruebas unitarias pasadas en 5 suites Jest (100% efectividad)**.
   * **Áreas probadas:** `AuthService`, `AttemptsService`, `EvaluationsService`, `JwtAuthGuard`, `RolesGuard`.
   * **Calidad de Código (`npm run lint`):** 0 errores ESLint.
   * **Compilación (`npm run build`):** Éxito total sin errores TypeScript.
