# Registro de Cambios — ProjectJaina_DragonflightUI (cDF)

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [GIT-wp] — 2026-10-05
### Correcciones de Compatibilidad y Documentación (Project Jaina)
- **Corrección de Frames de Vehículos:** Reemplazados los atributos no soportados `parentKey` en archivos XML de marcos de acción/vehículos por asignaciones programáticas seguras en `OnLoad`, eliminando errores de FrameXML en combate montado.
- **Higiene Documental:** Creación de `NOTICE.md`, `CHANGELOG.md`, `ECOSYSTEM_REGISTRY.md` y `.gitattributes`.
- **Transparencia Upstream:** Atribución explícita a los autores de los submódulos base (`s0h2x` para actionbars y minimapa, Typodermic Fonts para tipografía).

---

## [GIT] — Upstream / Base
### Características Iniciales
- Reemplazo completo de la interfaz estándar de WotLK 3.3.5a con estética Dragonflight 10.x.
- Módulos de castbar, chat, marcos de unidad, minimapa con atlas integrado y ordenamiento de bolsas con SushiSort.
- Variables guardadas en `DragonflightUIDB` y `SOCD`.
