# Guía de Grabación de Video — Semana 12: SafeAccess 90

Esta guía especifica exactamente la secuencia de acciones, pantallas a abrir, botones a pulsar y el guion narrativo sugerido para grabar la demostración práctica del **Taller – Semana 12**.

---

## Preparación del Entorno

1. Iniciar el backend NestJS:
   ```bash
   cd backend
   npm run start:dev
   ```
2. Ejecutar la aplicación Flutter (Web Chrome / Windows Desktop):
   ```bash
   flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api
   ```

---

## Guion y Secuencia Operativa (Paso a Paso)

| Paso | Acción en Pantalla | Qué Mostrar / Qué Pulsar | Guion Narrativo Sugerido |
| :---: | :--- | :--- | :--- |
| **1** | **Pantalla de Login** | Abrir la app. Ingresar `admin@safeaccess90.com` / `admin123`. Presionar "Iniciar Sesión". | *"Comenzamos en la pantalla de inicio de sesión de SafeAccess 90 autenticando con credenciales reales contra el backend NestJS."* |
| **2** | **Almacenamiento Seguro** | Mostrar el token de acceso guardado y navegar por la app. | *"Al autenticar, el JWT se guarda en el KeyStore/Keychain del sistema a través de `flutter_secure_storage`."* |
| **3** | **Reapertura de App** | Recargar o reabrir la aplicación en el navegador/escritorio. | *"Al cerrar y reabrir la aplicación, la sesión se restaura automáticamente leyendo el token seguro sin pedir credenciales nuevamente."* |
| **4** | **Datos Online** | Navegar a la pantalla de Capacitación / Intentos. Mostrar los registros sincronizados. | *"En modo online, la aplicación consulta los datos del backend, los persiste en SQLite relacional (`drift`) y renderiza la interfaz desde la base local."* |
| **5** | **Activar Modo Offline** | Desactivar la conexión a Internet (Offline en DevTools Network tab / desconectar Wi-Fi). | *"Simulamos la pérdida de conectividad de un trabajador en campo pasando a modo Offline."* |
| **6** | **Visualizar Antigüedad** | Observar la insignia visual con estado "Sin conexión" y el texto de antigüedad. | *"La pantalla reacciona inmediatamente mostrando el estado Offline y la antigüedad de la última sincronización en formato legible."* |
| **7** | **Crear Registro Offline** | Presionar el botón "Registrar Intento Offline". Rellenar score/evaluación. | *"Creamos un nuevo intento de capacitación sin conexión. La app genera un `clientId` UUID v4 y lo guarda inmediatamente en SQLite con estado `PENDING_CREATE`."* |
| **8** | **Operación Pendiente** | Mostrar el nuevo intento en la lista local marcado con icono de reloj/alerta naranja. | *"El intento se refleja al instante en la UI sin esperar al servidor y queda registrado en la cola `PendingOperations`."* |
| **9** | **Restablecer Conexión** | Desactivar el modo Offline en DevTools / Reconectar red. | *"Restablecemos la conectividad a Internet."* |
| **10** | **Sincronización Automática** | Observar el `SyncService` enviando la cola y actualizando el intento a `SYNCED` con la marca de tiempo del servidor. | *"El `SyncService` detecta la conectividad, procesa la cola con backoff exponencial, envía el `clientId` al backend y recibe el `serverId` real garantizando idempotencia."* |
| **11** | **Cierre de Sesión (Logout)** | Presionar "Cerrar Sesión". | *"Finalmente ejecutamos el cierre de sesión real."* |
| **12** | **Confirmación de Limpieza** | Reabrir la app o intentar acceder a rutas protegidas. | *"Al cerrar sesión se elimina el token del almacenamiento seguro y se destruye la base de datos SQLite local completa, garantizando la privacidad de los datos."* |
