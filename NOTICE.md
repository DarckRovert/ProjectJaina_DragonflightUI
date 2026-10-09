# Aviso Legal y Créditos de Código de Terceros — ProjectJaina_DragonflightUI (cDF)

Este repositorio forma parte del ecosistema oficial de **Project Jaina - Project Jaina**.
Contiene adaptaciones, compilación modular y personalización de la interfaz estilo **Dragonflight** para el cliente World of Warcraft 3.3.5a (Build 12340).

---

## 1. Atribución de Componentes y Módulos Base Upstream

La suite `cDF` integra y refactoriza múltiples módulos comunitarios de modernización de UI para WotLK 3.3.5a:

* **Barras de Acción Modernas (`pretty_actionbar`):** Diseñado originalmente por **s0h2x** (`s0h2x/pretty_actionbar`).
* **Minimapa Integrado (`pretty_minimap`):** Arquitectura y capas de atlas por **s0h2x** (`s0h2x/pretty_minimap`).
* **Organizador de Bolsas (`SushiSort`):** Utilidad comunitaria de ordenamiento de inventario para 3.3.5a.
* **Tipografía Embebida (`assets/expressway.ttf`):** Familia tipográfica *Expressway* creada por **Ray Larabie / Typodermic Fonts** (distribuida bajo licencia freeware/desktop de uso libre).
* **Adaptación y Correcciones Project Jaina:** DarckRovert (Elnazzareno) & Antigravity (Mythos 5) (refactorización de atributos XML incompatibles como `parentKey` en vehículos a asignaciones `OnLoad`).

---

## 2. Licencia de Librerías Embebidas (`Libs/`)

El subdirectorio `Libs/` aloja la suite Ace3 para WoW 3.3.5a:
* `AceAddon-3.0`, `AceEvent-3.0`, `AceDB-3.0`, `AceDBOptions-3.0`, `AceConsole-3.0`, `AceGUI-3.0`, `AceConfig-3.0`: Copyright (c) 2007, Ace3 Development Team (Licencia BSD 3-Clause).
* `LibStub` y `CallbackHandler-1.0`: Dominio Público.

---

## 3. Estado de Propiedad Intelectual

Las interfaces gráficas de usuario para World of Warcraft son obras derivadas reguladas por el Blizzard Custom UI Policy. Los autores de los módulos base retienen sus respectivos derechos de autor. Las modificaciones y consolidaciones efectuadas por Project Jaina se ofrecen sin fines de lucro para enriquecer la experiencia visual de los jugadores del Project Jaina.
