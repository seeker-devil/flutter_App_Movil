# Clasificación de Datos — SafeAccess 90

Este documento clasifica todos los datos reales procesados y almacenados por la aplicación móvil **SafeAccess 90**, definiendo su nivel de sensibilidad, mecanismo de almacenamiento, finalidad, tiempo de retención y comportamiento ante el cierre de sesión (*logout*).

---

## Matriz de Clasificación de Datos

| Dato | Clasificación | Mecanismo de Almacenamiento | Finalidad | Retención | Se Elimina al Logout |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **`accessToken` (JWT)** | **A. CREDENCIALES / SENSIBLES** | KeyStore / Keychain (`flutter_secure_storage`) | Autenticar solicitudes HTTP hacia el backend NestJS. | Mientras la sesión del usuario permanezca activa. | **SÍ** |
| **`refreshToken`** (si aplicara) | **A. CREDENCIALES / SENSIBLES** | KeyStore / Keychain (`flutter_secure_storage`) | Renovación automática de tokens expirados. | Mientras la sesión esté activa. | **SÍ** |
| **Registros Locales de Intentos (`Attempt`)** | **B. DATOS ESTRUCTURADOS LOCALES** | Base de datos SQLite relacional (`drift`) | Visualización de evaluaciones e intentos sin conexión a Internet. | Durante la sesión activa o hasta actualización remota. | **SÍ** |
| **Cola de Operaciones Pendientes (`PendingOperations`)** | **B. DATOS ESTRUCTURADOS LOCALES** | Base de datos SQLite relacional (`drift`) | Garantizar el envío diferido de creaciones offline al recuperar conexión. | Hasta que la sincronización sea exitosa (`SYNCED`) o logout. | **SÍ** |
| **Timestamps de Sincronización (`lastSyncAt`)** | **B. DATOS ESTRUCTURADOS LOCALES** | Base de datos SQLite relacional (`drift`) | Calcular la antigüedad de los datos visibles en pantalla ("Última sinc..."). | Durante la sesión activa. | **SÍ** |
| **Identificador de Cliente (`clientId` UUID)** | **B. DATOS ESTRUCTURADOS LOCALES** | Base de datos SQLite relacional (`drift`) | Garantizar idempotencia en la sincronización offline evitando duplicados. | Hasta completar la sincronización. | **SÍ** |
| **Perfil del Usuario Autenticado (`userId`, `email`, `role`)** | **C. PREFERENCIAS / SESIÓN** | Memoria volátil / State Notifier (Riverpod) | Personalizar la interfaz y validar permisos UI. | En memoria mientras la app está en ejecución. | **SÍ** |
| **Respuestas Temporales de Quiz en Progreso** | **D. DATOS TRANSITORIOS** | Memoria volátil (`QuizController`) | Almacenar selecciones durante la resolución del cuestionario. | Hasta finalizar o abandonar el quiz. | **SÍ** |

---

## Principios de Minimización de Datos Aplicados

1. **No persistencia innecesaria de credenciales primarias**: Las contraseñas en texto plano **nunca** se almacenan en el dispositivo móvil ni en memoria persistente.
2. **Minimización de campos en SQLite**: La tabla local `attempts` únicamente conserva los campos indispensables para la interfaz (`clientId`, `serverId`, `evaluationId`, `score`, `status`, `startedAt`, `finishedAt`, `createdAtLocal`, `updatedAtLocal`, `serverUpdatedAt`, `syncStatus`). No se guardan esquemas de cuestionario ni metadatos irrelevantes.
3. **Desacoplamiento de Tokens de la Cola de Sincronización**: La tabla `pending_operations` **NO** guarda tokens JWT dentro del `payload` en formato JSON. El token de autenticación se inyecta directamente desde el almacenamiento seguro al momento exacto de ejecutar la petición HTTP de sincronización.
