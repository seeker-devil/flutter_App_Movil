# Catálogo de Componentes Reutilizables — SafeAccess 90

Este documento contiene la especificación técnica de los componentes reutilizables desarrollados en `lib/design_system/components/`.

---

## COMPONENTE 1: `SafeAccessButton`

### 1. Propósito
Ofrecer un control interactivo (botón) estandarizado para toda la aplicación SafeAccess 90 que cumpla con las pautas visuales del sistema de diseño, área táctil accesible y soporte nativo para estados de carga e inhabilitación.

### 2. Razón para abstraerlo
- No conoce ninguna pantalla específica.
- No conoce rutas de navegación (`go_router`) ni controladores HTTP.
- Recibe la acción mediante el callback `onPressed`.
- El contenido y la etiqueta son parametrizables.
- Su estilo proviene centralizadamente del tema de la aplicación.
- Evita la duplicación de `FilledButton`, `OutlinedButton` y `CircularProgressIndicator` en el código de las páginas.

### 3. Interfaz Pública

| Parámetro | Tipo | Requerido | Valor por Defecto | Propósito |
| --------- | ---- | --------- | ----------------- | --------- |
| `label` | `String` | Sí | N/A | Texto visible del botón |
| `onPressed` | `VoidCallback?` | No | `null` | Función callback ejecutada al presionar el botón |
| `icon` | `IconData?` | No | `null` | Ícono opcional a la izquierda del texto |
| `isLoading` | `bool` | No | `false` | Activa el estado de carga (reemplaza el ícono por un spinner) |
| `variant` | `SafeAccessButtonVariant` | No | `primary` | Variante de diseño (`primary`, `secondary`, `outline`) |
| `semanticLabel` | `String?` | No | `null` | Etiqueta personalizada para lectores de pantalla |
| `isFullWidth` | `bool` | No | `false` | Determina si se expande a todo el ancho disponible |

### 4. Estados Soportados
- **Normal**: Habilitado y listo para recibir toques.
- **Disabled**: `onPressed` es `null`; deshabilita toques e ilustra opacidad reducida.
- **Loading**: `isLoading: true`; muestra spinner accesible y deshabilita interacción.

### 5. Elementos Concretos de Reutilización
- Callback desacoplado: `final VoidCallback? onPressed;`
- Inyección de variante: `final SafeAccessButtonVariant variant;`
- Área táctil garantizada: `ConstrainedBox(constraints: BoxConstraints(minHeight: 48, minWidth: 48))`

---

## COMPONENTE 2: `SafeAccessStatusCard`

### 1. Propósito
Presentar mensajes de retroalimentación semántica del sistema (Información, Éxito, Advertencia, Error) de manera clara, visualmente distinguible y accesible.

### 2. Razón para abstraerlo
- Elimina la necesidad de construir `Container` con bordes, íconos y colores manuales en cada vista.
- Garantiza el cumplimiento de WCAG 1.4.1 (no depender únicamente del color) al integrar íconos y textos estructurados.
- No realiza peticiones HTTP ni conoce la fuente de los datos.

### 3. Interfaz Pública

| Parámetro | Tipo | Requerido | Valor por Defecto | Propósito |
| --------- | ---- | --------- | ----------------- | --------- |
| `title` | `String` | Sí | N/A | Título del mensaje de estado |
| `message` | `String` | Sí | N/A | Cuerpo descriptivo del estado |
| `status` | `SafeAccessStatus` | No | `info` | Tipo semántico (`info`, `success`, `warning`, `error`) |
| `icon` | `IconData?` | No | Ícono por omisión del estado | Ícono personalizado opcional |
| `trailing` | `Widget?` | No | `null` | Elemento adicional a la derecha (ej. botón o ícono extra) |
| `onAction` | `VoidCallback?` | No | `null` | Callback para una acción secundaria (ej. reintentar) |
| `actionLabel` | `String?` | No | `null` | Texto del botón de acción secundaria |

