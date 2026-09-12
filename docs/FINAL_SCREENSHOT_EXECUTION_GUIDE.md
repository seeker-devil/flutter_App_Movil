# Guía Operativa de Ejecución de Capturas: SafeAccess 90

**Proyecto:** SafeAccess 90  
**Asignatura:** Aplicaciones Móviles  
**Docente:** Ing. Julio Hurtado MSc.  

Esta guía proporciona las instrucciones exactas paso a paso para ejecutar el entorno, realizar las acciones necesarias y capturar las 22 evidencias definitivas especificadas en [FINAL_SCREENSHOT_PLAN.md](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/docs/FINAL_SCREENSHOT_PLAN.md).

---

## Parámetros del Entorno Base

* **Directorio Raíz Flutter:** `C:\Users\alejo\Desktop\work sin BACKUP\github\sem5\appmov\flutter\training_quiz_app`
* **Directorio Backend NestJS:** `C:\Users\alejo\Desktop\work sin BACKUP\github\sem5\appmov\flutter\training_quiz_app\backend`
* **Servidor REST API:** `http://localhost:3000/api`
* **Documentación Swagger UI:** `http://localhost:3000/api/docs`
* **Prisma Studio GUI:** `http://localhost:5555`
* **Cliente Flutter Web / DevTools:** `http://localhost:8080` (o ejecutable en emulador)
* **Repositorio GitHub:** `https://github.com/seeker-devil/flutter_App_Movil/tree/develop`

---

## Normas Importantes de Seguridad de Datos

1. **Credenciales de Prueba:** Utilizar exclusivamente la cuenta predeterminada `admin@safeaccess90.com` con contraseña `Admin123*`.
2. **Protección de Datos Sensibles:** No capturar ni exponer claves secretas (`JWT_SECRET`), variables de entorno `.env`, hashes de contraseñas (`passwordHash`) ni cadenas completas de tokens JWT.
3. **Mantenimiento de Datos:** Para las operaciones CRUD de evidencia, utilizar el título `"Evaluación Final SafeAccess 90"`. Al finalizar las capturas, dicha evaluación quedará en estado `active = false` (baja lógica) sin afectar las evaluaciones preexistentes.

---

## Secuencia Paso a Paso de las 22 Capturas

### FASE A: INFRAESTRUCTURA Y BACKEND

---

#### Figura 01: Infraestructura de Contenedores Docker
1. **Aplicación a abrir:** Terminal de PowerShell o CMD.
2. **Directorio:** `backend\`
3. **Comando a ejecutar:** `docker compose ps`
4. **URL a abrir:** N/A
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:** Presionar Enter en la terminal tras ejecutar el comando.
7. **Estado inicial necesario:** Docker Desktop ejecutándose en segundo plano.
8. **Qué debe verse antes de capturar:** Salida de la consola con estado `Up` o `Healthy` de los contenedores PostgreSQL (puerto 5432) y Redis (puerto 6379). *(Opcional: incluir el resultado de `docker exec -it safeaccess-redis redis-cli KEYS "auth:user:*"` para evidenciar la optimización Redis sin exponer JWTs).*
9. **Nombre del archivo PNG:** `fig01_docker_infrastructure.png`
10. **Paso posterior:** Dejar la terminal abierta para la siguiente figura.

---

#### Figura 02: Arranque y Despliegue del Backend NestJS
1. **Aplicación a abrir:** Terminal de PowerShell (Terminal 1).
2. **Directorio:** `backend\`
3. **Comando a ejecutar:** `npm run start:dev`
4. **URL a abrir:** N/A
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:** Ejecutar el comando y esperar a que NestJS complete la transpilación TypeScript.
7. **Estado inicial necesario:** Contenedores Docker de PostgreSQL y Redis activos (Figura 01).
8. **Qué debe verse antes de capturar:** Mensaje de la consola NestJS indicando `Nest application successfully started` y `Swagger Documentation available at http://localhost:3000/api/docs`.
9. **Nombre del archivo PNG:** `fig02_nestjs_server_started.png`
10. **Paso posterior:** Mantener el backend corriendo en esta terminal.

