
local L = {}
local bankSort = false;
local guildSort = false;
local moves = {};
local depth = 0;
local frame = CreateFrame("Frame");
local t = 0;
local current = nil;
local log = {};

local function Log(msg)
    table.insert(log, msg);

    if (SOCD ~= nil) then
        SOCD.log = log;
    end
end

local function ClearLog()
    log = {};
end

function SOCD_SlashCommand(cmd, arg2)
    Log("SOCD_SlashCommand("..tostring(cmd)..", "..tostring(arg2)..")");
    InterfaceOptionsFrame_OpenToCategory("Sushi Sort"); 
end

local function GetIDFromLink(link)
    Log("GetIDFromLink("..tostring(link)..")");
    return link and tonumber(string.match(link, "item:(%d+)"));
end

local function DoMoves()
    Log("DoMoves()");

    while (current ~= nil or #moves > 0) do
        if current ~= nil then    
            Log("current.id = "..tostring(current.id));
            if CursorHasItem() then
                Log("Cursor Has Item");
                local type, id = GetCursorInfo();
                Log("type = "..tostring(type)..", id = "..tostring(id));
                if (current ~= nil and current.id == id) then
                    if (current.sourcebag ~= nil) then
                        Log("PickupContainerItem("..current.targetbag..", "..current.targetslot..")");

                        PickupContainerItem(current.targetbag, current.targetslot);

            	        local link = select(7, GetContainerItemInfo(current.targetbag, current.targetslot));
                        if (current.id ~= GetIDFromLink(link)) then
                            return;
                        end
                    else
                        Log("PickupGuildBankItem("..current.targettab..", "..current.targetslot..")");
    
                        PickupGuildBankItem(current.targettab, current.targetslot);    
    
                	    local link = GetGuildBankItemLink(current.targettab, current.targetslot);
                        if (current.id ~= GetIDFromLink(link)) then
                            return;
                        end
                    end
                else
                    Log("Sort Aborted");
                    --DEFAULT_CHAT_FRAME:AddMessage("Sort Aborted");
                    moves = {};
                    current = nil;
                    frame:Hide();
                    return;
                end
            else
                if (current.sourcebag ~= nil) then
        	        local link = select(7, GetContainerItemInfo(current.targetbag, current.targetslot));
                    if (current.id ~= GetIDFromLink(link)) then
                        return;
                    end
                else
            	    local link = GetGuildBankItemLink(current.targettab, current.targetslot);
                    if (current.id ~= GetIDFromLink(link)) then
                        return;
                    end
                end
                current = nil;
            end
        else      
            Log("current == nil");
            if (#moves > 0) then
                Log("("..#moves.." > 0)");
        
                current = table.remove(moves, 1);

                if (current.sourcebag ~= nil) then
                    Log("PickupContainerItem("..current.sourcebag..", "..current.sourceslot..")");
                    PickupContainerItem(current.sourcebag, current.sourceslot);
                    if CursorHasItem() == false then
                        return;
                    end 
                    
                    Log("PickupContainerItem("..current.targetbag..", "..current.targetslot..")");
                    PickupContainerItem(current.targetbag, current.targetslot);
        	        local link = select(7, GetContainerItemInfo(current.targetbag, current.targetslot));
                    if (current.id == GetIDFromLink(link)) then
                        Log("current = nil");
                        current = nil;
                    else
                        return;
                    end
                else
                    Log("PickupGuildBankItem("..current.sourcetab..", "..current.sourceslot..")");
                    PickupGuildBankItem(current.sourcetab, current.sourceslot);    
                    Log("PickupGuildBankItem("..current.targettab..", "..current.targetslot..")");
                    PickupGuildBankItem(current.targettab, current.targetslot);    
            	    local link = GetGuildBankItemLink(current.targettab, current.targetslot);
                    if (current.id == GetIDFromLink(link)) then
                        Log("current = nil");
                        current = nil;
                    else                        
                        return;
                    end
                end

            end        
        end
    end
    Log("Sorted!");
    --DEFAULT_CHAT_FRAME:AddMessage("Sorted!");
    frame:Hide();
end

local function CompareItems(lItem, rItem)
    Log("CompareItems("..lItem.name..", "..rItem.name..")");

    if (rItem.id == nil) then
        Log("(rItem.id == nil)");
        return true;
    elseif (lItem.id == nil) then
        Log("(lItem.id == nil)");
        return false;
    elseif (lItem.quality ~= rItem.quality) then
        Log("(lItem.quality ~= rItem.quality)");
        return (lItem.quality > rItem.quality);
    elseif (lItem.class ~= rItem.class) then
        Log("(lItem.class ~= rItem.class)");
        return (lItem.class < rItem.class);
    elseif (lItem.subclass ~= rItem.subclass) then
        Log("(lItem.subclass ~= rItem.subclass)");
        return (lItem.subclass < rItem.subclass);
    elseif (lItem.name ~= rItem.name) then
        Log("(lItem.name ~= rItem.name)");
        return (lItem.name < rItem.name);
    elseif ((lItem.count) ~= (rItem.count)) then
        Log("((lItem.count) ~= (rItem.count))");
        return ((lItem.count) >= (rItem.count));
    else
        Log("return true");
        return true;
    end
end

local function BeginSort()
    Log("BeginSort()");
    current = nil;
    moves = {};
    ClearCursor();
end

local function SortBag(bag)
    Log("SortBag(bag)");
    
    for i=1,#bag,1 do
        Log("i="..i);
        local lowest = i;
        for j=#bag,i+1,-1 do
            Log("j="..j);
            if (CompareItems(bag[lowest],bag[j]) == false) then
                Log("lowest="..j);
                lowest = j;
            end
        end
        if (i ~= lowest) then
            Log("(i ~= lowest)");

            -- store move
            move = {};
            move.id = bag[lowest].id;
            move.name = bag[lowest].name;
            move.sourcebag = bag[lowest].bag;
            move.sourcetab = bag[lowest].tab;
            move.sourceslot = bag[lowest].slot;
            move.targetbag = bag[i].bag;
            move.targettab = bag[i].tab;
            move.targetslot = bag[i].slot;
            table.insert(moves, move);
            Log("move "..move.name.." from "..move.sourceslot.." to "..move.targetslot);
            
            -- swap items
            local tmp = bag[i];
            bag[i] = bag[lowest];
            bag[lowest] = tmp;

            Log("bag[i] = "..bag[i].name.."("..bag[i].slot.."), bag[lowest] = "..bag[lowest].name.."("..bag[lowest].slot..")");

            -- swap slots
            tmp = bag[i].slot;
            bag[i].slot = bag[lowest].slot;
            bag[lowest].slot = tmp;
            tmp = bag[i].bag;
            bag[i].bag = bag[lowest].bag;
            bag[lowest].bag = tmp;
            tmp = bag[i].tab;
            bag[i].tab = bag[lowest].tab;
            bag[lowest].tab = tmp;

            Log("bag[i] = "..bag[i].name.."("..bag[i].slot.."), bag[lowest] = "..bag[lowest].name.."("..bag[lowest].slot..")");
        end
    end
end

local function CreateBagFromID(bagID)
    Log("CreateBagFromID("..bagID..")");

    local items = GetContainerNumSlots(bagID);
    local bag = {};

    Log("items = "..items);

	for i=1, items, 1 do
	    local item = {};

        Log("i = "..i);

	    local _, count, _, _, _, _, link = GetContainerItemInfo(bagID, i);
	    item.bag = bagID;
	    item.slot = i;
	    item.name = "<EMPTY>";
        item.id = GetIDFromLink(link);
        if (item.id ~= nil) then
            item.count = count;
            item.name, _, item.quality, _, _, item.class, item.subclass, _, item.type, _, item.price = GetItemInfo(item.id);
        end

        Log("item = "..item.name);

        table.insert(bag, item);
    end
    return bag;
end

local function CreateBagFromTab(tab)
    Log("CreateBagFromTab("..tab..")");

    local items = MAX_GUILDBANK_SLOTS_PER_TAB;
    local bag = {};

    Log("items = "..items);

	for i=1, items, 1 do
	    local item = {};

        Log("i = "..i);

	    local _, count = GetGuildBankItemInfo(tab, i);
	    local link = GetGuildBankItemLink(tab, i);
	    item.tab = tab;
	    item.slot = i;
	    item.name = "<EMPTY>";
        item.id = GetIDFromLink(link);
        if (item.id ~= nil) then
            item.count = count;
            item.name, _, item.quality, _, _, item.class, item.subclass, _, item.type, _, item.price = GetItemInfo(item.id);
        end
        table.insert(bag, item);

        Log("item = "..item.name);
    end
    return bag;
end

local function SOCD_BagSortButton(self) 
    ClearLog();

    Log("SOCD_BagSortButton(self)");
    local bags = {};

	for i=0, NUM_BAG_FRAMES, 1 do
	    local framenum = i + 1;
        if _G["ContainerFrame"..framenum.."SortCheck"]:GetChecked() then
            Log("Bag #"..i.." is checked");
            local bag = CreateBagFromID(i);
            local type = select(2, GetContainerNumFreeSlots(i));
            if type == nil then
                type = "ALL"
            else
                type = tostring(type);
            end
            Log("type = "..type);
            if bags[type] == nil then
                Log("bags[type] == nil");
                bags[type] = bag; 
            else
                Log("bags[type] ~= nil");
                Log("#bags[type] = "..#bags[type]);
                for j=1, #bag, 1 do
                    table.insert(bags[type], bag[j]);
                end
                Log("#bags[type] = "..#bags[type]);
            end
        end
    end

    BeginSort();
    for k,v in pairs(bags) do
	    if v ~= nil then
            Log("k = "..k..", v ~= nli");
	        SortBag(v);
	    end   
    end        
    frame:Show();
end

local function SOCD_BankSortButton(self) 
    ClearLog();

    Log("SOCD_BankSortButton(self)");
    local bags = {};

    if _G["BankFrameSortCheck"]:GetChecked() then
          Log("Bank is checked");
        bags["ALL"] = CreateBagFromID(-1);
    end
    
	for i=NUM_BAG_FRAMES+1, NUM_CONTAINER_FRAMES, 1 do
	    local framenum = i + 1;
	    local frame = _G["ContainerFrame"..framenum.."SortCheck"];
        if (frame ~= nil and frame:GetChecked()) then
            Log("Bag #"..i.." is checked");
            local bag = CreateBagFromID(i);
            local type = select(2, GetContainerNumFreeSlots(i));
            if type == nil then
                type = "ALL"
            else
                type = tostring(type);
            end
            Log("type = "..type);
            if bags[type] == nil then
                Log("bags[type] == nil");
                bags[type] = bag; 
            else
                Log("bags[type] ~= nil");
                Log("#bags[type] = "..#bags[type]);
                for j=1, #bag, 1 do
                    table.insert(bags[type], bag[j]);
                end
                Log("#bags[type] = "..#bags[type]);
            end
        end
    end

    BeginSort();
    for k,v in pairs(bags) do
	    if v ~= nil then
            Log("k = "..k..", v ~= nli");
	        SortBag(v);
	    end   
    end        
    frame:Show();

end

local function SOCD_GuildSortButton(self) 
    ClearLog();

    Log("SOCD_GuildSortButton(self)");
    local bag = CreateBagFromTab(GetCurrentGuildBankTab());
    SortBag(bag);
    frame:Show();
end

local function CreateSortCheck(name, parent, x, y)
    Log("CreateSortCheck("..name..", parent, "..x..", "..y..")");

    parent.sortCheck = CreateFrame("CheckButton", name, parent, "SOCDCheckTemplate");
    parent.sortCheck.parentFrame = parent;
    parent.sortCheck:SetChecked(true);
    parent.sortCheck.tooltipText = "Incluir esta bolsa al organizar?";
    parent.sortCheck:ClearAllPoints();
    parent.sortCheck:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y);
    -- Mantener oculto por defecto para una UI limpia y profesional
    parent.sortCheck:Hide();
end

local function CreateSortButton(name, parent, x, y, handler, tooltipTitle, tooltipDesc)
    Log("CreateSortButton("..name..", parent, "..x..", "..y..", handler)");

    local btn = CreateFrame("Button", name, parent)
    parent.sortButton = btn
    btn.parentFrame = parent
    btn:SetWidth(20)
    btn:SetHeight(20)

    -- Icono limpio de escoba organizadora (estilo Dragonflight / Clean Bags)
    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(btn)
    icon:SetTexture("Interface\\Icons\\INV_Pet_Broom")
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    btn.icon = icon

    -- Borde sutil
    local border = btn:CreateTexture(nil, "OVERLAY")
    border:SetPoint("TOPLEFT", btn, "TOPLEFT", -2, 2)
    border:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 2, -2)
    border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    border:SetBlendMode("ADD")
    border:SetVertexColor(0.83, 0.69, 0.22, 0.8) -- Oro Dalaran
    btn.border = border

    -- Highlight interactivo
    local hl = btn:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(btn)
    hl:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    hl:SetBlendMode("ADD")
    btn:SetHighlightTexture(hl)

    btn:ClearAllPoints()
    btn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", x, y)

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(tooltipTitle or "|cFFD4AF37Organizar Inventario|r")
        GameTooltip:AddLine(tooltipDesc or "Haz clic para ordenar y consolidar los objetos automáticamente.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    if SOCD and SOCD.IsEnabled then
        btn:Show()
    else
        btn:Hide()
    end

    btn:SetScript("OnClick", handler)
end

function SOCD_MainFrame_OnLoad(self)
    Log("SOCD_MainFrame_OnLoad(self)");

    local fEnable = true;
    if (SOCD ~= nil and SOCD.IsEnabled ~= nil) then
        fEnable = SOCD.IsEnabled;
    end

    SOCD = {};
    SOCD.IsEnabled = fEnable;

    L = 
    {
	    SOCD_OPTIONSPANEL_CREDITS1 = "Integrado en Project Jaina Dragonflight UI.",
    	SOCD_OPTIONSPANEL_CREDITS2 = "Soporte oficial de economía e inventario.",
    	SOCD_OPTIONSPANEL_ENABLE = "Activar Ordenador Automático",
    	SOCD_OPTIONSPANEL_ENABLE_TIP = "Permite ordenar mochilas y banco con 1 clic.",
    	SOCD_OPTIONSPANEL_TITLE = "Organizador de Bolsas (Project Jaina)",
    }

    SOCD_OPTIONSPANEL_TITLE = L["SOCD_OPTIONSPANEL_TITLE"];
    SOCD_OPTIONSPANEL_ENABLE = L["SOCD_OPTIONSPANEL_ENABLE"];
    SOCD_OPTIONSPANEL_ENABLE_TIP = L["SOCD_OPTIONSPANEL_ENABLE_TIP"];
    SOCD_OPTIONSPANEL_CREDITS1 = L["SOCD_OPTIONSPANEL_CREDITS1"];
    SOCD_OPTIONSPANEL_CREDITS2 = L["SOCD_OPTIONSPANEL_CREDITS2"];

	for i=1, NUM_CONTAINER_FRAMES, 1 do
        CreateSortCheck("ContainerFrame"..i.."SortCheck", _G["ContainerFrame"..i], 42, -25)
    end

    CreateSortButton("ContainerFrame1SortButton", _G["ContainerFrame1"], -32, -28, SOCD_BagSortButton, "|cFFD4AF37Organizar Mochila|r", "Haz clic para ordenar y consolidar los objetos de tu inventario.");

    frame:SetScript("OnUpdate", function(self, elapsed)
    	t = t + (elapsed or 0.05);
    	if t > 0.05 then
    		t = 0;
            DoMoves();
    	end
    end)
    frame:Hide();

	self:RegisterEvent("BANKFRAME_OPENED");
	self:RegisterEvent("GUILDBANKFRAME_OPENED");
    self:RegisterEvent("VARIABLES_LOADED");
end

local function hook_GuildBankTab_OnClick(...)
    Log("hook_GuildBankTab_OnClick(...)");
    
    local tab = GetCurrentGuildBankTab();
    if (tab > GetNumGuildBankTabs()) then
        if _G["GuildBankFrame"] and _G["GuildBankFrame"].sortButton then
            _G["GuildBankFrame"].sortButton:Disable();
        end
    else
        if _G["GuildBankFrame"] and _G["GuildBankFrame"].sortButton then
            _G["GuildBankFrame"].sortButton:Enable();
        end
    end
end

function SOCD_MainFrame_OnEvent(self, event, ...)
    Log("SOCD_MainFrame_OnEvent(self, "..event..", ...)");
	if (event == "BANKFRAME_OPENED") then 
	    if (bankSort == false) then
	        bankSort = true;
            CreateSortCheck("BankFrameSortCheck", _G["BankFrame"], 68, -32)
    	    CreateSortButton("BankFrameSortButton", _G["BankFrame"], -42, -34, SOCD_BankSortButton, "|cFFD4AF37Organizar Banco|r", "Haz clic para ordenar y agrupar los objetos de tu banco personal.");
	    end
	elseif (event == "GUILDBANKFRAME_OPENED") then 
	    if (guildSort == false) then
	        guildSort = true;
    	    CreateSortButton("GBankFrameSortButton", _G["GuildBankFrame"], -40, -34, SOCD_GuildSortButton, "|cFFD4AF37Organizar Pestaña de Hermandad|r", "Haz clic para ordenar los objetos de la pestaña activa del banco de hermandad.");

            hooksecurefunc("GuildBankTab_OnClick", hook_GuildBankTab_OnClick)
        end
    elseif(event == "VARIABLES_LOADED") then
        Log("(event == VARIABLES_LOADED)");
        InterfaceOptions_AddCategory(SOCD_OptionsPanel);
	end
end

function SOCD_OptionsPanel_OnOk(self)
    Log("SOCD_OptionsPanel_OnOk(self)")
    local isChecked = SOCD_OptionsPanel_OCDEnabled:GetChecked()
    SOCD.IsEnabled = (isChecked == 1 or isChecked == true)

    -- 1. Actualización segura de contenedores de mochila
    for i = 1, NUM_CONTAINER_FRAMES do
        local cf = _G["ContainerFrame" .. i]
        if cf and cf.sortButton then
            if SOCD.IsEnabled then
                cf.sortButton:Show()
            else
                cf.sortButton:Hide()
            end
        end
    end

    -- 2. Actualización segura de banco personal (si ha sido instanciado)
    local bankFrame = _G["BankFrame"]
    if bankFrame and bankFrame.sortButton then
        if SOCD.IsEnabled then
            bankFrame.sortButton:Show()
        else
            bankFrame.sortButton:Hide()
        end
    end

    -- 3. Actualización segura de banco de hermandad (LOD resiliente)
    local guildBankFrame = _G["GuildBankFrame"]
    if guildBankFrame and guildBankFrame.sortButton then
        if SOCD.IsEnabled then
            guildBankFrame.sortButton:Show()
        else
            guildBankFrame.sortButton:Hide()
        end
    end
end

function SOCD_OptionsPanel_OnCancel(self)
    Log("SOCD_OptionsPanel_OnCancel(self)")
    if SOCD and SOCD.IsEnabled ~= nil then
        SOCD_OptionsPanel_OCDEnabled:SetChecked(SOCD.IsEnabled)
    else
        SOCD_OptionsPanel_OCDEnabled:SetChecked(true)
    end
end

function SOCD_OptionsPanel_OnDefault(self)
    Log("SOCD_OptionsPanel_OnDefault(self)")
    SOCD.IsEnabled = true
    SOCD_OptionsPanel_OCDEnabled:SetChecked(SOCD.IsEnabled)
end

function SOCD_OptionsPanel_OnRefresh(self)
    Log("SOCD_OptionsPanel_OnRefresh(self)")
    SOCD_OptionsPanel_OnCancel(self)
end

function SOCD_OptionsPanel_OnLoad(panel)
    Log("SOCD_OptionsPanel_OnLoad(panel)");
    panel.name = "Sushi Sort";
    panel.okay = SOCD_OptionsPanel_OnOk;
    panel.cancel = SOCD_OptionsPanel_OnCancel;
    panel.default = SOCD_OptionsPanel_OnDefault;
    panel.refresh = SOCD_OptionsPanel_OnRefresh;
end

SLASH_SUSHISORT1 = "/SS";
SlashCmdList["SUSHISORT"] = SOCD_SlashCommand;

