# Plan Definitivo de Capturas de Pantalla y Evidencias Académicas

**Proyecto:** SafeAccess 90  
**Asignatura:** Aplicaciones Móviles  
**Docente:** Ing. Julio Hurtado MSc.  

Este plan especifica el conjunto definitivo de **22 capturas de pantalla de evidencia** para el informe técnico final. La secuencia está ordenada lógicamente desde la infraestructura y el backend, pasando por la API Swagger y el CRUD, la aplicación móvil Flutter, la persistencia local Offline-First, hasta la verificación automatizada de código.

---

## Matriz Detallada de Capturas de Pantalla

### 1. Infraestructura y Servidor Backend

#### Figura 01: Infraestructura de Contenedores Docker
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig01_docker_infrastructure.png`
* **Aplicación a abrir:** Terminal de PowerShell / CMD
* **Pantalla / Ruta:** Directorio raíz del backend (`backend/`)
* **Qué hacer:** Ejecutar el comando `docker compose ps`
* **Qué debe verse:** Estado `Up` / `Healthy` de los contenedores de PostgreSQL (`postgres:15-alpine`, puerto 5432) y Redis (`redis:7-alpine`, puerto 6379).
* **Requisito que demuestra:** Infraestructura de contenedores y servicios del entorno de producción/desarrollo.
* **Pie de figura sugerido:** *Figura 01. Estado operativo de los servicios de base de datos PostgreSQL y caché Redis mediante Docker Compose.*

#### Figura 02: Arranke y Despliegue del Backend NestJS
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig02_nestjs_server_started.png`
* **Aplicación a abrir:** Terminal de PowerShell / CMD
* **Pantalla / Ruta:** Directorio `backend/`
* **Qué hacer:** Ejecutar `npm run start:dev` o `npm run start`
* **Qué debe verse:** Consola indicando `Nest application successfully started`, puerto 3000 activo y rutas `/api` inicializadas.
* **Requisito que demuestra:** Inicialización y operatividad del servidor API REST NestJS.
* **Pie de figura sugerido:** *Figura 02. Consola de inicialización exitosa del servidor NestJS REST API en el puerto 3000.*

---

### 2. Documentación API y Operaciones CRUD

#### Figura 03: Documentación Interactiva OpenAPI / Swagger UI
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig03_swagger_ui_overview.png`
* **Aplicación a abrir:** Navegador Web (Chrome / Edge)
* **Pantalla / Ruta:** `http://localhost:3000/api/docs`
* **Qué hacer:** Cargar la interfaz de Swagger UI y desplegar los módulos principales.
* **Qué debe verse:** Encabezado con título "SafeAccess 90 - REST API", botón `Authorize` y los 4 tags de controladores: `Auth`, `Health`, `Attempts`, `Evaluations`.
* **Requisito que demuestra:** Documentación formal e interactiva de la API conforme al estándar OpenAPI 3.0.
* **Pie de figura sugerido:** *Figura 03. Interfaz interactiva Swagger UI expuesta en /api/docs para la exploración de endpoints.*

#### Figura 04: CRUD Evaluation — Listado (GET) y Creación (POST)
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig04_crud_evaluation_create_list.png`
* **Aplicación a abrir:** Swagger UI (`http://localhost:3000/api/docs`) o Postman
* **Pantalla / Ruta:** Endpoints `POST /api/evaluations` y `GET /api/evaluations`
* **Qué hacer:** Ejecutar `POST /api/evaluations` enviando un body JSON (`title`, `passingScore`) con token ADMIN en la cabecera, y luego un `GET /api/evaluations`.
* **Qué debe verse:** Respuesta HTTP `201 Created` con el objeto de evaluación creado y respuesta `200 OK` con la lista de evaluaciones en PostgreSQL.
* **Requisito que demuestra:** Operaciones Create y Read del ciclo de vida CRUD administrativo.
* **Pie de figura sugerido:** *Figura 04. Creación y listado de evaluaciones mediante peticiones HTTP POST y GET en Swagger.*

