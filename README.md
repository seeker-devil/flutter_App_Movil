# SafeAccess 90 - Aplicación Móvil e Integración Backend

Aplicación móvil integradora **SafeAccess 90** desarrollada en Flutter para capacitación, evaluación, certificación y verificación de estado del backend en tiempo real.

---

## Sistema de diseño y catálogo de componentes

### Ubicación del Sistema de Tokens
- **Tokens de Color**: [`lib/design_system/tokens/app_colors.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/tokens/app_colors.dart)
- **Tokens de Espaciado**: [`lib/design_system/tokens/app_spacing.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/tokens/app_spacing.dart)
- **Tokens de Radios**: [`lib/design_system/tokens/app_radius.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/tokens/app_radius.dart)
- **Tokens de Tipografía**: [`lib/design_system/tokens/app_typography.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/tokens/app_typography.dart)

### Ubicación del Tema Accesible
- **Tema Centralizado**: [`lib/design_system/theme/app_theme.dart`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/lib/design_system/theme/app_theme.dart)

### Catálogo de Componentes Reutilizables
1. **`SafeAccessButton`** (`lib/design_system/components/safe_access_button.dart`): Botón accesible con área táctil mínima de 48x48 px, variantes (`primary`, `secondary`, `outline`), estados loading/disabled y `Semantics`.
2. **`SafeAccessStatusCard`** (`lib/design_system/components/safe_access_status_card.dart`): Tarjeta para retroalimentación semántica (`info`, `success`, `warning`, `error`) cumpliendo WCAG 1.4.1.
3. **`SafeAccessAsyncState`** (`lib/design_system/components/safe_access_async_state.dart`): Gestor de estados de carga, vacío, error y contenido.
4. **`SafeAccessSectionCard`** (`lib/design_system/components/safe_access_section_card.dart`): Tarjeta modular de secciones estructuradas.

### Pantalla Real Demostrada
- **`TrainingPage`** (`lib/features/training/training_page.dart`): Refactorizada para ensamblar los componentes del catálogo manteniendo la lógica de negocio y backend completamente desacopladas.

### Criterios de Accesibilidad (WCAG 2.1)
- Relaciones de contraste calculadas superiores a **6.5:1** (Cumplimiento AA / AAA).
- Área táctil de controles interactivos de **48x48 logical pixels**.
- Anuncios semánticos con `Semantics`.
- No dependencia exclusiva del color (uso combinado de íconos, bordes y textos).

