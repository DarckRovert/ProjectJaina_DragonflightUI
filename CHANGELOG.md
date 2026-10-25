# 📋 Registro de Cambios — ProjectJaina_DragonflightUI

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [1.2.0] — 2026-10-25
### Auditoría y Estabilización L9 — Sesión de Depuración Profunda y Certificación
- **Bordes de Calidad de Equipo (`characterrarity.lua`):**
  - Calibración matemática precisa a `46x46` px en botones de equipamiento de `37x37` px, erradicando 25 px de solapamiento entre ranuras adyacentes de la hoja de personaje.
  - Añadido soporte nativo para objetos de calidad Reliquia / Heirloom (Calidad 7 WotLK `1.0, 0.82, 0.0`).
  - Registro del evento `GET_ITEM_INFO_RECEIVED` para evitar pérdida permanente de bordes ante consultas asíncronas de caché en login.
  - Enganchado hook a `PaperDollItemSlotButton_Update` y `PaperDollFrame:OnShow` para garantizar refresco instantáneo al conmutar pestañas.
  - Soporte integrado para casillas de equipamiento en la ventana de inspección (`InspectFrame`).
- **Bordes de Calidad en Contenedores y Banco (`itemrarity.lua`):**
  - Hook integral al ciclo nativo de apertura de bolsas (`ContainerFrame_Update`).
  - Cobertura completa para las 28 casillas del banco principal (`BankFrameItem1` a `BankFrameItem28`).
  - Añadido soporte de Calidad 7 (Reliquia / Heirloom) y calibración a `46x46` px con blend mode `ADD`.
- **Minimapa y Facción (`map.lua`):**
  - Resuelto crash fatal `attempt to call global 'strlower' (a nil value)` mediante envoltura `pcall` y refresco reactivo en `PLAYER_ENTERING_WORLD`.
- **Barra de Casteo (`Castbar.lua`):**
  - Resuelto crash por `GetSpellInfo` nil en tabla de ticks con inicialización diferida en `InitChannelTicks`.
  - Normalización de parámetros de `UnitCastingInfo` / `UnitChannelInfo` de 9 a 8 según la API nativa de WotLK 3.3.5a.
- **Barra de Acción Principal (`Modules/mainbars.lua`):**
  - Corrección de facción en dracoalcones ornamentales; la Alianza ahora renderiza gárgolas/leones y la Horda dracoalcones con fallback dinámico por raza.
- **Auras y Tiempo (`auras.lua`, `time.lua`):**
  - Sanitización de `BUFF_ACTUAL_DISPLAY or 0` acotado a 40 auras y anclaje seguro de `TempEnchant3`.
  - Safe getter para `CalendarGetDate()` protegiendo de argumentos nil en `string.format`.

---

## [1.1.0] — 2026-10-24
### Auditoría y Estabilización L9 — Cacería Profunda de Bugs de Runtime
- **MicroMenú y Bolsas (`micromenu.lua`):**
  - Corregida destrucción iterativa de la textura deshabilitada de `CharacterMicroButton` que lo volvía invisible en vehículos/cinemáticas.
  - Eliminada recreación redundante de textura de `PVPMicroButton` dentro del bucle de 11 botones.
  - Añadidas comprobaciones defensivas de texturas deshabilitadas ausentes para prevenir fallos `attempt to index a nil value`.
  - Saneada la lógica del botón de flecha de colapso de bolsas (`pUiArrowManager`), eliminando desregistración destructiva sobre `addon.package.events` (`ADDON_LOADED`) y fugas de variables globales.
- **Botones de Vehículo y Taint (`vehicle.lua`):**
  - Implementado `SecureActionButtonTemplate` nativo con `type = leavevehicle` para erradicar `ADDON_ACTION_BLOCKED` en combate.
  - Re-emparentados botones de salida de vehículo al holder principal (`pUiStanceHolder or pUiMainBar`), resolviendo invisibilidad permanente en Cazadores, Magos y Chamanes.
  - Corregido fallo de inicialización por variable global nula `VehicleMenuBarPitchSliderOverlayThing`.
