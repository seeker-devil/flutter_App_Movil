# Auditoría de Accesibilidad (WCAG 2.1) — SafeAccess 90

Este documento registra los cálculos matemáticos reales de relación de contraste de luminancia, la verificación de área táctil mínima, el etiquetado semántico y las reglas de diseño para evitar la dependencia exclusiva del color.

---

## 1. Mediciones de Contraste de Colores (WCAG 2.1)

### Fórmula de Contraste Aplicada
Para cada canal de color RGB en la escala `[0, 255]`:
$$c = \frac{C}{255}$$
$$c' = \begin{cases} \frac{c}{12.92} & \text{si } c \le 0.04045 \\ \left(\frac{c + 0.055}{1.055}\right)^{2.4} & \text{si } c > 0.04045 \end{cases}$$

Luminancia relativa $L$:
$$L = 0.2126 \cdot R' + 0.7152 \cdot G' + 0.0722 \cdot B'$$

Relación de Contraste ($CR$):
$$CR = \frac{L_1 + 0.055}{L_2 + 0.055} \quad (L_1 > L_2)$$

---

### Tabla de Mediciones Semánticas Reales

| Elemento / Uso | Color Fondo (Hex) | Color Primer Plano (Hex) | Contraste Calculado | Requisito WCAG AA | Resultado |
| -------------- | ----------------- | ------------------------ | ------------------- | ----------------- | --------- |
| **Botón Primario (`colorPrimary` / `colorOnPrimary`)** | `#1D4ED8` (Blue 700) | `#FFFFFF` (White) | **6.53 : 1** | ≥ 4.5:1 (Texto normal) | **CUMPLE (AA / AAA)** |
| **Superficie / Texto Principal (`colorSurface` / `colorTextPrimary`)** | `#F8FAFC` (Slate 50) | `#0F172A` (Slate 900) | **16.03 : 1** | ≥ 4.5:1 (Texto normal) | **CUMPLE (AAA)** |
| **Superficie / Texto Secundario (`colorSurface` / `colorTextSecondary`)** | `#F8FAFC` (Slate 50) | `#475569` (Slate 600) | **7.01 : 1** | ≥ 4.5:1 (Texto normal) | **CUMPLE (AAA)** |
| **Estado Éxito (`colorSuccessContainer` / `colorOnSuccess`)** | `#F0FDF4` (Green 50) | `#14532D` (Green 900) | **8.39 : 1** | ≥ 4.5:1 (Texto normal) | **CUMPLE (AAA)** |
| **Estado Error (`colorErrorContainer` / `colorOnError`)** | `#FEF2F2` (Red 50) | `#7F1D1D` (Red 900) | **8.81 : 1** | ≥ 4.5:1 (Texto normal) | **CUMPLE (AAA)** |
| **Estado Advertencia (`colorWarningContainer` / `colorOnWarning`)** | `#FFFBEB` (Amber 50) | `#78350F` (Amber 900) | **8.38 : 1** | ≥ 4.5:1 (Texto normal) | **CUMPLE (AAA)** |

---

## 2. Área Táctil Mínima (Touch Target)

- **Requisito Material / WCAG**: Mínimo `48 x 48` píxeles lógicos para controles interactivos.
- **Implementación**:
  - `SafeAccessButton` encierra su contenido dentro de un `ConstrainedBox` con `minHeight: 48` y `minWidth: 48`.
  - Los íconos interactivos y listas cuentan con paddings accesibles para garantizar la facilidad de toque en pantallas móviles y táctiles.

---

## 3. Etiquetas Semánticas (Semantics)

- **Requisito**: Permitir que los lectores de pantalla (TalkBack, VoiceOver, NVDA) interpreten correctamente los controles visuales.
- **Implementación**:
  - `SafeAccessButton` incluye un widget `Semantics` con `button: true`, `enabled`, y `label` explícito o heredado del texto principal.
  - `SafeAccessStatusCard` utiliza `Semantics` para anunciar el tipo de mensaje ("Éxito", "Error", "Información") antes del cuerpo del mensaje.
  - `SafeAccessAsyncState` anuncia el estado de carga o error mediante `Semantics(liveRegion: true)`.

---

## 4. No Dependencia Exclusiva del Color (WCAG 1.4.1)

- **Regla**: La información no debe transmitirse únicamente a través del color.
- **Implementación**:
  - **Estado Éxito**: Combina color verde semántico (`#F0FDF4` / `#14532D`), ícono de verificación (`Icons.check_circle_outline`) y texto explicativo.
  - **Estado Error**: Combina color rojo semántico (`#FEF2F2` / `#7F1D1D`), ícono de alerta (`Icons.error_outline`) y mensaje de error con botón de reintento.
  - **Estado Advertencia**: Combina color ámbar semántico (`#FFFBEB` / `#78350F`), ícono de advertencia (`Icons.warning_amber_rounded`) y texto descriptivo.
  - **Estado Carga**: Muestra animación de `CircularProgressIndicator` junto con el texto "Cargando datos...".
