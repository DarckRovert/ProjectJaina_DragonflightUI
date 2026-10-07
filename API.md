# 🔌 Especificación Técnica y API — WoWPeru_DragonflightUI

[![GitHub](https://img.shields.io/badge/GitHub-DarckRovert%2FWoWPeru_DragonflightUI-black?logo=github)](https://github.com/DarckRovert/WoWPeru_DragonflightUI)
[![Ecosistema](https://img.shields.io/badge/Ecosistema-WoW%20Per%C3%BA%203.3.5a-gold.svg)](https://wow-peru.lat/)

## 📌 Resumen Arquitectónico
Rediseño visual compacto y moderno de la interfaz de usuario en WoW 3.3.5a inspirado en la interfaz Dragonflight 10.x, optimizado para alto rendimiento y legibilidad.

- **Rol en el Ecosistema:** Módulo Oficial #5 — Interfaz Gráfica Dragonflight
- **Archivo Principal TOC:** `cDF.toc`
- **Compatibilidad del Motor:** World of Warcraft 3.3.5a (Build 12340)

---

## ⌨️ Comandos de Consola (Slash Commands)
- `/SS`: Acceso principal o comando del addon.

---

## 📡 Protocolo de Red y Eventos
- *(Este addon no utiliza mensajes AddonMessage de red; opera en espacio local del cliente)*.

### Eventos del Motor 3.3.5a Gestionados
- `PLAYER_LOGIN` / `ADDON_LOADED`: Inicialización atómica de tablas de configuración y hooks.
- `PLAYER_ENTERING_WORLD`: Sincronización de estado tras transiciones de pantalla o mapa.
- `PLAYER_LOGOUT`: Guardado seguro en disco de las variables locales.

---

## 💾 Persistencia de Datos (SavedVariables)
- `DragonflightUIDB`: Almacenamiento estructurado de configuración y estado persistente.
- `SOCD`: Almacenamiento estructurado de configuración y estado persistente.

---

## 🛠️ Buenas Prácticas de Integración
1. Toda invocación a funciones públicas debe verificar previamente la existencia del espacio de nombres en `_G`.
2. Las tablas de configuración deben consultarse en modo lectura sin sobreescribir valores por omisión no validados.
3. El intercambio de datos con otros addons debe efectuarse a través del bus oficial `WoWPeru_Companion` o hooks de eventos estándar.