---

#### Figura 03: Documentación Interactiva OpenAPI / Swagger UI
1. **Aplicación a abrir:** Navegador Web (Chrome / Edge).
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:3000/api/docs`
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:** Recargar la página para visualizar la estructura del API.
7. **Estado inicial necesario:** Servidor NestJS activo (Figura 02).
8. **Qué debe verse antes de capturar:** Título "SafeAccess 90 - REST API", versión 1.0.0, botón `Authorize` y los 4 controladores listados: `Auth`, `Health`, `Attempts`, `Evaluations`.
9. **Nombre del archivo PNG:** `fig03_swagger_ui_overview.png`
10. **Paso posterior:** Permanecer en la página de Swagger UI.

---

#### Figura 04: CRUD Evaluation — Listado (GET) y Creación (POST)
1. **Aplicación a abrir:** Navegador Web (Swagger UI).
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:3000/api/docs`
5. **Credenciales / Rol:** Usuario `ADMIN` (`admin@safeaccess90.com` / `Admin123*`).
6. **Acción a ejecutar:**
   * Desplegar `POST /api/auth/login`, ejecutar con credenciales admin y copiar el `accessToken` devuelto.
   * Hacer clic en el botón `Authorize` de Swagger y pegar el token en el campo `Bearer`.
   * Desplegar `POST /api/evaluations`, hacer clic en "Try it out" y enviar el Body:
     ```json
     {
       "title": "Evaluación Final SafeAccess 90",
       "passingScore": 80,
       "active": true
     }
     ```
   * Desplegar `GET /api/evaluations` y hacer clic en "Execute".
7. **Estado inicial necesario:** Token de administrador autorizado en Swagger UI.
8. **Qué debe verse antes de capturar:** Respuesta `201 Created` del POST con el objeto creado y respuesta `200 OK` del GET mostrando la evaluación en el listado.
9. **Nombre del archivo PNG:** `fig04_crud_evaluation_create_list.png`
10. **Paso posterior:** Conservar el ID asignado a la nueva evaluación para la Figura 05.

---

#### Figura 05: CRUD Evaluation — Edición (PATCH) y Baja Lógica (DELETE)
1. **Aplicación a abrir:** Navegador Web (Swagger UI).
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:3000/api/docs`
5. **Credenciales / Rol:** Usuario `ADMIN` (Token Bearer autorizado).
6. **Acción a ejecutar:**
   * Desplegar `PATCH /api/evaluations/{id}` con el ID de la evaluación de prueba, enviando:
     ```json
     {
       "passingScore": 85
     }
     ```
   * Desplegar `DELETE /api/evaluations/{id}` con el mismo ID y hacer clic en "Execute".
7. **Estado inicial necesario:** Evaluación creada en la Figura 04.
8. **Qué debe verse antes de capturar:** Respuesta `200 OK` de `PATCH` reflejando el cambio de puntaje y respuesta `200 OK` de `DELETE` con el mensaje "Evaluación desactivada exitosamente (Baja lógica)" y el objeto con `active: false`.
9. **Nombre del archivo PNG:** `fig05_crud_evaluation_update_softdelete.png`
10. **Paso posterior:** Cerrar las pestañas de prueba de Swagger.

---

#### Figura 06: Modelado de Entidades en Prisma Schema
1. **Aplicación a abrir:** Editor de Código (VS Code).
2. **Directorio:** Raíz del proyecto.
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** N/A
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:** Abrir el archivo `backend/prisma/schema.prisma` y ubicar el cursor en los modelos centrales.
7. **Estado inicial necesario:** VS Code abierto con la carpeta del proyecto.
8. **Qué debe verse antes de capturar:** Código legible con las definiciones de los modelos `User`, `Evaluation`, `Question`, `Option`, `Attempt`, `Certificate` y sus restricciones `@unique`.
9. **Nombre del archivo PNG:** `fig06_prisma_schema_entities.png`
10. **Paso posterior:** Mantener VS Code abierto.

---

#### Figura 07: Inspección de Base de Datos PostgreSQL (Prisma Studio)
1. **Aplicación a abrir:** Terminal 2 de PowerShell + Navegador Web.
2. **Directorio:** `backend\`
3. **Comando a ejecutar:** `npx prisma studio`
4. **URL a abrir:** `http://localhost:5555`
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:** Abrir la pestaña de la tabla `User` o `Evaluation` en Prisma Studio. Ocultar o desorganizar la vista de la columna `passwordHash` para proteger datos sensibles.
7. **Estado inicial necesario:** Servidor PostgreSQL activo.
8. **Qué debe verse antes de capturar:** Interfaz web de Prisma Studio mostrando filas con datos reales de las tablas `User`, `Evaluation` e `Attempt`.
9. **Nombre del archivo PNG:** `fig07_prisma_studio_database.png`
10. **Paso posterior:** Cerrar Prisma Studio finalizando el proceso en la Terminal 2 (`Ctrl + C`).

