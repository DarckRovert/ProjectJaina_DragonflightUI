# 🛡️ Política de Seguridad y Mitigación de Vulnerabilidades — ProjectJaina_DragonflightUI

**Proyecto:** Ecosistema Project Jaina  
**Repositorio:** [https://github.com/DarckRovert/ProjectJaina_DragonflightUI](https://github.com/DarckRovert/ProjectJaina_DragonflightUI)

---

## 🔒 Modelo de Seguridad en 3.3.5a

Este addon sigue estrictos principios de diseño seguro para el cliente de World of Warcraft:

1. **Saneamiento Estricto de Entradas:**
   Todos los mensajes y parámetros recibidos a través de canales de chat (`CHAT_MSG_ADDON`, canales de hermandad, susurros) son validados antes de procesarse. Se desinfectan caracteres de control y secuencias de escape que pudieran corromper la interfaz visual.

2. **Control de Autorización:**
   Cualquier comando que afecte a la banda o al grupo (marcas, anuncios, votaciones, sincronizaciones) verifica que el emisor cuente con permisos de líder o asistente (`IsRaidLeader()` o rango de oficial en `GetRaidRosterInfo()`).

3. **Inmunidad contra Taint de FrameXML:**
   El código no sobreescribe ni contamina funciones seguras de Blizzard (`UnitPopupMenus`, botones de acción protegidos). Esto previene el error crítico `"Action blocked by an AddOn"` durante el combate.

4. **Protección contra DoS y Throttling:**
   Se implementan mecanismos de límite de tasa (*throttling*) y deduplicación con cerrojos temporales para evitar tormentas de paquetes o bucles infinitos en eventos CLEU o sincronizaciones P2P.

---

## 🚨 Reporte de Vulnerabilidades

Si descubres una vulnerabilidad o un exploit que afecte la estabilidad del cliente o del servidor, por favor repórtalo directamente al Staff de Project Jaina a través de los canales oficiales:
- **Discord:** Staff Project Jaina (Ticket Privado)
- **GitHub Issues:** [https://github.com/DarckRovert/ProjectJaina_DragonflightUI/issues](https://github.com/DarckRovert/ProjectJaina_DragonflightUI/issues)
