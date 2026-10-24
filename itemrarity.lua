-- Project Jaina - DragonflightUI: Item Rarity Border Engine (3.3.5a WotLK)
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
    -- Rarezas 0 (Pobre) y 1 (Común) no llevan borde resaltado
    return nil
end

local function EnsureBorderTexture(frame, r, g, b, a)
    if not frame then return end
    if not frame.borderTexture then
        frame.borderTexture = frame:CreateTexture(nil, "OVERLAY")
        frame.borderTexture:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
        frame.borderTexture:SetBlendMode("ADD")
        frame.borderTexture:SetSize(68, 68)
        frame.borderTexture:SetPoint("CENTER", frame, "CENTER", 0, 0)
    end
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
        return true -- Hearthstone (es/en), Skinning Knife, Mining Pick, Symbol of Kings
    end

    -- En 3.3.5a WotLK, itemType es el índice 6 de GetItemInfo
    local itemType = select(6, GetItemInfo(itemLink))
    if itemType == "Quest" or itemType == "Misión" then
        return true
    end

    return false
end

local function SetItemBorderColor()
    for i = 1, NUM_CONTAINER_FRAMES do
        local container = _G["ContainerFrame"..i]
        if container and container:IsShown() then
            local bagID = container:GetID()
            local numSlots = GetContainerNumSlots(bagID)
            local frameName = container:GetName()
            for slot = 1, numSlots do
                local itemLink = GetContainerItemLink(bagID, slot)
                local invertedSlot = numSlots - slot + 1
                local itemBtn = _G[frameName.."Item"..invertedSlot]

                if itemBtn then
                    if itemLink and not IsExcludedItem(itemLink) then
                        local _, _, rarity = GetItemInfo(itemLink)
                        local r, g, b, a = GetRarityColor(rarity)
                        if r then
                            EnsureBorderTexture(itemBtn, r, g, b, a)
                        else
                            ResetSlotBorderColor(itemBtn)
                        end
                    else
                        ResetSlotBorderColor(itemBtn)
                    end
                end
            end
        end
    end
end

local f = CreateFrame("Frame", "ProjectJaina_ItemRarity_Watcher")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("BAG_UPDATE_COOLDOWN")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    SetItemBorderColor()
end)