---

### FASE B: APLICACIÓN MÓVIL FLUTTER

---

#### Figura 08: Autenticación de Usuario e Inicio de Sesión
1. **Aplicación a abrir:** Terminal 3 de PowerShell (Servidor Web Flutter) + Navegador Web (o Emulador).
2. **Directorio:** Raíz del proyecto Flutter (`training_quiz_app\`).
3. **Comando a ejecutar:** `flutter run -d chrome --web-port=8080` (o ejecutar en emulador Android).
4. **URL a abrir:** `http://localhost:8080/#/login` (o ventana del emulador).
5. **Credenciales / Rol:** `admin@safeaccess90.com` / `Admin123*` (ingresadas en los campos).
6. **Acción a ejecutar:** Escribir el correo y contraseña en el formulario sin presionar el botón de ingresar.
7. **Estado inicial necesario:** Cliente Flutter iniciado e interfaz en la ruta `/login`.
8. **Qué debe verse antes de capturar:** Pantalla de Login limpia con el formulario completado, contraseñas enmascaradas con puntos (`••••••••`), botón `SafeAccessButton` habilitado y diseño visual del proyecto.
9. **Nombre del archivo PNG:** `fig08_flutter_login_page.png`
10. **Paso posterior:** Presionar "Iniciar Sesión" para ingresar a la app.

---

#### Figura 09: Pantalla Principal de Capacitación Inductiva
1. **Aplicación a abrir:** Navegador Web / Emulador con Flutter activo.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/` (Ruta raíz `TrainingPage`).
5. **Credenciales / Rol:** Usuario autenticado.
6. **Acción a ejecutar:** Iniciar sesión exitosamente para que GoRouter redirija a la pantalla principal.
7. **Estado inicial necesario:** Usuario autenticado en el sistema.
8. **Qué debe verse antes de capturar:** Encabezado con bienvenida al usuario, estado de la sesión, módulos inductivos de seguridad ocupacional y el botón para iniciar la evaluación.
9. **Nombre del archivo PNG:** `fig09_flutter_training_page.png`
10. **Paso posterior:** Hacer clic en "Iniciar Evaluación" para navegar al quiz.

---

#### Figura 10: Cuestionario Interactivo de Evaluación (Quiz)
1. **Aplicación a abrir:** Navegador Web / Emulador con Flutter activo.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/quiz`
5. **Credenciales / Rol:** Usuario autenticado.
6. **Acción a ejecutar:** Responder al menos una pregunta seleccionando una opción de respuesta.
7. **Estado inicial necesario:** Evaluación iniciada.
8. **Qué debe verse antes de capturar:** Pregunta de seguridad activa, tarjetas de opciones de respuesta con una opción seleccionada, temporizador y barra de progreso.
9. **Nombre del archivo PNG:** `fig10_flutter_quiz_page.png`
10. **Paso posterior:** Finalizar el quiz respondiendo todas las preguntas para obtener una nota $\ge 70\%$.

---

#### Figura 11: Certificado Digital de Aprobación
1. **Aplicación a abrir:** Navegador Web / Emulador con Flutter activo.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/certificate`
5. **Credenciales / Rol:** Usuario con evaluación aprobada.
6. **Acción a ejecutar:** Completar el quiz aprobando la evaluación o navegar a la pantalla de certificado tras haber aprobado.
7. **Estado inicial necesario:** Intento registrado con score $\ge 70\%$.
8. **Qué debe verse antes de capturar:** Tarjeta del certificado digital mostrando el nombre del usuario, el código alfanumérico único, fecha de emisión, estado activo y botón de exportación.
9. **Nombre del archivo PNG:** `fig11_flutter_certificate_page.png`
10. **Paso posterior:** Volver a la pantalla principal (`/`).

---

#### Figura 12: Sistema de Diseño Atómico y Componentes Reutilizables
1. **Aplicación a abrir:** Navegador Web / Emulador.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/` (o vista de componentes en test).
5. **Credenciales / Rol:** Usuario autenticado.
6. **Acción a ejecutar:** Desplegar una sección de la interfaz donde se aprecie la combinación de componentes del sistema de diseño.
7. **Estado inicial necesario:** Aplicación cargada visualmente.
8. **Qué debe verse antes de capturar:** Integración estilizada de `SafeAccessButton` (primario y secundario), `SafeAccessSectionCard`, `SafeAccessStatusCard` y la aplicación de los tokens de color (`AppColors`) y tipografía (`AppTypography`).
9. **Nombre del archivo PNG:** `fig12_design_system_components.png`
10. **Paso posterior:** Abrir las herramientas de desarrollo de Chrome (DevTools — `F12`).

---

#### Figura 13: Adaptabilidad del Diseño (Responsive Layout)
1. **Aplicación a abrir:** Navegador Chrome (DevTools en modo dispositivo).
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/`
5. **Credenciales / Rol:** Usuario autenticado.
6. **Acción a ejecutar:**
   * Abrir Chrome DevTools (`F12`), activar la barra de dispositivos (`Ctrl + Shift + M`).
   * Configurar el ancho del viewport en **390 px** (Mobile View) y tomar la mitad de la imagen.
   * Cambiar el ancho a **800 px** (Tablet View) y tomar la otra mitad (o componer ambas resoluciones en una sola imagen).
7. **Estado inicial necesario:** Modo responsivo activo en Chrome DevTools.
8. **Qué debe verse antes de capturar:** La misma pantalla adaptando sus contenedores, tarjetas y tipografías fluidamente a 390 px y a 800 px.
9. **Nombre del archivo PNG:** `fig13_responsive_design_comparison.png`
10. **Paso posterior:** Desactivar la barra de dispositivos en DevTools.

---

#### Figura 14: Manejo Robusto de Estados Asíncronos (Loading / Error)
1. **Aplicación a abrir:** Navegador Web / Emulador.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/login`
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:**
   * **Para Carga:** Hacer clic en "Iniciar Sesión" y capturar instantáneamente el spinner del componente `SafeAccessAsyncState` / `SafeAccessButton`.
   * **Para Error:** Ingresar un usuario inexistente `error_user@test.com` con clave incorrecta y presionar ingresar para gatillar la tarjeta de error formateada.
7. **Estado inicial necesario:** Formulario de login activo.
8. **Qué debe verse antes de capturar:** Indicador de carga activo en pantalla y tarjeta de error de `SafeAccessStatusCard` con mensaje de error y acción de reintento.
9. **Nombre del archivo PNG:** `fig14_async_states_loading_error.png`
10. **Paso posterior:** Volver a autenticarse con las credenciales válidas.

---

### FASE C: PERSISTENCIA LOCAL OFFLINE Y SINCRONIZACIÓN

---

#### Figura 15: Operatividad en Modo Offline y Estado Local
1. **Aplicación a abrir:** Navegador Chrome (DevTools - Pestaña Network) o Emulador con Modo Avión.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/`
5. **Credenciales / Rol:** Usuario autenticado.
6. **Acción a ejecutar:** Abrir la pestaña Network en Chrome DevTools y seleccionar el perfil de red **"Offline"** (o activar Modo Avión en el emulador Android).
7. **Estado inicial necesario:** Red deshabilitada intencionalmente.
8. **Qué debe verse antes de capturar:** Interfaz móvil desplegando la etiqueta "Funcionamiento sin conexión mediante modo Offline de Chrome DevTools" (o Modo Avión), indicando la antigüedad de los datos en caché local.
9. **Nombre del archivo PNG:** `fig15_offline_mode_indicator.png`
10. **Paso posterior:** Permanecer en modo sin conexión para la Figura 16.

---

#### Figura 16: Registro Local de Intento en Estado PENDING_CREATE
1. **Aplicación a abrir:** Cliente Flutter en modo sin conexión.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/quiz`
5. **Credenciales / Rol:** Usuario en modo offline.
6. **Acción a ejecutar:** Completar el quiz en modo offline y presionar "Finalizar Evaluación".
7. **Estado inicial necesario:** Conexión deshabilitada ("Offline").
8. **Qué debe verse antes de capturar:** Pantalla de resultado del intento mostrando el identificador único `clientId` (UUID v4), el estado de sincronización local `PENDING_CREATE` y la indicación de que el registro fue almacenado localmente mediante Drift/SQLite.
9. **Nombre del archivo PNG:** `fig16_drift_pending_create_record.png`
10. **Paso posterior:** Mantener la pantalla abierta para proceder a reconectar.

---

#### Figura 17: Sincronización en Background y Estado SYNCED
1. **Aplicación a abrir:** Cliente Flutter + DevTools Network tab.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/`
5. **Credenciales / Rol:** Usuario autenticado con intento pendiente.
6. **Acción a ejecutar:** Cambiar el estado de red en Chrome DevTools de "Offline" a **"No throttling"** (Online). El servicio `SyncService` procesa la cola automáticamente.
7. **Estado inicial necesario:** Reestablecimiento de la conectividad a internet.
8. **Qué debe verse antes de capturar:** Notificación o pantalla de historial actualizada mostrando la transición de la evaluación a estado `SYNCED`, asignación de `serverId` devuelto por el servidor NestJS y mensaje de sincronización exitosa.
9. **Nombre del archivo PNG:** `fig17_drift_synced_resolution.png`
10. **Paso posterior:** Ir a la barra superior o menú y seleccionar la opción "Cerrar Sesión".

---

#### Figura 18: Cierre de Sesión y Limpieza de Privacidad
1. **Aplicación a abrir:** Cliente Flutter.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `http://localhost:8080/#/login`
5. **Credenciales / Rol:** Usuario que acaba de cerrar sesión.
6. **Acción a ejecutar:** Presionar "Cerrar Sesión" (`logout`), volver a iniciar sesión y navegar a la sección de historial de intentos locales.
7. **Estado inicial necesario:** Ejecución completa de la acción `logout()`.
8. **Qué debe verse antes de capturar:** Interfaz reflejando el borrado de credenciales de Secure Storage y el vaciado completo de la base de datos local SQLite con el mensaje: "No hay intentos en la base de datos local".
9. **Nombre del archivo PNG:** `fig18_logout_privacy_cleanup.png`
10. **Paso posterior:** Cerrar el navegador web o emulador.

---

### FASE D: VERIFICACIÓN AUTOMATIZADA Y ARCHIVOS

---

#### Figura 19: Verificación Automatizada de Código Flutter (Analyze y Test)
1. **Aplicación a abrir:** Terminal de PowerShell / CMD.
2. **Directorio:** Raíz del proyecto Flutter (`training_quiz_app\`).
3. **Comando a ejecutar:** `flutter analyze; flutter test`
4. **URL a abrir:** N/A
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:** Ejecutar ambos comandos secuencialmente en la terminal.
7. **Estado inicial necesario:** Entorno de Flutter SDK configurado en PATH.
8. **Qué debe verse antes de capturar:** Salida de la consola con `No issues found!` del análisis sintáctico y `All tests passed! (29/29)` de la suite de pruebas. *(Nota: Si no caben en una sola toma legible, capturar ambas salidas consecutivas en la consola terminal).*
9. **Nombre del archivo PNG:** `fig19_flutter_analyze_and_test.png`
10. **Paso posterior:** Ubicar la terminal en la carpeta `backend\`.

---

#### Figura 20: Verificación Automatizada de Backend NestJS (Lint y Test)
1. **Aplicación a abrir:** Terminal de PowerShell / CMD.
2. **Directorio:** `backend\`
3. **Comando a ejecutar:** `npm run lint; npm run test`
4. **URL a abrir:** N/A
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:** Ejecutar el linter de ESLint y las pruebas Jest.
7. **Estado inicial necesario:** Dependencias de Node.js instaladas.
8. **Qué debe verse antes de capturar:** Salida limpia del linter sin errores y resumen de Jest indicando `Test Suites: 5 passed, 5 total` y `Tests: 24 passed, 24 total`.
9. **Nombre del archivo PNG:** `fig20_backend_lint_and_test.png`
10. **Paso posterior:** Permanecer en la terminal del backend.

---

#### Figura 21: Compilación de Producción Backend NestJS (Build)
1. **Aplicación a abrir:** Terminal de PowerShell / CMD.
2. **Directorio:** `backend\`
3. **Comando a ejecutar:** `npm run build`
4. **URL a abrir:** N/A
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:** Ejecutar la compilación de NestJS con Nest CLI.
7. **Estado inicial necesario:** Backend sin errores de sintaxis TypeScript.
8. **Qué debe verse antes de capturar:** Comando `nest build` finalizado correctamente con exit code 0 y la creación del bundle de producción `dist/`.
9. **Nombre del archivo PNG:** `fig21_backend_build_success.png`
10. **Paso posterior:** Abrir el navegador web y VS Code.

---

#### Figura 22: Repositorio GitHub y Estructura Documental en docs/
1. **Aplicación a abrir:** Navegador Web + VS Code.
2. **Directorio:** N/A
3. **Comando a ejecutar:** N/A
4. **URL a abrir:** `https://github.com/seeker-devil/flutter_App_Movil/tree/develop`
5. **Credenciales / Rol:** N/A
6. **Acción a ejecutar:** Abrir la pestaña del navegador con el repositorio en la rama `develop` y mostrar en VS Code la lista de archivos de la carpeta `docs/`.
7. **Estado inicial necesario:** Repositorio en GitHub sincronizado y carpeta `docs/` abierta.
8. **Qué debe verse antes de capturar:** Vista del repositorio GitHub en la rama `develop` y el panel lateral de VS Code mostrando los 7 documentos maestros de la práctica final: `FINAL_PROJECT_INVENTORY.md`, `FINAL_GUIDE_COMPLIANCE.md`, `FINAL_API_DOCUMENTATION.md`, `FINAL_REQUIREMENTS.md`, `FINAL_OPTIMIZATION.md`, `PROJECT_EVOLUTION.md` y `FINAL_REPORT_SOURCE.md`.
9. **Nombre del archivo PNG:** `fig22_github_repository_docs.png`
10. **Paso posterior:** Guardar todas las imágenes en la carpeta de evidencias destinada para la compilación del informe final.
