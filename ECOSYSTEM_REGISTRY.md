# 🌐 Registro de Ecosistema — Wanos_DragonflightUI

Ficha técnica oficial de registro en la infraestructura multi-addon de **Project Jaina - Project Jaina**.

---

## 1. Identidad del Addon en el Ecosistema

| Campo | Valor |
|---|---|
| **Nombre Técnico** | `Wanos_DragonflightUI` |
| **Carpeta Local** | `cDF` |
| **Versión Actual** | `1.0.0` |
| **Clasificación** | Cliente / Overhaul UI |
| **Licencia Formal** | MIT / BSD |
| **Repositorio GitHub** | [Wanos_DragonflightUI](https://github.com/DarckRovert/Wanos_DragonflightUI) |
| **Entorno de Juego** | World of Warcraft 3.3.5a (Build 12340) / AzerothCore |

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
| **`Wanos_AbbreviatedStatus`** | Integración Visual | Formatea textos de vida/maná superpuestos en los marcos de unidad de cDF. |
| **`Jaina_BattlePass`** | Botón de Minimapa | El botón del Pase de Batalla se ancla al perímetro del minimapa de cDF. |
| **`WowPeruVisualShop`** | Botón de Minimapa | El botón de la tienda se ancla al minimapa sin solaparse con botones de rastreo. |
| **`Wanos_Companion`** | Telemetría / Detección | Compatible con el motor de escaneo de presencia social. |

---

## 5. Garantías de Rendimiento

- **Tiempo de Cuadro:** Renderizado acelerado por hardware para texturas atlas BLP.
- **Memoria en Tiempo de Ejecución:** ~ 2.8 MB de memoria Lua.
- **Compatibilidad de Hardware:** 100% verificado para PCs de cabina con procesadores de gama baja.

---

## 🏛️ Directorio Maestro del Ecosistema Project Jaina (18 Repositorios)

### A. Módulos Oficiales del Cliente (`Client\Interface\AddOns\`)

| # | Repositorio GitHub | Carpeta Local | Versión | Tipo / Licencia | Propósito en el Ecosistema |
|:---:|---|---|:---:|:---:|---|
| 01 | [Wanos_AbbreviatedStatus](https://github.com/DarckRovert/Wanos_AbbreviatedStatus) | `AbbreviatedStatus` | 1.2.1 | MIT / Fork | Abreviación compacta y formateo legible de salud y maná sin división por cero. |
| 02 | [Jaina_BattlePass](https://github.com/DarckRovert/Jaina_BattlePass) | `Jaina_BattlePass` | 2.0.0 | MIT | Pase de Batalla estacional de 50 niveles con backend Eluna y bitmask de progreso. |
| 03 | [Wanos_Carbonite](https://github.com/DarckRovert/Wanos_Carbonite) | `Wanos_Carbonite` | 3.3.4-WP | Other / EULA | Suite satelital HD de cartografía, navegación multi-zona y misiones. |
| 04 | [Wanos_Companion](https://github.com/DarckRovert/Wanos_Companion) | `Wanos_Companion` | 1.0.3 | MIT | Hub social ligero, cross-faction (/comerciar, /invitar) y telemetría de grupo. |
| 05 | [Wanos_DragonflightUI](https://github.com/DarckRovert/Wanos_DragonflightUI) | `cDF` | 1.0.0 | MIT / BSD | Re-implementación visual moderna estilo Dragonflight 10.x para cliente 3.3.5a. |
| 06 | [Wanos_GameModes](https://github.com/DarckRovert/Wanos_GameModes) | `Wanos_GameModes` | 1.0.0 | MIT | Selector cinemático de modos (Normal, Hardcore, Ironman) con verificación Eluna. |
| 07 | [Wanos_GMGenie](https://github.com/DarckRovert/Wanos_GMGenie) | `GMGenie` | 1.3.1 | GPL-3.0 | Suite administrativa integral para Game Masters adaptada a AzerothCore. |
| 08 | [Wanos_IntiObjGPS](https://github.com/DarckRovert/Wanos_IntiObjGPS) | `IntiObjGPS` | 1.0.0 | MIT | Editor por lotes de coordenadas GPS de GameObjects para Staff y constructores. |
| 09 | [Wanos_LoreHUD](https://github.com/DarckRovert/Wanos_LoreHUD) | `LoreHUD` | 1.0.0 | MIT | Diálogos cinemáticos inmersivos y subtítulos estilizados para misiones y Lore. |
| 10 | [Wanos_PrideTrace](https://github.com/DarckRovert/Wanos_PrideTrace) | `WowPeruPrideTrace` | 1.0.0 | MIT | Rastreador de combate y telemetría de eventos de orgullo en tiempo real. |
| 11 | [Wanos_RaidSuite](https://github.com/DarckRovert/Wanos_RaidSuite) | `Wanos_RaidSuite` | 1.0.0 | MIT | Suite modular de herramientas analíticas para líderes de banda y oficiales. |
| 12 | [Wanos_Talented](https://github.com/DarckRovert/Wanos_Talented) | `Talented` | 3.3.5-WP | GPL-2.0 | Árbol de talentos avanzado con soporte para plantillas y compartición. |
| 13 | [Wanos_TBCBalance](https://github.com/DarckRovert/Wanos_TBCBalance) | `IntiTBCBalance` | 1.0.0 | MIT | Monitor privado de balance y composición de bandas TBC para Game Masters. |
| 14 | [Wanos_Wardrobe](https://github.com/DarckRovert/Wanos_Wardrobe) | `Wanos_Wardrobe` | 1.0.0 | MIT | Guardarropa, catálogo cosmético y transfiguración con backend Eluna (60_WardrobeSystem.lua). |
| 15 | [WowPeruVisualShop](https://github.com/DarckRovert/WowPeruVisualShop) | `WowPeruVisualShop` | 1.0.1 | MIT | Tienda oficial de efectos visuales, auras y alas con backend Eluna (59_SpellVisualCatalog.lua). |
| 16 | [Wanos_Voice](https://github.com/DarckRovert/Wanos_Voice) | `Wanos_Voice` | 1.0.0 | MIT | Voz espacial 3D por proximidad y vinculación WebRTC con backend Eluna (65_VoiceProximitySync.lua). |

### B. Suites Comunitarias Monorepositorio Pre-instaladas (`WoW_Peru_Lab\AddOns\`)

| # | Repositorio GitHub | Carpeta Local | Versión | Tipo / Licencia | Propósito en el Ecosistema |
|:---:|---|---|:---:|:---:|---|
| 17 | [Wanos_DBM](https://github.com/DarckRovert/Wanos_DBM) | `Wanos_DBM` | 4.52-WP | CC BY-NC-SA 3.0 | Suite unificada de 13 módulos Deadly Boss Mods para todas las raids y mazmorras WotLK. |
| 18 | [Wanos_GearScore](https://github.com/DarckRovert/Wanos_GearScore) | `Wanos_GearScore` | 3.1.16-WP | MIT / Comm. | Monorepositorio unificado de GearScore (3.1.16) y BonusScanner (5.3) sin dependencias rotas. |

---

## 📜 Principios de Gobernanza y Convivencia Arquitectónica

1. **Inmunidad a Taint:** Prohibido modificar o enganchar `UnitPopupMenus` de Blizzard para garantizar la estabilidad de menús contextuales y addons de curación (`HealBot`, `Grid`).
2. **Empirismo y Cero Suposiciones:** Todo cambio de protocolo o base de datos debe ser validado con inspección en disco y pruebas de red activas.
3. **Codificación Canónica:** Todo archivo de texto debe persistirse en **UTF-8 sin BOM** con saltos de línea estrictos **LF**.
4. **Preservación de Binarios:** Todos los assets multimedia (`.tga`, `.blp`, `.mp3`, `.ogg`, `.wav`, `.ttf`, `.m2`) se encuentran blindados mediante `.gitattributes` para evitar corrupción en transferencias Git.
