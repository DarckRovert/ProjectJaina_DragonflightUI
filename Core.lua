local DF = LibStub('AceAddon-3.0'):NewAddon('cDF', 'AceConsole-3.0')
local db

-- DF.InterfaceVersion = select(4, GetBuildInfo())
-- DF.Wrath = DF.InterfaceVersion >= 30400
-- DF.Era = DF.InterfaceVersion <= 20000

local defaults = {
    profile = {
        modules = {['Unitframe'] = true, ['Castbar'] = true, ['Chat'] = true},
        bestnumber = 42
    }
}

function DF:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub('AceDB-3.0'):New('DragonflightUIDB', defaults, true)
    db = self.db.profile
    self:SetupOptions()
    self:RegisterSlashCommands()
end

function DF:OnEnable()
    -- Called when the addon is enabled
    --self:Print('DragonflightUI enabled!')
    self:ShowStartMessage()
end

function DF:OnDisable()
    -- Called when the addon is disabled
end

function DF:GetModuleEnabled(module)
    if not db or not db.modules then return false end
    return db.modules[module]
end

function DF:SetModuleEnabled(module, value)
    if not db then return end
    if not db.modules then db.modules = {} end
    local old = db.modules[module]
    db.modules[module] = value
    if old ~= value then
        if value then
            self:EnableModule(module)
        else
            self:DisableModule(module)
        end
        self:Print('/reload')
    end
end

DF.debugMode = false
function DF:Debug(m, value)
    if self.debugMode == nil or self.debugMode == false then
        local name = UnitName('player')
        if name and (name == 'Zimtdev' or name == 'Darck' or name == 'Jaina' or name == 'Elnazzareno') then
            self.debugMode = true
        end
    end
    if self.debugMode and m and m.Print then
        m:Print(value)
    end
end

function DF:ShowStartMessage()
    local playerName = UnitName("player") or "Heroe"
    local ver = (GetAddOnMetadata and (GetAddOnMetadata('ProjectJaina_DragonflightUI', 'Version') or GetAddOnMetadata('DragonflightUI', 'Version'))) or "v5.43.0"
    print(string.format("|cff00ccff[Project JAIna]|r |cffffd700Dragonflight UI|r |cff888888(%s)|r cargado. Bienvenido, |cffffffff%s|r. Escribe |cff00ff00/df|r para configurar.", ver, playerName))
end

-- Polyfill canónico 3.3.5a para GetClassColor
if not GetClassColor then
    GetClassColor = function(class)
        local color = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
        if color then
            local hex = string.format("ff%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255)
            return color.r, color.g, color.b, hex
        end
        return 1, 1, 1, "ffffffff"
    end
end

function DF:GetClassColor(class, alpha)
    local color = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
    if color then
        return color.r, color.g, color.b, alpha or 1
    end
    return 1, 1, 1, alpha or 1
end
