# Política de Privacidad de Datos Locales — SafeAccess 90

Este documento detalla la política de manejo, protección y privacidad de datos almacenados localmente en los dispositivos móviles de la plataforma **SafeAccess 90**.

---

## Tabla de Tratamiento y Retención de Datos Locales

| Dato | Finalidad | Almacenamiento | Sensibilidad | Retención | Eliminación |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Tokens de Sesión (`accessToken`)** | Mantener la autenticación activa del usuario. | `flutter_secure_storage` (Cifrado OS KeyStore / Keychain) | Alta | Mientras la sesión esté activa. | Se borra inmediatamente al presionar "Cerrar Sesión" (*Logout*). |
| **Registros de Intentos Locales (`Attempt`)** | Permitir consulta offline y creación diferida de evaluaciones. | Base de datos SQLite relacional (`drift`) | Media | Durante la sesión activa o hasta sincronizar con el servidor. | Se eliminan todas las filas al ejecutar el proceso de Logout. |
| **Cola de Operaciones Pendientes (`PendingOperations`)** | Garantizar el envío fiable de peticiones sin duplicación. | Base de datos SQLite relacional (`drift`) | Media | Temporal hasta confirmación exitosa (`SYNCED`) o hasta Logout en caso de error persistente. | Se elimina la fila procesada al recibir respuesta 200/201/409 del backend. Se destruye la cola completa al hacer Logout. |
| **Timestamps de Sincronización (`lastSyncAt`)** | Calcular la antigüedad de los datos en la interfaz. | SQLite (`drift`) | Baja | Durante la sesión activa. | Se borra al hacer Logout. |

---

## Estrategia de Minimización y Privacidad

1. **Retención Basada en Sesión**: Ningún dato personal o resultado de evaluación permanece en el almacenamiento local del dispositivo una vez que el usuario cierra sesión.
2. **Cifrado en Reposo**: Los tokens de acceso y credenciales de sesión se almacenan exclusivamente utilizando hardware respaldado por el sistema operativo (EncryptedSharedPreferences en Android / Keychain en iOS / DPAPI en Windows).
3. **Aislamiento de la Base de Datos Local**: La base de datos SQLite se crea en el directorio privado de datos de la aplicación (`getApplicationDocumentsDirectory`), inaccesible para otras aplicaciones no autorizadas del dispositivo.
4. **Cero persistencia de tokens en colas de mensajes**: Los payloads de sincronización guardados en SQLite contienen únicamente los datos de negocio (`evaluationId`, `score`, `status`, `clientId`). Los tokens de autenticación **nunca** se graban en disco en texto plano ni dentro de archivos de cola.
