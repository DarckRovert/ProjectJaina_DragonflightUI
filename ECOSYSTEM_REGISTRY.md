# 🌐 Registro de Ecosistema — WoWPeru_DragonflightUI (cDF)

Ficha técnica oficial de registro en la infraestructura multi-addon de **WoW Perú - Reino Andino**.

---

## 1. Identidad del Addon

| Campo | Valor |
|---|---|
| **Nombre Técnico** | `WoWPeru_DragonflightUI` |
| **Título en Cliente** | `Chromie - [WoW -Perú]` |
| **Versión** | `GIT` |
| **Tipo de Sistema** | Overhaul Completo de Interfaz Gráfica (Client-Side Only) |
| **Repositorio GitHub** | [DarckRovert/WoWPeru_DragonflightUI](https://github.com/DarckRovert/WoWPeru_DragonflightUI) |
| **Directorio de Instalación** | `Interface\AddOns\cDF\` |

---

## 2. Red y Mensajería de Addon

| Propiedad | Valor |
|---|---|
| **Prefijo Oficial** | Ninguno (Operación visual 100% en cliente) |
| **Canales de Red** | N/A |
| **OpCodes Manejados** | N/A |

---

## 3. Persistencia de Datos

| Variable Global | Tipo | Ámbito | Propósito |
|---|---|---|---|
| `DragonflightUIDB` | Tabla Lua (`SavedVariables`) | Por Cuenta | Preferencias globales de layout, dimensiones de barras y colores de marcos. |
| `SOCD` | Tabla Lua (`SavedVariablesPerCharacter`) | Por Personaje | Estado de configuración particular por personaje. |

---

## 4. Matriz de Integración del Ecosistema

| Sistema Coexistente | Modo de Interacción | Flujo de Datos |
|---|---|---|
| **`WoWPeru_AbbreviatedStatus`** | Integración Visual | Formatea textos de vida/maná superpuestos en los marcos de unidad de cDF. |
| **`WoWPeru_BattlePass`** | Botón de Minimapa | El botón del Pase de Batalla se ancla al perímetro del minimapa de cDF. |
| **`WowPeruVisualShop`** | Botón de Minimapa | El botón de la tienda se ancla al minimapa sin solaparse con botones de rastreo. |
| **`WoWPeru_Companion`** | Telemetría / Detección | Compatible con el motor de escaneo de presencia social. |

---

## 5. Garantías de Rendimiento

- **Tiempo de Cuadro:** Renderizado acelerado por hardware para texturas atlas BLP.
- **Memoria en Tiempo de Ejecución:** ~ 2.8 MB de memoria Lua.
- **Compatibilidad de Hardware:** 100% verificado para PCs de cabina con procesadores de gama baja.
