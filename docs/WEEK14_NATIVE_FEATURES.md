# Documentación Técnica - Taller Semana 14: Funcionalidades Nativas (SafeAccess 90)

---

## 1. Justificación y Carácter Opcional de Capacidades Nativas

### 1.1 Objetivo del Módulo
El módulo **Evidencia de Seguridad** permite a los supervisores y trabajadores registrar observaciones de campo (por ejemplo, reporte de EPP dañados, zonas de riesgo o extintores vencidos) adjuntando opcionalmente una **fotografía tomada en tiempo real** y las **coordenadas GPS de ubicación**.

### 1.2 Principio de Opcionalidad y Continuidad Operativa
- **No Invasivo:** Ninguna funcionalidad nativa es bloqueante para el uso general de la aplicación.
- **Degradación Elegante:** Si el usuario deniega los permisos de Cámara o Ubicación, o si el servicio de GPS se encuentra apagado, el usuario **puede guardar la descripción textual de la observación**, persistirla en la base SQLite local (Drift) y sincronizarla con el backend NestJS sin ningún inconveniente.
- **Continuidad de Capacitación y Evaluación:** La denegación de permisos nativos no interfiere con el material de capacitación ni con la ejecución de evaluaciones o generación de certificados.

---

## 2. Plugins Seleccionados, Versiones y Criterios de Selección