#### Figura 05: CRUD Evaluation — Edición (PATCH) y Baja Lógica (DELETE)
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig05_crud_evaluation_update_softdelete.png`
* **Aplicación a abrir:** Swagger UI (`http://localhost:3000/api/docs`) o Postman
* **Pantalla / Ruta:** Endpoints `PATCH /api/evaluations/:id` y `DELETE /api/evaluations/:id`
* **Qué hacer:** Ejecutar una actualización `PATCH` cambiando `passingScore`, y posteriormente invocar `DELETE /api/evaluations/:id`.
* **Qué debe verse:** Respuesta `200 OK` en `PATCH` reflejando el cambio y respuesta `200 OK` en `DELETE` evidenciando el atributo `active: false` (baja lógica).
* **Requisito que demuestra:** Operaciones Update y Delete (Baja lógica) preservando la integridad referencial.
* **Pie de figura sugerido:** *Figura 05. Actualización y desactivación mediante baja lógica (active = false) de la entidad Evaluation.*

---

### 3. Modelo y Persistencia de Datos Central

#### Figura 06: Modelado de Entidades en Prisma Schema
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig06_prisma_schema_entities.png`
* **Aplicación a abrir:** VS Code
* **Pantalla / Ruta:** Archivo `backend/prisma/schema.prisma`
* **Qué hacer:** Abrir el archivo `schema.prisma` enfocado en los modelos centrales.
* **Qué debe verse:** Código del esquema con las entidades `User`, `Evaluation`, `Question`, `Option`, `Attempt`, `Certificate` y sus relaciones/índices `@unique`.
* **Requisito que demuestra:** Modelado de base de datos relacional normalizada en 3FN mediante Prisma ORM.
* **Pie de figura sugerido:** *Figura 06. Esquema relacional en 3FN definido en Prisma ORM con restricciones de integridad.*

#### Figura 07: Inspección de Base de Datos PostgreSQL (Prisma Studio)
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig07_prisma_studio_database.png`
* **Aplicación a abrir:** Navegador Web / Prisma Studio
* **Pantalla / Ruta:** Prisma Studio (`npx prisma studio`) en `http://localhost:5555`
* **Qué hacer:** Abrir la vista de tablas de Prisma Studio seleccionando `User`, `Evaluation` e `Attempt`.
* **Qué debe verse:** Registros reales almacenados en la base de datos PostgreSQL con sus columnas, IDs y referencias.
* **Requisito que demuestra:** Persistencia relacional activa en PostgreSQL con datos reales.
* **Pie de figura sugerido:** *Figura 07. Visualización de tablas y registros en PostgreSQL a través de la interfaz de Prisma Studio.*

---

### 4. Aplicación Móvil Flutter y Flujo de Usuario

#### Figura 08: Autenticación de Usuario e Inicio de Sesión
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig08_flutter_login_page.png`
* **Aplicación a abrir:** Emulador Android / iOS o Cliente Flutter Web
* **Pantalla / Ruta:** Pantalla de Login (`/login`)
* **Qué hacer:** Abrir la pantalla de login con los campos de correo y contraseña completados.
* **Qué debe verse:** Formulario de autenticación con campos validados, botón `SafeAccessButton` y branding del proyecto.
* **Requisito que demuestra:** Interfaz de usuario para autenticación con tokens JWT.
* **Pie de figura sugerido:** *Figura 08. Pantalla de inicio de sesión de SafeAccess 90 con autenticación JWT.*

#### Figura 09: Pantalla Principal de Capacitación Inductiva
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig09_flutter_training_page.png`
* **Aplicación a abrir:** Emulador Flutter
* **Pantalla / Ruta:** Pantalla Principal (`/`)
* **Qué hacer:** Iniciar sesión correctamente y navegar a la pantalla principal.
* **Qué debe verse:** Módulo de inducción en seguridad ocupacional, bienvenida al usuario, rol activo y botón para ingresar al quiz.
* **Requisito que demuestra:** Flujo principal de formación inductiva y experiencia del participante.
* **Pie de figura sugerido:** *Figura 09. Interfaz principal de capacitación inductiva de seguridad y estado del participante.*

