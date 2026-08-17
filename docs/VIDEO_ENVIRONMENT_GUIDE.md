# Guía de Demostración en Video - Entorno Móvil SafeAccess 90

Esta guía proporciona el guion exacto, comandos a ejecutar y elementos visuales a mostrar durante la grabación del video de evaluación para el proyecto integrador **SafeAccess 90**.

---

## Estructura del Guion de Video (16 Puntos)

### 1. Presentación de la Aplicación SafeAccess 90
- **Qué decir**: "Bienvenidos a la demostración del entorno de desarrollo móvil para el proyecto integrador SafeAccess 90. Vamos a verificar la configuración de Flutter, la conexión con nuestro propio backend NestJS y la ejecución en tiempo real."
- **Qué mostrar**: Pantalla de código en el IDE con la estructura del proyecto `training_quiz_app`.

### 2. Justificación Técnica de Flutter
- **Qué decir**: "Utilizamos Flutter como framework móvil porque permite compartir una única base de código multilplataforma, cuenta con Hot Reload para desarrollo ágil, ofrece alto rendimiento nativo y facilita la integración desacoplada con APIs REST mediante variables de entorno."
- **Qué mostrar**: Archivo `pubspec.yaml` en el editor mostrando las dependencias `flutter_riverpod`, `go_router` y `http`.

### 3. Verificación de Versión de Flutter
- **Comando a ejecutar en la terminal**:
  ```bash
  flutter --version
  ```
- **Qué mostrar**: La salida de la terminal mostrando Flutter 3.44.6 y Dart 3.12.2.

### 4. Diagnóstico del Entorno con `flutter doctor`
- **Comando a ejecutar en la terminal**:
  ```bash
  flutter doctor -v
  ```
- **Qué mostrar**: El reporte detallado de `flutter doctor -v`, destacando los componentes instalados y explicando transparentemente las observaciones del SDK.

### 5. Verificación de Dispositivos Disponibles
- **Comando a ejecutar en la terminal**:
  ```bash
  flutter devices
  ```
- **Qué mostrar**: Los destinos de ejecución detectados (Chrome, Windows Desktop, Edge).

### 6. Inspección de la Estructura Real del Proyecto
- **Qué decir**: "Demostramos que estamos trabajando sobre el proyecto real SafeAccess 90 y no una plantilla por defecto."
- **Qué mostrar**: Expandir en el explorador de archivos:
  - `lib/config/api_config.dart`
  - `lib/services/health_api_service.dart`
  - `lib/features/training/training_page.dart`
  - `android/app/src/main/res/xml/network_security_config.xml`
  - `backend/src/health/health.controller.ts`

### 7. Selección del Destino de Ejecución
- **Qué decir**: "Para esta computadora seleccionamos Google Chrome (Web) como destino de ejecución real, ya que el SDK de Android no está instalado localmente. Además dejamos completamente configurado el soporte para Emulador Android (`10.0.2.2`) y dispositivos físicos mediante la IP LAN."

### 8. Ejecución de la Aplicación Flutter con Variable de Entorno
- **Comando a ejecutar**:
  ```bash
  flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api
  ```
- **Qué mostrar**: La terminal iniciando el servidor de desarrollo web y abriendo la ventana del navegador con SafeAccess 90.

### 9. Demostración de Hot Reload
- **Paso 1**: Con la aplicación en ejecución, abrir `lib/features/training/training_page.dart`.
- **Paso 2**: Modificar un texto de la interfaz, por ejemplo cambiar `'SafeAccess 90 - Capacitación'` por `'SafeAccess 90 - Capacitación [DEMO]'`.
- **Paso 3**: Guardar el archivo (o presionar `r` en la consola de `flutter run`).
- **Qué mostrar**: La aplicación actualizándose instantáneamente en el navegador sin reiniciarse ni perder el estado.

### 10. URL Utilizada para Alcanzar el Backend
- **Qué decir**: "La URL base de la API no está escrita de forma rígida en el código. Se lee centralizadamente desde `lib/config/api_config.dart` mediante `--dart-define=API_BASE_URL=...`. Para Web/PC utilizamos `http://localhost:3000/api` y para Emulador Android `http://10.0.2.2:3000/api`."

### 11. Estado del Backend NestJS
- **Comando a ejecutar en la terminal de backend (`backend/`)**:
  ```bash
  npm run start:dev
  ```
- **Qué mostrar**: Log de NestJS compilando y mostrando `Backend is running on port 3000`.

### 12. Petición Directa al Endpoint `/api/health`
- **Comando a ejecutar en PowerShell**:
  ```powershell
  Invoke-RestMethod -Uri "http://localhost:3000/api/health"
  ```
- **Qué mostrar**: La respuesta JSON devuelta por NestJS:
  `{"success": true, "message": "SafeAccess 90 backend is running", "timestamp": "..."}`.

### 13. Petición y Respuesta Visible dentro de Flutter
- **Acción en la app**: En la pantalla de Capacitación de SafeAccess 90, presionar el botón **"Probar conexión con API"**.
- **Qué mostrar**:
  1. El indicador de carga girando brevemente.
  2. La tarjeta de estado cambiando a verde con el mensaje:
     `Backend conectado correctamente`
     `SafeAccess 90 backend is running`
     `Timestamp: ...`

### 14. Presentación del README
- **Qué mostrar**: Abrir `README.md` y recorrer la sección **"Configuración del entorno móvil"**, resaltando las versiones registradas, comandos de ejecución y notas de seguridad.

### 15. Dificultades y Soluciones Reales
- **Qué decir**: "Durante la configuración abordamos tres desafíos reales: ajustar la ruta ejecutable de Flutter en el entorno local, seleccionar el target Web al no estar presente el SDK de Android, y acotar la seguridad de red en Android mediante `network_security_config.xml` para tráfico HTTP local."

### 16. Confirmación del Repositorio y Estado Git
- **Comandos a mostrar**:
  ```bash
  git status
  ```
- **Qué decir**: "El proyecto se encuentra listo sobre la rama de desarrollo del repositorio oficial `https://github.com/seeker-devil/flutter_App_Movil.git`."

---
*Fin de la guía de grabación.*