| Plugin | Versión Instalada | Licencia | Compatibilidad | Criterios de Selección & Mantenimiento | Enlace Oficial |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`image_picker`** | `^1.1.2` (`1.1.4` lock) | BSD-3-Clause | Android / iOS / Web / Desktop | Plugin oficial mantenido por el equipo de Flutter (`flutter.dev`). Utiliza intents nativos del sistema en Android (`MediaStore.ACTION_IMAGE_CAPTURE`), evitando la solicitud de permisos amplios de almacenamiento. | [pub.dev/packages/image_picker](https://pub.dev/packages/image_picker) |
| **`geolocator`** | `^13.0.1` (`13.0.4` lock) | MIT | Android / iOS / Web / macOS | Desarrollado por Baseflow, es el estándar de la industria para geolocalización en Flutter. Soporta verificación de estado de GPS, chequeo de permisos (`checkPermission`), solicitud (`requestPermission`) y coordenadas bajo demanda (`getCurrentPosition`). | [pub.dev/packages/geolocator](https://pub.dev/packages/geolocator) |
| **`permission_handler`** | `^11.3.1` (`11.4.0` lock) | MIT | Android / iOS | Mantenido por Baseflow. Proporciona una API unificada para la gestión de estados de permisos (`isGranted`, `isDenied`, `isPermanentlyDenied`) y acceso directo a los Ajustes del Sistema mediante `openAppSettings()`. | [pub.dev/packages/permission_handler](https://pub.dev/packages/permission_handler) |

---

## 3. Configuración de Permisos en Android e iOS

### 3.1 Declaración en Android (`AndroidManifest.xml`)
Se declararon únicamente los permisos estrictamente necesarios durante el uso. No se solicitaron permisos de ubicación en segundo plano (`ACCESS_BACKGROUND_LOCATION`) ni acceso general a la galería (`READ_EXTERNAL_STORAGE`).

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    ...
</manifest>
```

### 3.2 Cadenas de Propósito en iOS (`ios/Runner/Info.plist`)
Se configuraron las cadenas explicativas de propósito exigidas por Apple:

```xml
<key>NSCameraUsageDescription</key>
<string>Se requiere acceso a la cámara para capturar evidencias fotográficas en las observaciones de seguridad.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Se requiere su ubicación durante el uso para adjuntar coordenadas GPS precisas a los reportes de evidencia de seguridad.</string>
```

---

## 4. Matriz de Degradación de Permisos y Estados del Sistema

| Recurso Nativo | Estado del Permiso / Servicio | Comportamiento en la App | Acción de Recuperación / UX |
| :--- | :--- | :--- | :--- |
| **Cámara** | **No solicitado** | Muestra el botón "Tomar Fotografía con Cámara". | Al pulsar, muestra un diálogo previo explicativo (rationale) y solicita el permiso. |
| **Cámara** | **Concedido** | Abre la interfaz nativa de la cámara, permite capturar la foto y guardarla en almacenamiento privado. | El usuario puede visualizar la miniatura o eliminarla. |
| **Cámara** | **Denegado** | No abre la cámara. Muestra SnackBar explicativo y permite guardar la observación solo con texto. | El usuario puede volver a pulsar el botón para reintentar la solicitud. |
| **Cámara** | **Denegado Permanentemente** | Muestra un banner de advertencia visual y deshabilita la captura directa. | Muestra el botón **"Abrir Ajustes del Sistema"** (`openAppSettings()`). Al regresar a la app (`resumed`), el estado se re-evalúa automáticamente. |
| **Cámara** | **Captura Cancelada / Fallo** | El usuario presiona regresar o la cámara falla. La app no se cierra ni se bloquea. | Restablece el estado manteniendo los datos del formulario intactos. |
| **Ubicación** | **GPS Desactivado (Off)** | Detectado por `Geolocator.isLocationServiceEnabled()`. | Muestra una alerta informando que el GPS está apagado. El usuario puede activarlo en los ajustes rápidos o guardar sin coordenadas. |
| **Ubicación** | **Permiso Denegado** | `Geolocator.checkPermission()` retorna `denied`. | Muestra diálogo explicativo (rationale) previo a solicitar el permiso. |
| **Ubicación** | **Denegado Permanentemente** | `Geolocator.checkPermission()` retorna `deniedForever`. | Muestra el botón **"Abrir Ajustes del Sistema"**. |
| **Ubicación** | **Fallo / Timeout** | Ocurre un error de lectura de satélite o timeout (>10s). | Captura el error sin bloquear la app y permite continuar. |

---

## 5. Integración de Persistencia Local y Backend

### 5.1 Persistencia Local Privada
- **Fotografía:** Se guarda mediante `path_provider` en el directorio de documentos privados de la app (`/app_flutter/evidences/{uuid}.jpg`). No depende del caché temporal del sistema ni de la galería pública.
- **Base de Datos SQLite (Drift):** Se definió la tabla `EvidencesTable` (`@DataClassName('LocalEvidence')`) con los campos:
  - `id` (int autoIncrement)
  - `clientId` (UUID v4 único)
  - `serverId` (int nullable)
  - `description` (text)
  - `imagePath` (text nullable)
  - `latitude` / `longitude` (real nullable)
  - `capturedAt` (dateTime)
  - `syncStatus` (`PENDING`, `SYNCED`, `FAILED`)
- **Limpieza en Logout:** El método `clearAllTablesOnLogout()` en `AppDatabase` elimina físicamente los archivos de fotografía del almacenamiento privado y vacía las tablas de SQLite en una transacción.

### 5.2 Contrato Backend NestJS y Prisma
- **Modelo Prisma:** `SafetyEvidence` en PostgreSQL vinculado al `User`.
- **Endpoint:** `POST /api/evidences` resguardado por `JwtAuthGuard`.
- **Transferencia de Archivos:** Soporta payloads `multipart/form-data` con `@UseInterceptors(FileInterceptor('file'))`. La imagen se almacena en `backend/uploads/evidences/` y se expone de forma estática vía `/uploads/...`.
- **Prevención de Duplicados (Idempotencia):** El backend verifica el `clientId`. Si la evidencia ya existe para el usuario, devuelve el registro existente (`200 OK / 201 Created`) en lugar de duplicar o arrojar error al reintentar la cola offline.

---

## 6. Verificación de Niveles de API Objetivo en Android (Google Play)

### 6.1 Análisis del Nivel de API Objetivo
- **Configuración del Proyecto:** `android/app/build.gradle.kts` utiliza `targetSdk = flutter.targetSdkVersion` y `compileSdk = flutter.compileSdkVersion`.
- **Verificación Oficial:** Según la política oficial de Google Play (vigente desde el **31 de agosto de 2024**), todas las actualizaciones de aplicaciones deben tener como objetivo **Android 14 (API nivel 34)** o superior.
- **Evaluación de la Mención sobre Android 16:** Las compilaciones preliminares de Android 16 (API 36) fueron publicadas en el ciclo 2025/2026. La exigencia vigente en tiendas es target API 34+, cumplida al 100% por el SDK de Flutter utilizado.

---

## 7. Matriz de Escenarios de Prueba

| Escenario | Condición de Prueba | Resultado Esperado | Resultado Real de Ejecución |
| :---: | :--- | :--- | :---: |
| **1** | Permisos concedidos | Captura de fotografía con cámara y obtención de coordenadas GPS exitosas. Guardado local y sync al backend. | **Exitoso (Verificado en Pruebas Unitarias/Automáticas)** |
| **2** | Permiso denegado | Explicación previa en diálogo. Continuidad guardando la observación solo con descripción textual. | **Exitoso (Verificado)** |
| **3** | Denegación permanente | Banner informativo con botón "Abrir Ajustes". Al regresar, la app re-evalúa el permiso sin bucles. | **Exitoso (Verificado)** |
| **4** | Indisponibilidad | GPS apagado detectado; cancelación de cámara manejada sin crashes ni cierre de app. | **Exitoso (Verificado)** |
| **5** | Sin conexión (Offline) | Evidencia guardada en SQLite local (`PENDING`). Al recuperar red, sincronización multipart al backend NestJS. | **Exitoso (Verificado)** |

---

## 8. Pasos para Demostrar las Capacidades en un Teléfono Android Físico

### 8.1 Iniciar el Backend NestJS y exponerlo en la Red Local
1. En la PC, abrir una terminal en `backend/` y ejecutar:
   ```bash
   npm run start:dev
   ```
2. Obtener la IP local de la PC (ej. `192.168.1.15` en Windows usando `ipconfig`).
3. En la app Flutter (`lib/config/api_config.dart`), asegúrese de que `baseUrl` apunte a la IP de su PC:
   `http://192.168.1.15:3000/api`

### 8.2 Compilar y Ejecutar en Dispositivo Físico
1. Conectar el teléfono Android mediante cable USB y activar **Depuración USB**.
2. Verificar dispositivo detectado: `flutter devices`.
3. Ejecutar la app:
   ```bash
   flutter run -d <device_id>
   ```

### 8.3 Guía de Demostración en Video / Prueba Manual
1. **Paso 1:** Iniciar sesión con `admin@safeaccess90.com` / `admin123`.
2. **Paso 2:** En la pantalla principal, presionar **"Registrar Evidencia de Seguridad"**.
3. **Paso 3 (Demostrar Cámara):** Presionar **"Tomar Fotografía con Cámara"**. Aceptar el permiso y capturar una foto de prueba.
4. **Paso 4 (Demostrar Ubicación):** Presionar **"Obtener Ubicación Actual"**. Aceptar el permiso y verificar la visualización de coordenadas GPS.
5. **Paso 5 (Guardar y Sincronizar):** Ingresar una descripción y presionar **"Guardar Observación Local y Sincronizar"**. Verificar la insignia `SYNCED`.
6. **Paso 6 (Demostrar Modo Offline):** Activar Modo Avión en el teléfono, registrar una observación y verificar la insignia `PENDING`. Al desactivar Modo Avión y pulsar "Sincronizar Cola", verificar el cambio a `SYNCED`.
