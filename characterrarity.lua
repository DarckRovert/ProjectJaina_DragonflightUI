-- Project Jaina - DragonflightUI: Character & Inspect Equipment Rarity Border Engine (3.3.5a WotLK)
-- Cobertura completa: Hoja de Personaje local (PaperDollFrame) y Ventana de Inspección (InspectFrame)

local function GetRarityColor(rarity)
    if not rarity then return nil end
    if rarity == 2 then     -- Uncommon (Verde)
        return 0.12, 0.75, 0.12, 1.0
    elseif rarity == 3 then -- Rare (Azul)
        return 0.0, 0.44, 0.87, 1.0
    elseif rarity == 4 then -- Epic (Púrpura)
        return 0.64, 0.21, 0.93, 1.0
    elseif rarity == 5 then -- Legendary (Naranja)
        return 1.0, 0.50, 0.0, 1.0
    elseif rarity == 6 then -- Artifact (Dorado / Rojo Antiguo)
        return 0.90, 0.80, 0.50, 1.0
    elseif rarity == 7 then -- Heirloom / Reliquia (Dorado Brillante WotLK)
        return 1.0, 0.82, 0.0, 1.0
    end
    -- Rarezas 0 (Pobre) y 1 (Común) no llevan borde en estética Dragonflight limpia
    return nil
end

local function EnsureBorderTexture(frame, r, g, b, a, size)
    if not frame then return end
    if not frame.borderTexture then
        frame.borderTexture = frame:CreateTexture(nil, "OVERLAY")
        frame.borderTexture:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
        frame.borderTexture:SetBlendMode("ADD")
        frame.borderTexture:SetPoint("CENTER", frame, "CENTER", 0, 0)
    end
    -- Calibración quirúrgica para botones de 37x37 px (evita desborde y solapamiento)
    local targetSize = size or 46
    frame.borderTexture:SetSize(targetSize, targetSize)
    frame.borderTexture:SetVertexColor(r, g, b, a or 1.0)
    frame.borderTexture:Show()
end

local function ResetSlotBorder(frame)
    if frame and frame.borderTexture then
        frame.borderTexture:Hide()
        frame.borderTexture:SetVertexColor(1, 1, 1, 0)
    end
end

local slotIDs = {
    "HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot",
    "ShirtSlot", "TabardSlot", "WristSlot", "HandsSlot", "WaistSlot",
    "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot",
    "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot", "RangedSlot"
}

local function UpdateButtonBorder(button, unit)
    if not button then return end
    local slotID = button:GetID()
    if not slotID or slotID <= 0 then return end

    local itemLink = GetInventoryItemLink(unit, slotID)
    if itemLink then
        local _, _, rarity = GetItemInfo(itemLink)
        local r, g, b, a = GetRarityColor(rarity)
        if r then
            EnsureBorderTexture(button, r, g, b, a, 46)
        else
            ResetSlotBorder(button)
        end
    else
        ResetSlotBorder(button)
    end
end

local function SetCharacterBorderColor()
    for _, slotName in ipairs(slotIDs) do
        local frame = _G["Character" .. slotName]
        if frame then
            UpdateButtonBorder(frame, "player")
        end
    end
end

local function SetInspectBorderColor()
    if not (InspectFrame and InspectFrame:IsShown()) then return end
    local unit = InspectFrame.unit or "target"
    for _, slotName in ipairs(slotIDs) do
        local frame = _G["Inspect" .. slotName]
        if frame then
            UpdateButtonBorder(frame, unit)
        end
    end
end

-- Hook nativo a la actualización de casillas de FrameXML
hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
    if button then
        UpdateButtonBorder(button, "player")
    end
end)

-- Listener de eventos reactivos con soporte de caché asíncrona
local f = CreateFrame("Frame", "ProjectJaina_CharRarity_Watcher")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
f:RegisterEvent("ADDON_LOADED")

f:SetScript("OnEvent", function(self, event, arg1)
    if event == "UNIT_INVENTORY_CHANGED" and arg1 ~= "player" then return end
    
    if event == "ADDON_LOADED" and arg1 == "Blizzard_InspectUI" then
        if InspectPaperDollItemSlotButton_Update then
            hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
                local unit = (InspectFrame and InspectFrame.unit) or "target"
                UpdateButtonBorder(button, unit)
            end)
        end
        return
    end

    SetCharacterBorderColor()
    SetInspectBorderColor()
end)

-- Hooks a la interfaz de usuario (Apertura y cambio entre pestañas)
if CharacterFrame then
    CharacterFrame:HookScript("OnShow", SetCharacterBorderColor)
end
if PaperDollFrame then
    PaperDollFrame:HookScript("OnShow", SetCharacterBorderColor)
end