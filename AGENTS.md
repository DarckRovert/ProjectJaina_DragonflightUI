# 🤖 Directrices de Ingeniería y Restricciones para Agentes IA — Wanos_DragonflightUI

**Addon:** `Wanos_DragonflightUI`  
**Repositorio Oficial:** [https://github.com/DarckRovert/Wanos_DragonflightUI](https://github.com/DarckRovert/Wanos_DragonflightUI)  
**Motor Gráfico y Runtime:** WoW 3.3.5a WotLK (Build 12340) / Lua 5.1 (Blizzard VM)

---

## ⚠️ Reglas Inquebrantables del Motor 3.3.5a

Al inspeccionar, mantener o refactorizar este addon, cualquier ingeniero o agente de IA debe cumplir obligatoriamente las siguientes restricciones:

### 1. APIs Prohibidas de Retail (Inexistentes en 3.3.5a)
- ❌ **`SetColorTexture(r, g, b, a)`:** NO existe en 3.3.5a.
  - ✅ **Solución:** Usar `texture:SetTexture("Interface\\Buttons\\WHITE8X8")` seguido de `texture:SetVertexColor(r, g, b, a)`.
- ❌ **`C_Timer.After(sec, func)`:** NO existe en el cliente 3.3.5a nativo.
  - ✅ **Solución:** Utilizar un Frame invisible con script `OnUpdate` acumulativo y auto-cancelación.
- ❌ **`IsInRaid()` / `IsInGroup()`:** NO existen en 3.3.5a.
  - ✅ **Solución:** Usar `GetNumRaidMembers() > 0` y `GetNumPartyMembers() > 0`.
- ❌ **`GROUP_ROSTER_UPDATE`:** NO existe en WotLK.
  - ✅ **Solución:** Registrar `RAID_ROSTER_UPDATE` y `PARTY_MEMBERS_CHANGED`.

### 2. Normas de Rendimiento y Memoria
- **Cero Generación de Basura en `OnUpdate`:** Nunca instanciar tablas temporales (`local t = {}`) dentro de ciclos de actualización de fotograma. Reutilizar tablas estáticas para evitar presionar al Garbage Collector de Lua.
- **Límite de Red:** Todo payload emitido mediante `SendAddonMessage` no debe exceder los **255 bytes** en bruto.

### 3. Integridad y Manejo de Errores
- **Prohibido el Secuestro Global de Errores:** Nunca invocar `seterrorhandler()` globalmente.
- **Protección Defensiva:** Usar `pcall` en la deserialización de datos provenientes de canales de chat o red.