### Documentación Técnica Adicional
- [`docs/SCREEN_ENDPOINT_INVENTORY.md`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/docs/SCREEN_ENDPOINT_INVENTORY.md)
- [`docs/ACCESSIBILITY_AUDIT.md`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/docs/ACCESSIBILITY_AUDIT.md)
- [`docs/COMPONENT_CATALOG.md`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/docs/COMPONENT_CATALOG.md)
- [`docs/REPORT_SOURCE_GUIDE.md`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/docs/REPORT_SOURCE_GUIDE.md)
- [`docs/AI_USAGE_LOG.md`](file:///C:/Users/alejo/Desktop/work%20sin%20BACKUP/github/sem5/appmov/flutter/training_quiz_app/docs/AI_USAGE_LOG.md)

---

## Configuración del entorno móvil

### Framework
**Flutter** (Dart)

### Justificación técnica
Se selecciona Flutter para el desarrollo de SafeAccess 90 debido a:
- **Base de código única**: Permite desplegar aplicaciones multiplataforma (Android, iOS, Web, Windows) desde un solo repositorio.
- **Recarga en caliente (Hot Reload)**: Acelera drásticamente el flujo de desarrollo al permitir ver cambios en la interfaz de manera instantánea sin perder el estado actual de la app.
- **Ecosistema y rendimiento**: Compilación nativa de alto rendimiento y amplio ecosistema de paquetes oficial (como `http`, `flutter_riverpod`, `go_router`).
- **Integración API REST**: Comunicación limpia y mantenible con backends NestJS mediante servicios desacoplados y variables de entorno (`--dart-define`).

### Versiones reales del entorno

- **Flutter**: `3.44.6` (channel stable)
- **Dart**: `3.12.2`
- **DevTools**: `2.57.0`
- **Android SDK**: No localizado en la máquina actual (`Unable to locate Android SDK`).
- **Java/JDK**: N/A (requiere instalación previa del Android SDK si se desea compilar APK).
- **Node.js**: `v22.20.0`
- **npm**: `10.9.3`
- **Docker**: `29.5.2` (Docker Compose `v5.1.3`)
- **PostgreSQL**: `15` (`postgres:15` en `docker-compose.yml`)
- **Redis**: `7` (`redis:7` en `docker-compose.yml`)

### Diagnóstico del entorno
Comando ejecutado:
```bash
flutter doctor -v
```
**Resultado del diagnóstico:**
- `[√] Flutter`: 3.44.6 instalado en `C:\Users\alejo\Documents\flutter\flutter`
- `[√] Windows Version`: Windows 11 Home 64-bit
- `[X] Android toolchain`: SDK de Android no localizado en el sistema local.
- `[√] Chrome`: Google Chrome listo para ejecuciones Web.
- `[!] Visual Studio`: Visual Studio Build Tools detectado (requiere componentes C++ para apps de escritorio Windows).
- `[√] Connected device`: 3 destinos disponibles (Chrome Web, Windows Desktop, Edge Web).

### Instalación de dependencias
```bash
flutter pub get
```

### Dispositivos disponibles
Comando de verificación:
```bash
flutter devices
```
Destinos detectados:
- `Chrome (web)`: `chrome`
- `Edge (web)`: `edge`
- `Windows (desktop)`: `windows`

### Inicio y verificación del Backend (NestJS)

1. Navegar al directorio del backend:
   ```bash
   cd backend
   ```
2. Iniciar contenedores de soporte (PostgreSQL / Redis):
   ```bash
   docker compose up -d
   ```
3. Iniciar el servidor de desarrollo NestJS:
   ```bash
   npm run start:dev
   ```
4. Comprobar disponibilidad del endpoint de salud desde Windows:
   ```powershell
   Invoke-RestMethod -Uri "http://localhost:3000/api/health"
   ```
   **Respuesta esperada:**
   ```json
   {
     "success": true,
     "message": "SafeAccess 90 backend is running",
     "timestamp": "2026-08-16T..."
   }
   ```

### Ejecución de Flutter

#### En Web (Chrome) / Windows (Target actual en este equipo):
```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api
```

#### En Android Emulator:
```bash
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```
> **¿Por qué `10.0.2.2`?**  
> El emulador de Android corre dentro de una máquina virtual con su propia interfaz de red loopback (`127.0.0.1` en el emulador apunta a sí mismo). El alias IP `10.0.2.2` es una redirección especial provista por el emulador Android para conectarse a la interfaz loopback (`127.0.0.1` / `localhost`) del computador anfitrión donde corre el backend NestJS.

#### En Dispositivo Físico Android:
Determinar la IP local (LAN) del computador ejecutando en PowerShell:
```powershell
ipconfig
```
Buscar la IPv4 (ejemplo `192.168.1.50`) y ejecutar:
```bash
flutter run -d <deviceId> --dart-define=API_BASE_URL=http://192.168.1.50:3000/api
```

### Configuración de Seguridad para Tráfico HTTP Local
En `android/app/src/main/res/xml/network_security_config.xml` se configuró una excepción acotada para permitir tráfico HTTP (sin cifrar) únicamente hacia hosts de desarrollo local (`10.0.2.2`, `localhost`, `127.0.0.1`).

> **Advertencia de Seguridad:**  
> Esta excepción existe **exclusivamente para desarrollo local**. En entornos de producción debe utilizarse HTTPS cifrado mediante certificados SSL/TLS válidos.

### Problemas Reales Encontrados durante la Configuración

1. **Ruta ejecutable de Flutter fuera del PATH global por defecto**: Se identificó que Flutter se encuentra instalado en `C:\Users\alejo\Documents\flutter\flutter\bin`, requiriendo la especificación explícita de su ejecutable o su inclusión en el PATH de la sesión de comandos.
2. **Android SDK no disponible en el sistema local**: `flutter doctor -v` reportó la ausencia del SDK de Android. Por consiguiente, se seleccionó Chrome (Web) como destino de ejecución real primario para este equipo, manteniendo la compatibilidad completa de Android mediante `network_security_config.xml`.
3. **Falta de instalación de paquetes Node en backend**: El backend NestJS requirió la ejecución previa de `npm install` para resolver módulos requeridos por `@nestjs/jwt` e `ioredis`.

---

## Pruebas automatizadas

Para ejecutar las pruebas unitarias y del catálogo de componentes:
```bash
flutter test
```
