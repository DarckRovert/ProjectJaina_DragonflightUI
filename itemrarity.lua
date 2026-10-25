-- Project Jaina - DragonflightUI: Item Rarity Border Engine (3.3.5a WotLK)
-- Cobertura completa: Mochilas, Bolsas de Contenedor y Banco Principal

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
    elseif rarity == 7 then -- Heirloom / Reliquia WotLK (Dorado Brillante)
        return 1.0, 0.82, 0.0, 1.0
    end
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
    local targetSize = size or 46
    frame.borderTexture:SetSize(targetSize, targetSize)
    frame.borderTexture:SetVertexColor(r, g, b, a or 1.0)
    frame.borderTexture:Show()
end

local function ResetSlotBorderColor(frame)
    if frame and frame.borderTexture then
        frame.borderTexture:Hide()
        frame.borderTexture:SetVertexColor(1, 1, 1, 0)
    end
end

local function IsExcludedItem(itemLink)
    if not itemLink then return false end
    local itemId = tonumber(itemLink:match("item:(%d+)"))
    if itemId == 6948 or itemId == 7005 or itemId == 2901 or itemId == 21177 then
        return true -- Hearthstone, Skinning Knife, Mining Pick, Symbol of Kings
    end

    local itemType = select(6, GetItemInfo(itemLink))
    if itemType == "Quest" or itemType == "Misión" or itemType == "Objeto de misión" then
        return true
    end

    return false
end

-- Actualiza los bordes de un ContainerFrame específico (o de todos los visibles)
local function UpdateContainerFrameBorders(container)
    if not container or not container:IsShown() then return end
    local bagID = container:GetID()
    local numSlots = GetContainerNumSlots(bagID)
    local frameName = container:GetName()
    if not frameName or numSlots == 0 then return end

    for slot = 1, numSlots do
        local itemLink = GetContainerItemLink(bagID, slot)
        local invertedSlot = numSlots - slot + 1
        local itemBtn = _G[frameName.."Item"..invertedSlot]

        if itemBtn then
            if itemLink and not IsExcludedItem(itemLink) then
                local _, _, rarity = GetItemInfo(itemLink)
                local r, g, b, a = GetRarityColor(rarity)
                if r then
                    EnsureBorderTexture(itemBtn, r, g, b, a, 46)
                else
                    ResetSlotBorderColor(itemBtn)
                end
            else
                ResetSlotBorderColor(itemBtn)
            end
        end
    end
end

local function UpdateAllContainers()
    for i = 1, NUM_CONTAINER_FRAMES do
        local container = _G["ContainerFrame"..i]
        if container and container:IsShown() then
            UpdateContainerFrameBorders(container)
        end
    end
end

-- Actualiza los 28 slots fijos del Banco Principal
local function UpdateBankBorders()
    if not BankFrame or not BankFrame:IsShown() then return end
    for slot = 1, 28 do
        local itemBtn = _G["BankFrameItem"..slot]
        if itemBtn then
            local itemLink = GetContainerItemLink(-1, slot)
            if itemLink and not IsExcludedItem(itemLink) then
                local _, _, rarity = GetItemInfo(itemLink)
                local r, g, b, a = GetRarityColor(rarity)
                if r then
                    EnsureBorderTexture(itemBtn, r, g, b, a, 46)
                else
                    ResetSlotBorderColor(itemBtn)
                end
            else
                ResetSlotBorderColor(itemBtn)
            end
        end
    end
end

-- Hook nativo seguro: cada vez que Blizzard dibuja/abre un ContainerFrame
hooksecurefunc("ContainerFrame_Update", function(container)
    UpdateContainerFrameBorders(container)
end)

-- Listener de eventos reactivos
local f = CreateFrame("Frame", "ProjectJaina_ItemRarity_Watcher")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("BAG_UPDATE_COOLDOWN")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("BANKFRAME_OPENED")
f:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
f:RegisterEvent("GET_ITEM_INFO_RECEIVED")

f:SetScript("OnEvent", function(self, event, arg1)
    if event == "BANKFRAME_OPENED" or event == "PLAYERBANKSLOTS_CHANGED" then
        UpdateBankBorders()
    elseif event == "BAG_UPDATE" then
        for i = 1, NUM_CONTAINER_FRAMES do
            local container = _G["ContainerFrame"..i]
            if container and container:IsShown() and container:GetID() == arg1 then
                UpdateContainerFrameBorders(container)
            end
        end
    else
        UpdateAllContainers()
        UpdateBankBorders()
    end
end)
