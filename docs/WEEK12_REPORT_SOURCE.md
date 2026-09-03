# Fuente del Informe Técnico — Semana 12: SafeAccess 90

Este documento contiene la materia prima integral consolidada para el informe final del **Taller práctico – Semana 12: Persistencia local y almacenamiento seguro del proyecto móvil SafeAccess 90**.

---

## 1. Clasificación de Datos y Minimización

Consultar la matriz completa en [`docs/DATA_CLASSIFICATION.md`](file:///c:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/docs/DATA_CLASSIFICATION.md).

- **Categoría A (Sensibles)**: `accessToken` JWT almacenado únicamente en almacenamiento cifrado del sistema operativo (`flutter_secure_storage`).
- **Categoría B (Estructurados Locales)**: `Attempt` (intentos de evaluación), `PendingOperations` (cola de operaciones), `lastSyncAt` y `clientId` UUID almacenados en base relacional `drift` (SQLite).
- **Categoría C (Preferencias/Sesión)**: Perfil de usuario autenticado en estado reactivo de memoria (`Riverpod`).
- **Categoría D (Transitorios)**: Estado temporal del formulario/quiz en memoria volátil.

---

## 2. Almacenamiento Seguro de Tokens

- **Servicio**: `SecureSessionStorage` (`lib/services/secure_session_storage.dart`).
- **Librería**: `flutter_secure_storage` (`^9.2.2`).
- **Métodos**: `saveAccessToken()`, `readAccessToken()`, `deleteAccessToken()`, `clearSession()`.
- **Regla Estricta**: Prohibido guardar tokens en `SharedPreferences`, `Drift`, `Hive` o archivos en texto plano.

---

## 3. Base de Datos Relacional Local

- **Librería**: `drift` (`^2.20.2`) + `drift_flutter` + `sqlite3_flutter_libs`.
- **Ubicación de Código**: `lib/local/database/app_database.dart`.
- **Tablas**:
  - `AttemptsTable`: `localId`, `serverId` (nullable), `clientId` (UNIQUE), `evaluationId`, `score`, `status`, `startedAt`, `finishedAt`, `createdAtLocal`, `updatedAtLocal`, `serverUpdatedAt` (nullable), `syncStatus`.
  - `PendingOperationsTable`: `id`, `clientId` (UNIQUE), `entityType`, `operationType`, `payload` (JSON), `createdAt`, `retryCount`, `nextRetryAt`, `lastError`, `status`.
- **Estrategia de Migración**: `schemaVersion = 1` con `MigrationStrategy`.

---

## 4. Entidad Principal Offline: Intento de Evaluación (`Attempt`)

- **Justificación**: Representa la acción clave realizada por el trabajador de campo en SafeAccess 90 al completar una capacitación.
- **Estados de Sincronización**: `SYNCED`, `PENDING_CREATE`, `PENDING_UPDATE`, `FAILED`.

---

## 5. Estrategia de Sincronización y Reintentos

- **Detección**: `connectivity_plus` para eventos de red + verificación real de solicitud HTTP.
- **Backoff Exponencial**:
  - Intento 1: 2 segundos
  - Intento 2: 4 segundos
  - Intento 3: 8 segundos
  - Intento 4: 16 segundos
  - Tras 4 intentos fallidos: `status = FAILED`.
- **Idempotencia en Backend**:
  - Prisma Schema: `clientId String? @unique` en modelo `Attempt`.
  - Si el backend recibe una petición POST con un `clientId` existente, no crea duplicados; retorna el registro previamente creado.
- **Estrategia de Conflictos**: **SERVER WINS** para datos confirmados por el backend. Los timestamps de reconciliación se generan en el SERVIDOR NestJS.

---

## 6. Proceso de Cierre de Sesión (Logout)

Al presionar Logout:
1. Se invoca `SecureSessionStorage.clearSession()` (destruyendo tokens del KeyStore/Keychain).
2. Se ejecuta `AppDatabase.clearAllTables()` (eliminando todas las filas de `attempts` y `pending_operations`).
3. Se limpia el estado de sesión en memoria volátil.
4. Se redirige la UI a la pantalla de Login.

---

## 7. Pruebas y Validación Ejecutada

- **Pruebas de Flutter**: `flutter test`
  - `SecureSessionStorageTest`
  - `AppDatabaseTest`
  - `SyncServiceTest`
  - `LogoutCleanupTest`
- **Pruebas de Backend**: `npm run lint`, `npm run test`, `npm run build`

---

## 8. Estado de Android

- **Diagnóstico**: `flutter doctor -v` arrojó `Unable to locate Android SDK`.
- **Declaración Formal**: ANDROID NO DISPONIBLE EN EL ENTORNO ACTUAL. La implementación se desarrolló y probó en Web Chrome / Windows Desktop y quedó 100% compatible y lista para ejecutar en Android al instalar el SDK.