#### Figura 10: Cuestionario Interactivo de Evaluación (Quiz)
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig10_flutter_quiz_page.png`
* **Aplicación a abrir:** Emulador Flutter
* **Pantalla / Ruta:** Cuestionario (`/quiz`)
* **Qué hacer:** Presionar "Iniciar Evaluación" y responder las preguntas de opción múltiple.
* **Qué debe verse:** Pregunta activa, tarjetas de opciones seleccionables, temporizador y progreso del test.
* **Requisito que demuestra:** Módulo de evaluación de conocimientos y lógica de negocio interactiva.
* **Pie de figura sugerido:** *Figura 10. Interfaz de evaluación interactiva con preguntas de opción múltiple y temporizador.*

#### Figura 11: Certificado Digital de Aprobación
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig11_flutter_certificate_page.png`
* **Aplicación a abrir:** Emulador Flutter
* **Pantalla / Ruta:** Certificado (`/certificate`)
* **Qué hacer:** Completar el quiz con puntaje $\ge 70\%$ (o navegar a `/certificate` con un intento aprobado previo).
* **Qué debe verse:** Tarjeta de certificado mostrando el código alfanumérico único, porcentaje de aprobación y fecha de vigencia.
* **Requisito que demuestra:** Generación y presentación de certificados digitales verificables.
* **Pie de figura sugerido:** *Figura 11. Certificado digital de aprobación emitido con código único de verificación.*

---

### 5. Sistema de Diseño, Adaptabilidad y Estados Visuales

#### Figura 12: Sistema de Diseño Atómico y Componentes Reutilizables
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig12_design_system_components.png`
* **Aplicación a abrir:** Emulador Flutter / Ejecución de `component_catalog_test.dart`
* **Pantalla / Ruta:** Catálogo de Componentes o Pantalla UI con componentes
* **Qué hacer:** Desplegar una vista conteniendo los widgets reutilizables del sistema de diseño.
* **Qué debe verse:** Integración visible de `SafeAccessButton`, `SafeAccessStatusCard`, `SafeAccessSectionCard` y tokens de color/tipografía.
* **Requisito que demuestra:** Sistema de diseño modular y componentes de interfaz estandarizados.
* **Pie de figura sugerido:** *Figura 12. Componentes del sistema de diseño atómico reutilizables de SafeAccess 90.*

#### Figura 13: Adaptabilidad del Diseño (Responsive Layout)
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig13_responsive_design_comparison.png`
* **Aplicación a abrir:** Emulador / Cliente Flutter
* **Pantalla / Ruta:** Pantalla de Capacitación (`/`) en dos resoluciones diferentes
* **Qué hacer:** Visualizar la misma pantalla en ancho móvil (390px) y en ancho tablet/escritorio (800px).
* **Qué debe verse:** Reorganización fluida y proporcional de elementos según los límites del contenedor.
* **Requisito que demuestra:** Diseño responsivo y adaptable a múltiples tamaños de pantalla.
* **Pie de figura sugerido:** *Figura 13. Comparativa de adaptabilidad de interfaz en resoluciones de 390 px (Móvil) y 800 px (Tablet).*