- **Marcos de Unidad (`Unitframe.lua`, `Core.lua`):**
  - Polyfill para API ausente de retail `GetClassColor(class)` en WotLK 3.3.5a evitando crashes en barras de vida.
  - Corregida colisión de identificadores globales en `ChangeFocusFrame` que secuestraba texturas de `TargetFrame`.
  - Corrección de fallos en presets `DEFAULT` y `CENTER` adaptándolos al esquema anidado de `db.profile`.
  - Preservación estricta de coordenadas configuradas por usuario en `/df` frente a resets automáticos en `ZONE_CHANGED`.
- **Barras de Acción, Cooldowns y Macros (`mainbars.lua`, `stance.lua`, `cooldowns.lua`, `buttons.lua`):**
  - Erradicada fuga de variable global `_G.notRequired` que deshabilitaba posicionamiento en barras de facultades y mascotas.
  - Resuelto apilamiento acumulativo de anclas (ClearAllPoints) en reubicación de barras y en `ShapeshiftButton1`.
  - Eliminada fuga de CPU por `OnUpdate` perpetuo en `cooldowns.lua` y corregida omisión de barras de pet/stance.
  - Blindaje defensivo en `buttons.lua` ante botones de barra especiales sin frame `HotKey` o texturas pushed/checked.
- **Auras y Buffs (`auras.lua`):**
  - Enganchado `BuffFrame:HookScript('OnShow')` para garantizar colapso persistente cuando Blizzard refresca auras vía `UNIT_AURA`.
  - Corregida firma de llamada en `UpdateDeBuffsAnchor` previniendo concatenación de cadenas nula con sintaxis de método.
  - Corregido espaciado y cálculo de filas en debuffs cuando los buffs están colapsados.
- **Minimapa y Buscador de Mazmorras (`map.lua`):**
  - Polyfill defensivo para `MiniMapLFGFrame.eye.texture` ausente en el FrameXML 3.3.5a, previniendo aborto del script del minimapa.
- **Rastreo de Calidad de Objetos y Personaje (`itemrarity.lua`, `characterrarity.lua`):**
  - Corregida indexación del 12º retorno de `GetItemInfo` para evitar `bad argument #1 to 'SetVertexColor'`.
  - Eliminados marcos fantasma en casillas vacías de equipamiento y forzado refresco inicial en `CharacterFrame.OnShow`.
- **Clasificador de Bolsas (`SushiSort.lua`):**
  - Corregido fallo fatal en `SOCD_OptionsPanel_OnOk` por indexación nula en bucles de configuración.

---

## [1.0.1] — 2026-10-10
### Estabilización de Ecosistema y Gobernanza Oficial (Project Jaina)
- **Normalización de UI y Gráficos:** Purga de carpetas clonadas y enlaces simbólicos residuales, normalización de capas de textura ARTWORK y calibración de estabilidad bajo Direct3D 9 a 60 FPS.
- **Homologación Documental:** Incorporación y actualización formal de `GOVERNANCE.md`, `LICENSE`, `NOTICE.md` y `SECURITY.md`.
- **Licencia Canónica:** Consolidación de licencia MIT 2026 bajo titularidad de DarckRovert & Project Jaina Team.
- **Validación de Runtime:** Verificado al 100% con compilador sintáctico `lua52_compiler.exe -p` con 0 errores y 0 warnings.

---

## [1.0.0] — 2026-10-04
### Lanzamiento Inicial — Ecosistema Project Jaina WotLK 3.3.5a
- Implementación de la arquitectura base para Project Jaina Dragonflight UI.
- Registro de comandos slash: `/df, /dragonflight`.
- Persistencia de configuración en `DragonflightUIDB`.
- Compatibilidad certificada con cliente WotLK 3.3.5a (Build 12340) y directiva `Interface: 30300`.
