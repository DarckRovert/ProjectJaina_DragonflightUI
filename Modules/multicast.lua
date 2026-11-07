local addon = select(2,...);
local config = addon.config;
local class = addon._class;
local noop = addon._noop;
local select = select;
local InCombatLockdown = InCombatLockdown;
local hooksecurefunc = hooksecurefunc;

local possessbar = CreateFrame('Frame', 'pUiPossessBar', UIParent, 'SecureHandlerStateTemplate')
possessbar:SetAllPoints(pUiPetBarHolder)
PossessBarFrame:SetParent(possessbar)
PossessBarFrame:SetClearPoint('BOTTOMLEFT', -68, 0)

local btnsize = config.additional.size;
local space = config.additional.spacing;

local function possessbutton_position()
	local button
	for index=1, NUM_POSSESS_SLOTS do
		button = _G['PossessButton'..index];
		if button then
			button:ClearAllPoints();
			button:SetSize(btnsize, btnsize);
			if index == 1 then
				button:SetPoint('BOTTOMLEFT', 0, 0);
			else
				button:SetPoint('LEFT', _G['PossessButton'..index-1], 'RIGHT', space, 0);
			end
		end
	end
	if addon.possessbuttons_template then
		addon.possessbuttons_template();
	end
	-- Macro-condición autoritativa: solo visible bajo posesión real y fuera de vehículos
	RegisterStateDriver(possessbar, 'visibility', '[vehicleui][bonusbar:5] hide; [possessbar] show; hide');
end
possessbutton_position();

-- Configuración resiliente de barra de tótems para Chamanes
local function setupShamanTotemBar()
	if class ~= 'SHAMAN' then return end
	if not MultiCastActionBarFrame then return end

	MultiCastActionBarFrame:SetScript('OnUpdate', nil)
	MultiCastActionBarFrame:SetScript('OnShow', nil)
	MultiCastActionBarFrame:SetScript('OnHide', nil)
	MultiCastActionBarFrame:SetParent(pUiStanceHolder)
	MultiCastActionBarFrame:SetClearPoint('BOTTOMLEFT', pUiStanceHolder, -3, 0)

	hooksecurefunc('MultiCastActionButton_Update', function(actionButton)
		if not InCombatLockdown() and actionButton and actionButton.slotButton then
			actionButton:SetAllPoints(actionButton.slotButton)
		end
	end);

	MultiCastActionBarFrame.SetParent = noop;
	MultiCastActionBarFrame.SetPoint = noop;
	if MultiCastRecallSpellButton then
		MultiCastRecallSpellButton.SetPoint = noop;
	end
end

if class == 'SHAMAN' then
	if not IsAddOnLoaded('Blizzard_TotemBar') and LoadAddOn then
		LoadAddOn('Blizzard_TotemBar')
	end
	setupShamanTotemBar()

	local totemListener = CreateFrame('Frame')
	totemListener:RegisterEvent('ADDON_LOADED')
	totemListener:RegisterEvent('PLAYER_ENTERING_WORLD')
	totemListener:SetScript('OnEvent', function(self, event, loadedAddon)
		if event == 'PLAYER_ENTERING_WORLD' or loadedAddon == 'Blizzard_TotemBar' then
			setupShamanTotemBar()
		end
	end)
end
