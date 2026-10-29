# 📋 Registro de Cambios — ProjectJaina_DragonflightUI

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [1.3.1] — 2026-10-28
### Corrección de Carrera en Icono de Descanso de Marco de Unidad (`RestIcon`)
- **Marcos de Unidad (`Modules/Unitframe.lua`):** Resuelto error de desreferenciación `nil` en `frame.RestIcon` durante la ejecución del hook `PLAYER_ENTERING_WORLD` para clases y niveles sin barra de descanso activa.
- **Blindaje Defensivo:** Inyectada guarda de verificación `if frame.RestIcon then` con captura de excepción `pcall`, asegurando la renderización fluida del marco del jugador sin excepciones de Lua ni cuelgues de interfaz.
- **Validación de Tests:** Suite de pruebas unitarias `test_sanity.py` ejecutada con 100% de tests aprobados.

---

## [1.3.0] — 2026-10-26
### Auditoría y Estabilización L9 — Resolución Integral de Bugs de Runtime e Integración Canónica
- **Inicialización y Gobernanza del Addon (`Core.lua`, `Config.lua`):**
  - Eliminada evaluación prematura de `UnitName('player')` en el root del script que congelaba el sistema de depuración `DF:Debug` en `false`.
  - Implementada conmutación dinámica en caliente de depuración vía comando `/df debug` con feedback interactivo en chat.
  - Blindadas funciones `DF:GetModuleEnabled` y `DF:SetModuleEnabled` contra llamadas anticipadas o perfiles corruptos (`nil-check` estricto en tabla de módulos).
  - Eliminada concatenación nula fatal en `ShowStartMessage()` y modernizado el banner de bienvenida a la identidad institucional de Project JAIna v5.43.0.
- **Marcos de Unidad y Protección contra Taint (`Modules/Unitframe.lua`):**
  - Blindaje integral contra excepciones `ADDON_ACTION_BLOCKED` durante combate en `Module:ApplySettings()`. Toda modificación de escala, anclaje o posicionamiento de marcos protegidos (`PlayerFrame`, `TargetFrame`, `FocusFrame`) se aplaza de forma segura a `PLAYER_REGEN_ENABLED` si `InCombatLockdown()` está activo.
  - Restringido `vehicleHardFix` exclusivamente a monturas y vehículos reales con interfaz activa (`UnitHasVehicleUI("player")`), erradicando taints al recibir efectos de control de masas (miedos, aturdimientos, polimorfias).
- **Minimapa y Desfase de Coordenadas (`map.lua`):**
  - Blindaje aritmético ante valores `nil` en cálculo de escala de blips y zoom de minimapa (`(points[4] or 0) / blipScale`).
  - Restaurado el skin oficial Dragonflight y anclaje del botón de rastreo en `Tracking_Update`.
  - Protección de cabecera de seguimiento de misiones (`WatchFrameHeader`) frente a desincronización por variables nulas.
- **MicroMenú y Gestor Central de Eventos (`Modules/micromenu.lua`, `utils/events.lua`):**
  - Erradicada desregistración destructiva de `PLAYER_ENTERING_WORLD` sobre el frame central `addon.package.events` que apagaba eventos para todo el AddOn.
  - Normalizada detección de iconos de bolsas vacías a formato insensible a mayúsculas/minúsculas.
  - Restaurada funcionalidad de teletransporte a mazmorra LFG (`LFGTeleport(IsInLFGDungeon())`) en click izquierdo del icono del minimapa.
  - Corregido `utils/events.lua` reemplazando `return` prematuro por `break` para garantizar el registro íntegro de múltiples callbacks.
- **Ventana y Ajustes de Chat (`Modules/Chat.lua`):**
  - Corregida indexación en setters y getters de sliders AceConfig-3.0 utilizando `info[#info]` en lugar de la raíz `info[1]`, restaurando la persistencia de dimensiones y márgenes.
  - Eliminado el pisado forzado e intrusivo de CVars de burbujas de chat (`chatBubbles`, `chatBubblesParty`) en cada pantalla de carga.
  - Integrada llamada a `FCF_SavePositionAndDimensions` para sincronizar dimensiones modificadas con el gestor nativo de Blizzard.
- **Interfaz de Vehículos (`Modules/vehicle.lua`):**
  - Resuelto fallo de inicialización en `vehiclebutton_position` que evaluaba falso durante `PLAYER_ENTERING_WORLD`.
  - Agregada invocación explícita de `vehiclebutton_position()` al dispararse `UNIT_ENTERED_VEHICLE` con filtro estricto sobre la unidad `'player'`.
- **Barra de Lanzamiento de Hechizos (`Modules/Castbar.lua`):**
  - Erradicado el micro-stutter y la sobrecarga masiva del recolector de basura (GC thrashing) al condicionar el redibujado de la barra exclusivamente a la unidad jugadora (`arg1 == 'player'`).
  - Corregida visualización de nombres de hechizo en `UnitCastingInfo` cuando `text` es nulo.
  - Reemplazada la textura estirada de minimapa en el fondo por un backdrop oscuro calibrado.
- **Barra de Posturas y Formas (`Modules/stance.lua`):**
  - Eliminado el retorno anticipado que bloqueaba el posicionamiento y estilizado si el personaje ingresaba al mundo sin posturas aprendidas.
  - Reemplazado `RegisterStateDriver` estático por la directiva dinámica canónica `[bonusbar:5][vehicleui] hide; show`, ocultando limpiamente las posturas al abordar vehículos.
  - Corregido offset asimétrico (+90px -> +40px) y registrados ganchos para eventos de regeneración.
- **Animaciones y Botones de Acción (`Modules/buttons.lua`):**
  - Corregida colisión de niveles de capa (Z-fighting) en la espiral de cooldown; ahora se indexa sobre el nivel propio del botón para no ocultarse tras el icono.
  - Añadidas comprobaciones defensivas contra botones huérfanos sin contenedor padre y guardas en `is_petaction` y `setup_background`.
- **Barra de Mascota (`Modules/petbar.lua`):**
  - Restaurados los controladores de ciclo de vida en `PLAYER_ENTERING_WORLD` y `PLAYER_REGEN_ENABLED`.
  - Normalizado el espaciado de barras derechas a +40px para consistencia métrica con el resto de la interfaz.

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