### 4. Estados Soportados
- **`info`**: Fondo azul claro, ícono `info_outline`.
- **`success`**: Fondo verde claro, ícono `check_circle_outline`.
- **`warning`**: Fondo ámbar claro, ícono `warning_amber_rounded`.
- **`error`**: Fondo rojo claro, ícono `error_outline`.

### 5. Elementos Concretos de Reutilización
- Mapeo semántico desacoplado de estilos: `SafeAccessStatus.success` / `SafeAccessStatus.error`.
- Callback opcional: `final VoidCallback? onAction;`

---

## COMPONENTE 3: `SafeAccessAsyncState`

### 1. Propósito
Resolver de forma uniforme los 4 estados principales de cualquier flujo de datos asíncrono: Carga (`Loading`), Sin Datos (`Empty`), Error (`Error`) y Contenido Presente (`Content`).

### 2. Razón para abstraerlo
- Evita sentencias `if-else` repetitivas en el `build()` de las pantallas.
- Proporciona una interfaz declarativa y limpia para manejar peticiones de red o carga de estado.
- Delega el renderizado exitoso a un widget `child`.

### 3. Interfaz Pública

| Parámetro | Tipo | Requerido | Valor por Defecto | Propósito |
| --------- | ---- | --------- | ----------------- | --------- |
| `isLoading` | `bool` | No | `false` | Indica si el flujo se encuentra cargando |
| `error` | `Object?` | No | `null` | Objeto de error o mensaje de falla |
| `isEmpty` | `bool` | No | `false` | Indica si los datos retornados están vacíos |
| `child` | `Widget` | Sí | N/A | Widget a renderizar cuando el estado es exitoso |
| `onRetry` | `VoidCallback?` | No | `null` | Función callback ejecutada al presionar reintentar |
| `loadingMessage` | `String?` | No | `'Cargando datos...'` | Mensaje personalizado de carga |
| `emptyMessage` | `String?` | No | `'No hay información...'` | Mensaje de estado vacío |
| `errorMessage` | `String?` | No | `'Ocurrió un error...'` | Mensaje de falla personalizado |

### 4. Estados Soportados
- **Loading**: `isLoading: true` -> Muestra spinner + `loadingMessage`.
- **Error**: `error != null` -> Muestra `SafeAccessStatusCard` de error + botón de reintento `SafeAccessButton`.
- **Empty**: `isEmpty: true` -> Muestra tarjeta de aviso informativo.
- **Content**: Ninguno de los anteriores es verdadero -> Renderiza `child`.

### 5. Elementos Concretos de Reutilización
- Composición con `SafeAccessStatusCard` y `SafeAccessButton`.
- Reutilizable con cualquier fuente de datos (Future, Stream, Riverpod AsyncValue).

---

## COMPONENTE 4: `SafeAccessSectionCard`

### 1. Propósito
Agrupar visualmente bloques temáticos de contenido en tarjetas con elevación, bordes redondeados y padding consistentes basados en los tokens de espaciado.

### 2. Razón para abstraerlo
- Reemplaza la configuración manual repetida de `Card`, `Padding`, `Column` y `SizedBox`.
- Garantiza que todas las tarjetas de la aplicación tengan el mismo radio de borde (`radiusCard`) y la misma separación.

### 3. Interfaz Pública

| Parámetro | Tipo | Requerido | Valor por Defecto | Propósito |
| --------- | ---- | --------- | ----------------- | --------- |
| `title` | `String` | Sí | N/A | Título de la sección |
| `child` | `Widget` | Sí | N/A | Contenido interno de la sección |
| `subtitle` | `String?` | No | `null` | Subtítulo descriptivo opcional |
| `leadingIcon` | `IconData?` | No | `null` | Ícono opcional junto al título |
| `padding` | `EdgeInsetsGeometry?` | No | `EdgeInsets.all(AppSpacing.lg)` | Padding interno |

### 4. Estados Soportados
- Contenedor estático parametrizable.

### 5. Elementos Concretos de Reutilización
- Consumo directo de tokens `AppSpacing.lg` (16px) y `AppRadius.radiusCard` (16px).
