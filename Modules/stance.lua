local addon = select(2,...);
local config = addon.config;
local event = addon.package;
local class = addon._class;
local pUiMainBar = addon.pUiMainBar;
local unpack = unpack;
local select = select;
local pairs = pairs;
local _G = getfenv(0);

-- const
local InCombatLockdown = InCombatLockdown;
local GetNumShapeshiftForms = GetNumShapeshiftForms;
local GetShapeshiftFormInfo = GetShapeshiftFormInfo;
local GetShapeshiftFormCooldown = GetShapeshiftFormCooldown;
local CreateFrame = CreateFrame;
local UIParent = UIParent;
local hooksecurefunc = hooksecurefunc;
local UnitAffectingCombat = UnitAffectingCombat;

local stance = {
	['DEATHKNIGHT'] = 'show',
	['DRUID'] = 'show',
	['PALADIN'] = 'show',
	['PRIEST'] = 'show',
	['ROGUE'] = 'show',
	['WARLOCK'] = 'show',
	['WARRIOR'] = 'show'
};

-- @param: config number
local offsetX = config.additional.stance.x_position;
local nobar = config.additional.y_position;
local exOffs = config.additional.leftbar_offset;
local exOffs2 = config.additional.rightbar_offset;
local leftOffset, rightOffset = nobar + exOffs, nobar + exOffs2;

local anchor = CreateFrame('Frame', 'pUiStanceHolder', pUiMainBar)
anchor:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, nobar)
anchor:SetSize(37, 37)

-- method update position
function anchor:stancebar_update()
	local leftbar = MultiBarBottomLeft:IsShown();
	local rightbar = MultiBarBottomRight:IsShown();
	if not InCombatLockdown() and not UnitAffectingCombat('player') then
		self:ClearAllPoints();
		if leftbar and rightbar then
			self:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, leftOffset);
		elseif leftbar or rightbar then
			self:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, rightOffset);
		else
			self:SetPoint('TOPLEFT', pUiMainBar, 'TOPLEFT', offsetX, nobar);
		end
	end
end

event:RegisterEvents(function()
	anchor:stancebar_update();
end,
	'PLAYER_LOGIN', 'PLAYER_ENTERING_WORLD', 'PLAYER_REGEN_ENABLED', 'ADDON_LOADED'
);

for _,bar in pairs({MultiBarBottomLeft, MultiBarBottomRight}) do
	if bar then
		bar:HookScript('OnShow', function()
			anchor:stancebar_update();
		end);
		bar:HookScript('OnHide', function()
			anchor:stancebar_update();
		end);
	end
end;

local stancebar = CreateFrame('Frame', 'pUiStanceBar', anchor, 'SecureHandlerStateTemplate')
stancebar:SetAllPoints(anchor)

local function stancebutton_update()
	if not InCombatLockdown() and _G.ShapeshiftButton1 then
		_G.ShapeshiftButton1:ClearAllPoints()
		_G.ShapeshiftButton1:SetPoint('BOTTOMLEFT', anchor, 'BOTTOMLEFT', 0, 0)
	end
end

local btnsize = config.additional.size;
local space = config.additional.spacing;
local isPositioned = false;
local function stancebutton_position()
	for index=1, NUM_SHAPESHIFT_SLOTS do
		local button = _G['ShapeshiftButton'..index]
		if button then
			button:ClearAllPoints()
			button:SetParent(stancebar)
			button:SetSize(btnsize, btnsize)
			if index == 1 then
				button:SetPoint('BOTTOMLEFT', anchor, 'BOTTOMLEFT', 0, 0)
			else
				local previous = _G['ShapeshiftButton'..index-1]
				if previous then
					button:SetPoint('LEFT', previous, 'RIGHT', space, 0)
				else
					button:SetPoint('BOTTOMLEFT', anchor, 'BOTTOMLEFT', 0, 0)
				end
			end
			local _,name = GetShapeshiftFormInfo(index)
			if name then
				button:Show()
			else
				button:Hide()
			end
		end
	end
	if not isPositioned then
		isPositioned = true
		local visibilityDriver = stance[class] and '[bonusbar:5][vehicleui] hide; show' or 'hide'
		RegisterStateDriver(stancebar, 'visibility', visibilityDriver)
		hooksecurefunc('ShapeshiftBar_Update', stancebutton_update)
	end
end

local function stancebutton_updatestate()
	local numForms = GetNumShapeshiftForms()
	local texture, name, isActive, isCastable;
	local button, icon, cooldown;
	local start, duration, enable;
	for index=1, NUM_SHAPESHIFT_SLOTS do
		button = _G['ShapeshiftButton'..index]
		icon = _G['ShapeshiftButton'..index..'Icon']
		if index <= numForms then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(index)
			icon:SetTexture(texture)
			cooldown = _G['ShapeshiftButton'..index..'Cooldown']
			if texture then
				cooldown:SetAlpha(1)
			else
				cooldown:SetAlpha(0)
			end
			start, duration, enable = GetShapeshiftFormCooldown(index)
			CooldownFrame_SetTimer(cooldown, start, duration, enable)
			if isActive then
				ShapeshiftBarFrame.lastSelected = button:GetID()
				button:SetChecked(1)
			else
				button:SetChecked(0)
			end
			if isCastable then
				icon:SetVertexColor(255/255, 255/255, 255/255)
			else
				icon:SetVertexColor(102/255, 102/255, 102/255)
			end
		end
	end
end

local function stancebutton_setup()
	if InCombatLockdown() then return end
	for index=1, NUM_SHAPESHIFT_SLOTS do
		local button = _G['ShapeshiftButton'..index]
		local _, name = GetShapeshiftFormInfo(index)
		if name then
			button:Show()
		else
			button:Hide()
		end
	end
	stancebutton_updatestate();
end

local isTemplated = false;
local function OnEvent(self,event,...)
	if event == 'PLAYER_LOGIN' then
		stancebutton_position();
	elseif event == 'PLAYER_ENTERING_WORLD' then
		if not isTemplated and addon.stancebuttons_template then
			addon.stancebuttons_template();
			isTemplated = true;
		end
		stancebutton_setup();
	elseif event == 'UPDATE_SHAPESHIFT_FORMS' then
		stancebutton_position();
		stancebutton_setup();
	else
		if GetNumShapeshiftForms() > 0 then
			stancebutton_updatestate();
		end
	end
end

stancebar:RegisterEvent('PLAYER_LOGIN');
stancebar:RegisterEvent('PLAYER_ENTERING_WORLD');
stancebar:RegisterEvent('UPDATE_SHAPESHIFT_FORMS');
stancebar:RegisterEvent('UPDATE_SHAPESHIFT_USABLE');
stancebar:RegisterEvent('UPDATE_SHAPESHIFT_COOLDOWN');
stancebar:RegisterEvent('UPDATE_SHAPESHIFT_FORM');
stancebar:RegisterEvent('ACTIONBAR_PAGE_CHANGED');
stancebar:SetScript('OnEvent', OnEvent);