#### Figura 14: Manejo Robusto de Estados Asíncronos (Loading / Error)
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig14_async_states_loading_error.png`
* **Aplicación a abrir:** Emulador Flutter
* **Pantalla / Ruta:** Vista con envoltorio `SafeAccessAsyncState`
* **Qué hacer:** Simular un estado de carga (`isLoading: true`) y un estado de error (`error: "Credenciales inválidas"`).
* **Qué debe verse:** Indicador de carga estilizado y tarjeta de error formateada con acción de reintento.
* **Requisito que demuestra:** Gestión limpia de estados asíncronos en la interfaz móvil.
* **Pie de figura sugerido:** *Figura 14. Retroalimentación visual de la interfaz durante estados de Carga y Error formateado.*

---

### 6. Persistencia Local Offline y Sincronización

#### Figura 15: Operatividad en Modo Offline y Estado Local
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig15_offline_mode_indicator.png`
* **Aplicación a abrir:** Emulador Flutter
* **Pantalla / Ruta:** Pantalla de Capacitación / Quiz en Modo Avión
* **Qué hacer:** Activar Modo Avión en el emulador y realizar una evaluación sin conexión a internet.
* **Qué debe verse:** Indicador de estado "Modo Offline / Local" y antigüedad de los datos en caché local.
* **Requisito que demuestra:** Arquitectura Offline-First y disponibilidad continua sin red.
* **Pie de figura sugerido:** *Figura 15. Operatividad de la aplicación en modo sin conexión con datos locales.*

#### Figura 16: Registro Local de Intento en Estado PENDING_CREATE
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig16_drift_pending_create_record.png`
* **Aplicación a abrir:** Herramienta de inspección SQLite / DevTools / Log consola
* **Pantalla / Ruta:** Base local Drift SQLite (`safeaccess_db`)
* **Qué hacer:** Inspeccionar la tabla `AttemptsTable` tras guardar un intento offline.
* **Qué debe verse:** Fila en `AttemptsTable` mostrando `clientId` (UUID v4) y `syncStatus = PENDING_CREATE`, junto al registro en `PendingOperationsTable`.
* **Requisito que demuestra:** Encolamiento de transacciones pendientes en SQLite local.
* **Pie de figura sugerido:** *Figura 16. Inspección de tabla SQLite local mostrando intento encolado con estado PENDING_CREATE.*

#### Figura 17: Sincronización en Background y Estado SYNCED
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig17_drift_synced_resolution.png`
* **Aplicación a abrir:** Emulador Flutter + Inspección SQLite
* **Pantalla / Ruta:** Base local Drift SQLite (`safeaccess_db`) tras desactivar Modo Avión
* **Qué hacer:** Desactivar Modo Avión. `SyncService` procesa la cola con Backoff Exponencial y sincroniza con NestJS.
* **Qué debe verse:** Registro actualizado a `syncStatus = SYNCED`, asignación de `serverId` asignado por PostgreSQL y eliminación de la fila en `PendingOperationsTable`.
* **Requisito que demuestra:** Sincronización en segundo plano con resolución de conflictos Server Wins e idempotencia.
* **Pie de figura sugerido:** *Figura 17. Sincronización exitosa en background actualizando el registro local a estado SYNCED con serverId.*

#### Figura 18: Cierre de Sesión y Limpieza de Privacidad
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig18_logout_privacy_cleanup.png`
* **Aplicación a abrir:** Emulador Flutter + Inspección SQLite
* **Pantalla / Ruta:** Pantalla tras ejecutar "Cerrar Sesión" (`logout`)
* **Qué hacer:** Presionar "Cerrar Sesión" en la app e inspeccionar la base local SQLite.
* **Qué debe verse:** Confirmación de logout, eliminación del token JWT en `flutter_secure_storage` y base local SQLite vacía ("0 intentos en base de datos local").
* **Requisito que demuestra:** Limpieza de datos por seguridad y privacidad del usuario al cerrar sesión.
* **Pie de figura sugerido:** *Figura 18. Limpieza total de almacenamiento seguro y tablas SQLite al cerrar la sesión.*

---

### 7. Verificación Automatizada y Repositorio

#### Figura 19: Verificación Automatizada de Código Flutter (Analyze y Test)
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig19_flutter_analyze_and_test.png`
* **Aplicación a abrir:** Terminal de PowerShell / CMD
* **Pantalla / Ruta:** Raíz del proyecto Flutter
* **Qué hacer:** Ejecutar `flutter analyze` y posteriormente `flutter test`.
* **Qué debe verse:** Consola indicando `No issues found!` en el análisis sintáctico y `All tests passed! (29/29)` en la suite de pruebas.
* **Requisito que demuestra:** Calidad de código móvil y paso del 100% de las pruebas automatizadas de widgets y unidad.
* **Pie de figura sugerido:** *Figura 19. Verificación exitosa de análisis estático (0 issues) y 29/29 pruebas pasadas en Flutter.*

