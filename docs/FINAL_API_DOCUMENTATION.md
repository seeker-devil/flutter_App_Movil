# Documentación Técnica de APIs REST: SafeAccess 90

**Proyecto:** SafeAccess 90  
**Asignatura:** Aplicaciones Móviles  
**Docente:** Ing. Julio Hurtado MSc.  

Esta documentación especifica el inventario completo de endpoints REST expuestos por el backend NestJS del proyecto SafeAccess 90.

---

## Interfaz Interactiva Swagger / OpenAPI UI

El servidor backend integra **Swagger / OpenAPI 3.0** para la exploración y prueba interactiva de los servicios web.

* **URL de Acceso a Swagger UI:** `http://localhost:3000/api/docs`
* **Especificación OpenAPI (JSON):** `http://localhost:3000/api/docs-json`
* **Autenticación en Swagger:** Hacer clic en el botón `Authorize` e ingresar el token JWT con el esquema `Bearer <token>`.

---

## Tabla General de Endpoints REST

| Método | Ruta | Descripción | Autenticación | Rol | Body / Parámetros | Respuesta Exitosa | Códigos HTTP Posibles |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `GET` | `/api/health` | Estado de salud y operatividad del servidor backend NestJS. | Pública | Ninguno | N/A | `{"success": true, "message": "SafeAccess 90 backend is running", "timestamp": "..."}` | 200 |
| `POST` | `/api/auth/login` | Autenticación de usuario con email y contraseña, entrega de JWT. | Pública | Ninguno | Body: `{"email": "...", "password": "..."}` | `{"success": true, "data": {"accessToken": "...", "tokenType": "Bearer", "user": {...}}}` | 200, 400, 401 |
| `GET` | `/api/auth/me` | Obtener datos del perfil del usuario autenticado actual. | JWT Bearer | `PARTICIPANT` / `ADMIN` | Header `Authorization: Bearer <token>` | `{"success": true, "data": {"id": 1, "role": "PARTICIPANT", "active": true}}` | 200, 401 |
| `GET` | `/api/auth/admin-check` | Verificación de privilegios y permisos de rol Administrador. | JWT Bearer | `ADMIN` | Header `Authorization: Bearer <token>` | `{"success": true, "message": "Acceso administrativo autorizado"}` | 200, 401, 403 |
| `GET` | `/api/attempts` | Consultar el historial de intentos de evaluación del usuario. | JWT Bearer | `PARTICIPANT` / `ADMIN` | Header `Authorization: Bearer <token>` | `{"success": true, "data": [{"id": 1, "score": 100, ...}]}` | 200, 401 |
| `POST` | `/api/attempts` | Registrar nuevo intento de evaluación con control idempotente por `clientId`. | JWT Bearer | `PARTICIPANT` / `ADMIN` | Body: `{"clientId": "...", "evaluationId": 1, "score": 100}` | `{"success": true, "message": "Intento registrado exitosamente", "data": {...}}` | 201, 200, 400, 401 |
| `POST` | `/api/evaluations` | Crear nueva evaluación en el sistema (Exclusivo Administradores). | JWT Bearer | `ADMIN` | Body: `{"title": "...", "passingScore": 80, "active": true}` | `{"success": true, "message": "Evaluación creada exitosamente", "data": {...}}` | 201, 400, 401, 403 |
| `GET` | `/api/evaluations` | Obtener la lista completa de evaluaciones disponibles. | JWT Bearer | `PARTICIPANT` / `ADMIN` | Header `Authorization: Bearer <token>` | `{"success": true, "data": [{"id": 1, "title": "...", ...}]}` | 200, 401 |
| `GET` | `/api/evaluations/:id` | Consultar los detalles de una evaluación específica por ID. | JWT Bearer | `PARTICIPANT` / `ADMIN` | Param: `id` (integer) | `{"success": true, "data": {"id": 1, "title": "...", ...}}` | 200, 401, 404 |
| `PATCH` | `/api/evaluations/:id` | Actualizar título, puntaje o estado de una evaluación por ID. | JWT Bearer | `ADMIN` | Param: `id` (integer)<br>Body: `{"title": "...", "passingScore": 85}` | `{"success": true, "message": "Evaluación actualizada exitosamente", "data": {...}}` | 200, 400, 401, 403, 404 |
| `DELETE` | `/api/evaluations/:id` | Desactivar evaluación mediante baja lógica (`active = false`). | JWT Bearer | `ADMIN` | Param: `id` (integer) | `{"success": true, "message": "Evaluación desactivada exitosamente (Baja lógica)", "data": {...}}` | 200, 401, 403, 404 |

---

## Detalles de Seguridad y Códigos HTTP

* **`200 OK`**: Petición exitosa y datos devueltos.
* **`201 Created`**: Recurso creado correctamente en base de datos.
* **`400 Bad Request`**: Datos de entrada inválidos rechazados por `ValidationPipe` o violaciones DTO.
* **`401 Unauthorized`**: Ausencia de token JWT, token expirado o credenciales inválidas.
* **`403 Forbidden`**: El usuario autenticado no posee el rol requerido (`ADMIN`) evaluado por `RolesGuard`.
* **`404 Not Found`**: El identificador solicitado no existe en la base de datos PostgreSQL (`NotFoundException`).
