# Decisiones Técnicas de Almacenamiento y Salud de Mantenimiento — SafeAccess 90

Este documento justifica la selección de bibliotecas y arquitecturas utilizadas para la persistencia local y el almacenamiento seguro de **SafeAccess 90**, documentando el estado de salud de mantenimiento de cada paquete.

---

## Matriz de Evaluación de Dependencias

| Paquete | Versión Instalada | Propósito | Razón de Elección | Alternativa Descartada | Salud de Mantenimiento / Verificación |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `flutter_secure_storage` | `^9.2.2` | Almacenamiento cifrado de tokens JWT (`accessToken`). | Integra el KeyStore de Android y Keychain de iOS nativamente. Altamente probado en la industria. | `SharedPreferences` (no cifra por defecto) / `Hive` encriptado (requiere gestión manual de clave). | **Mantenimiento Activo** (Soporte oficial por comunidad Flutter Community). |
| `drift` | `^2.20.2` | Base de datos relacional local (SQLite). | Ofrece tipado estricto, migraciones explícitas, consultas reactivas (Streams), soporte relacional y excelente rendimiento. | `Hive` / `Shared Preferences` (No son bases relacionales; carecen de SQL, restricciones UNIQUE y transacciones ACID complejas). | **Mantenimiento Activo** (Desarrollador principal Simon Binder, actualizaciones constantes). |
| `drift_flutter` | `^0.2.0` | Abstracción de conexión para Drift en plataformas móviles/web/desktop. | Simplifica la inicialización del motor SQLite nativo en dispositivos y plataformas soportadas. | Conexiones manuales por isolates con FFI. | **Mantenimiento Activo** (Paquete oficial del ecosistema Drift). |
| `connectivity_plus` | `^6.0.5` | Monitoreo del estado de red del dispositivo. | Estándar de la comunidad (Flutter Community) para recibir eventos de cambio de conectividad (WiFi/Mobile/None). | Polling manual HTTP continuado (consume batería e infraestructura ineficientemente). | **Mantenimiento Activo** (Plugin oficial de Flutter Community). |
| `uuid` | `^4.5.1` | Generación de identificadores únicos universales (`clientId` v4). | Permite crear IDs únicos en el cliente antes de contactar al servidor, condición indispensable para la sincronización offline e idempotencia. | Autoincrementales locales (propenso a colisiones al sincronizar con backend). | **Mantenimiento Activo** (Estándar de la comunidad Dart/Flutter). |
| `sqlite3_flutter_libs` | `^0.5.24` | Binarios SQLite nativos para Android/iOS/Windows/Linux. | Incluye la versión compilada más reciente de SQLite en el bundle de la app. | SQLite del sistema operativo (versiones inconsistentes entre fabricantes Android). | **Mantenimiento Activo**. |

---

## Estrategia de Migración de Base de Datos Local

1. **`schemaVersion = 1`**: Versión inicial que define la tabla relacional `attempts` y `pending_operations`.
2. **Estrategia para Versiones Futuras**: Drift implementa `MigrationStrategy` con métodos `onCreate`, `onUpgrade` y `beforeOpen`. Cualquier modificación al esquema SQLite se gestionará mediante migraciones explícitas documentadas en `lib/local/database/migrations/`.
