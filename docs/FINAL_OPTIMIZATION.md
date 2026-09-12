# Auditoría de Métodos de Optimización Técnica

**Proyecto:** SafeAccess 90  
**Asignatura:** Aplicaciones Móviles  
**Docente:** Ing. Julio Hurtado MSc.  

Este documento registra los métodos de optimización técnica que se encuentran verdaderamente implementados en la solución móvil y backend de SafeAccess 90, detallando la técnica, su ubicación en el código, el problema que resuelve y la evidencia empírica que lo respalda.

---

## Tabla de Optimizaciones Verificadas

| Técnica de Optimización | Ubicación en el Código | Problema que Resuelve | Evidencia Empírica / Código |
| --- | --- | --- | --- |
| **Caché en Memoria con Redis** | [redis.service.ts](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/src/redis/redis.service.ts), [app.module.ts](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/src/app.module.ts) | Evita la sobrecarga y latencia de consultas recurrentes a la base de datos PostgreSQL, acelerando la verificación de tokens/sesiones y datos de lectura frecuente. | Integración del paquete `ioredis` v5.3.2 en NestJS. Conexión lazy con `enableOfflineQueue: false` para prevención de bloqueos. |
| **Índices de Búsqueda y Restricciones Únicas** | [schema.prisma](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/prisma/schema.prisma) | Elimina la necesidad de realizar escaneos secuenciales (*Full Table Scans*) en PostgreSQL, reduciendo el tiempo de búsqueda a complejidad $O(1)$ en consultas clave (`email`, `clientId`, `code`, `attemptId`). | Anotaciones `@unique` en los modelos `User(email)`, `Attempt(clientId)`, `Certificate(attemptId)` y `Certificate(code)` en Prisma Schema. |
| **Idempotencia HTTP mediante Identificadores UUID** | [attempts.service.ts](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/backend/src/attempts/attempts.service.ts#L30-L43) | Evita la duplicación accidental de intentos de evaluación cuando la aplicación móvil reintenta peticiones `POST /api/attempts` por intermitencia en la red. | Verificación explícita de `clientId` en `createAttempt`. Retorna `200 OK` con datos existentes si el intento ya fue registrado. Prueba Jest pasando en `attempts.service.spec.ts`. |
| **Algoritmo de Backoff Exponencial en Reintentos** | [sync_service.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/local/sync/sync_service.dart#L24-L26) | Previene la saturación del servidor (Storming) y reduce el consumo excesivo de batería en el dispositivo móvil durante fallos continuos de conexión a internet. | Método `calculateBackoffSeconds(retryCount) = pow(2, retryCount)` ($2^1=2s, 2^2=4s, 2^3=8s, 2^4=16s$). Verificado en prueba unitaria de `week12_storage_sync_test.dart`. |
| **Consultas Reactivas SQLite/Drift mediante Streams** | [app_database.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/local/database/app_database.dart#L38-L44), [app_providers.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/providers/app_providers.dart#L113-L115) | Permite la actualización automática en tiempo real de la UI móvil al modificar registros locales sin realizar peticiones síncronas ni bloquear el hilo principal (*Main UI Thread*). | Método `watchAllAttempts()` expuesto mediante `attemptsStreamProvider` con Riverpod `StreamProvider`. |
| **Prevención de Condición de Carrera en Rutas de Autenticación** | [app_router.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/app/app_router.dart#L30-L33) | Evita destellos o parpadeos en la interfaz y redirecciones prematuras a `/login` mientras la aplicación lee el token de `flutter_secure_storage` en la fase de arranque. | Verificación de `authState.isLoading` en `RouterNotifier.redirect()`. Si está cargando, retorna `null` preservando la pantalla de carga. Prueba de enrutador en `week12_storage_sync_test.dart`. |
| **Limpieza de Datos de Privacidad en Logout** | [app_database.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/local/database/app_database.dart#L124-L129), [auth_service.dart](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/services/auth_service.dart#L56-L65) | Protege la privacidad del usuario eliminando rastros de datos en el dispositivo móvil compartido al cerrar la sesión. | Ejecución de `transaction()` que vacía `AttemptsTable` y `PendingOperationsTable`, sumado a `secureStorage.deleteAll()`. Verificado en prueba de logout de `week12_storage_sync_test.dart`. |

---

## Aclaración sobre Técnicas No Atribuidas

Con el fin de mantener el rigor académico exigido por la guía de la Universidad Estatal Amazónica, **NO se atribuyen** al proyecto las siguientes técnicas por no estar implementadas en el código actual:
* **Paginación en Endpoints API**: Los endpoints actuales devuelven listas de intentos filtradas por usuario sin cursores ni límites OFFSET/LIMIT.
* **Carga Perezosa (Lazy Loading) de Imágenes**: No se utilizan componentes de renderizado diferido de imágenes.
* **Optimizaciones N+1 en GraphQL/ORMs**: La consulta de datos se realiza mediante `findMany` con relaciones simples de Prisma sin selectores profundos de agregación complexiva.
