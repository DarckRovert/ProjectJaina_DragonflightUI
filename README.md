# 🇵🇪 WoW Perú — DragonflightUI (cDF)

[![GitHub](https://img.shields.io/badge/GitHub-DarckRovert%2FWoWPeru_DragonflightUI-black?logo=github)](https://github.com/DarckRovert/WoWPeru_DragonflightUI)

> **WoW Perú Ecosystem** · WotLK 3.3.5a compatible · `Interface: 30300`

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Reimplementación modular de la interfaz **Dragonflight 10.x** adaptada para World of Warcraft 3.3.5a. Moderniza la experiencia visual del cliente clásico (barras de acción, minimapa, marcos de unidad, bolsas) manteniendo total compatibilidad con el API de WotLK.

---

## Características

- **UI estilo Dragonflight** — Barras de acción, minimapa y marcos de unidad rediseñados.
- **Action Bars modernizadas** — Layout y animaciones inspirados en el cliente 10.x (`pretty_actionbar` por s0h2x).
- **Minimapa integrado** — Rediseño del minimapa con atlas BLP de alta definición (`pretty_minimap` por s0h2x).
- **Bag Sort** — Sistema de organización automática de bolsas (`SushiSort`).
- **Tipografía Expressway** — Tipografía de alta legibilidad creada por Typodermic Fonts.
- **Sin dependencias críticas** — Librería Ace3 embebida en `Libs/`.
- Compatible con WotLK 3.3.5a (Interface 30300).

## Instalación

1. Copia la carpeta `cDF` a `Interface/AddOns/`.
2. Activa el addon desde la pantalla de selección de personajes.
3. Inicia sesión en el juego.

## Variables Guardadas

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `DragonflightUIDB` | Global | Configuración de layout y colores |
| `SOCD` | Por personaje | Estado de la UI por personaje |

## 📄 Licencia y Estatus Legal

- **Autor de adaptación y mantenimiento:** WoW Perú Team / WoWpe
- **Módulos Upstream:** `s0h2x` (Actionbars y Minimapa), Typodermic Fonts (Expressway).
- **Estatus Legal:** DragonflightUI (cDF) integra componentes de terceros, fuentes y librerías BSD/Public Domain. Consulta el archivo [NOTICE.md](NOTICE.md) para el desglose legal completo de licencias y créditos.

---

## Documentación del Ecosistema

* [Ficha Técnica Oficial del Ecosistema](ECOSYSTEM_REGISTRY.md)
* [Historial de Cambios](CHANGELOG.md)
* [Aviso Legal y Upstream](NOTICE.md)
* [Licencia MIT Canónica](LICENSE)

---

*Parte del [ecosistema WoW Perú](https://github.com/DarckRovert)*