#### Figura 20: Verificación Automatizada de Backend NestJS (Lint y Test)
* **Clasificación:** OBLIGATORIA
* **Nombre sugerido:** `fig20_backend_lint_and_test.png`
* **Aplicación a abrir:** Terminal de PowerShell / CMD
* **Pantalla / Ruta:** Directorio `backend/`
* **Qué hacer:** Ejecutar `npm run lint` y `npm run test`.
* **Qué debe verse:** Consola de linter con 0 errores y consola de Jest mostrando `Test Suites: 5 passed, 5 total` (24 pruebas unitarias pasadas).
* **Requisito que demuestra:** Calidad de código servidor y cobertura de pruebas unitarias en NestJS.
* **Pie de figura sugerido:** *Figura 20. Ejecución exitosa de linter sin errores y 24/24 pruebas unitarias Jest pasadas en el backend.*

#### Figura 21: Compilación de Producción Backend NestJS (Build)
* **Clasificación:** RECOMENDADA
* **Nombre sugerido:** `fig21_backend_build_success.png`
* **Aplicación a abrir:** Terminal de PowerShell / CMD
* **Pantalla / Ruta:** Directorio `backend/`
* **Qué hacer:** Ejecutar `npm run build`.
* **Qué debe verse:** Salida de la consola con `nest build` finalizado con éxito sin errores de compilación TypeScript y generación de la carpeta `dist/`.
* **Requisito que demuestra:** Validez del código TypeScript para empaquetado y despliegue en producción.
* **Pie de figura sugerido:** *Figura 21. Compilación exitosa del servidor NestJS mediante el comando nest build.*

#### Figura 22: Repositorio GitHub y Estructura Documental
* **Clasificación:** RECOMENDADA
* **Nombre sugerido:** `fig22_github_repository_docs.png`
* **Aplicación a abrir:** Navegador Web / VS Code
* **Pantalla / Ruta:** Repositorio en GitHub `https://github.com/seeker-devil/flutter_App_Movil/tree/develop` o explorador de archivos en `docs/`
* **Qué hacer:** Mostrar el repositorio remoto en la rama `develop` y la carpeta `docs/` con los archivos de arquitectura.
* **Qué debe verse:** Estructura de código del proyecto y lista de documentos Markdown (`FINAL_PROJECT_INVENTORY.md`, `FINAL_GUIDE_COMPLIANCE.md`, `FINAL_API_DOCUMENTATION.md`, `FINAL_REPORT_SOURCE.md`, etc.).
* **Requisito que demuestra:** Disponibilidad del repositorio de código abierto y documentación técnica completa.
* **Pie de figura sugerido:** *Figura 22. Estructura general del repositorio en GitHub y documentos técnicos de arquitectura en docs/.*

---

## Resumen del Plan de Evidencias

| Clasificación | Cantidad de Figuras | Números de Figura |
| --- | --- | --- |
| **OBLIGATORIAS** | 20 capturas | Figura 01 a Figura 20 |
| **RECOMENDADAS** | 2 capturas | Figura 21 y Figura 22 |
| **TOTAL DEFINITIVO** | **22 capturas** | **Figura 01 a Figura 22** |
