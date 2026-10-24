-- Project Jaina - DragonflightUI: Character Equipment Rarity Border Engine (3.3.5a WotLK)
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
    elseif rarity == 6 then -- Artifact / Heirloom (Dorado)
        return 0.90, 0.80, 0.50, 1.0
    end
    -- Rarezas 0 (Pobre) y 1 (Común) no llevan borde en estética Dragonflight limpia
    return nil
end

local function EnsureBorderTexture(frame, r, g, b, a)
    if not frame then return end
    if not frame.borderTexture then
        frame.borderTexture = frame:CreateTexture(nil, "OVERLAY")
        frame.borderTexture:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
        frame.borderTexture:SetBlendMode("ADD")
        frame.borderTexture:SetSize(66, 66)
        frame.borderTexture:SetPoint("CENTER", frame, "CENTER", 0, 0)
    end
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

local function SetCharacterBorderColor()
    for _, slotID in ipairs(slotIDs) do
        local frame = _G["Character" .. slotID]
        if frame then
            local slotNum = GetInventorySlotInfo(slotID)
            local itemLink = slotNum and GetInventoryItemLink("player", slotNum)

            if itemLink then
                local _, _, rarity = GetItemInfo(itemLink)
                local r, g, b, a = GetRarityColor(rarity)
                if r then
                    EnsureBorderTexture(frame, r, g, b, a)
                else
                    ResetSlotBorder(frame)
                end
            else
                ResetSlotBorder(frame)
            end
        end
    end
end

-- Listener de eventos reactivos
local f = CreateFrame("Frame", "ProjectJaina_CharRarity_Watcher")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, unit)
    if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end
    SetCharacterBorderColor()
end)

-- Actualización instantánea al abrir la ventana de personaje (Tecla 'C')
if CharacterFrame then
    CharacterFrame:HookScript("OnShow", SetCharacterBorderColor)
end