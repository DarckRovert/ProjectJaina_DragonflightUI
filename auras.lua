local addon = select(2,...);
local config = addon.config;
local atlas = addon.SetAtlas;
local shown = addon.SetShown;
local mixin = addon.Mixin;
local select = select;
local pairs = pairs;
local ceil = math.ceil;
local _G = _G;

local Minimap = Minimap;
local TempEnchant1 = TempEnchant1;
local TempEnchant2 = TempEnchant2;
local UnitHasVehicleUI = UnitHasVehicleUI;
local hooksecurefunc = hooksecurefunc;

local AuraFrameMixin = {};

TempEnchant1:ClearAllPoints()
TempEnchant1:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -80, 24)

TempEnchant2:ClearAllPoints()
TempEnchant2:SetPoint('TOPRIGHT', TempEnchant1, 'TOPLEFT', -5, 0)

ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint('TOPRIGHT', TempEnchant1)

function AuraFrameMixin:UpdateFirstButton(button)
	if button and button:IsShown() then
		button:ClearAllPoints()
		if UnitHasVehicleUI('player') then
			button:SetPoint('TOPRIGHT', TempEnchant1)
			return
		else
			if BuffFrame.numEnchants > 0 then
				button:SetPoint('TOPRIGHT', _G['TempEnchant'..BuffFrame.numEnchants], 'TOPLEFT', -5, 0)
				return
			else
				button:SetPoint('TOPRIGHT', TempEnchant1)
				return
			end
		end
	end
end

function AuraFrameMixin:UpdateBuffsAnchor()
	if self.arrow and self.arrow.collapse then
		BuffFrame:Hide()
		return
	end

	local previousBuff, aboveBuff
	local numBuffs = 0
	local numTotal = BuffFrame.numEnchants or 0
	
	for index=1, BUFF_ACTUAL_DISPLAY do
		local buff = _G['BuffButton'..index]
		if not buff then return end
		
		numBuffs = numBuffs + 1
		numTotal = numTotal + 1
        
		buff:ClearAllPoints()
		if numBuffs == 1 then
			AuraFrameMixin:UpdateFirstButton(buff)
		elseif numBuffs > 1 and mod(numTotal, BUFFS_PER_ROW) == 1 then
			if numTotal == BUFFS_PER_ROW + 1 then
				buff:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, -BUFF_ROW_SPACING)
			else
				buff:SetPoint('TOP', aboveBuff, 'BOTTOM', 0, -BUFF_ROW_SPACING)
			end
			aboveBuff = buff
		else
			buff:SetPoint('TOPRIGHT', previousBuff, 'TOPLEFT', -5, 0)
		end
		previousBuff = buff
	end
end

function AuraFrameMixin.UpdateDeBuffsAnchor(buttonName, index)
	if type(buttonName) == "table" then
		buttonName = "DebuffButton"
	end
	buttonName = buttonName or "DebuffButton"
	index = index or 1

	local isCollapsed = AuraFrameMixin.arrow and AuraFrameMixin.arrow.collapse
	local numBuffs = isCollapsed and (BuffFrame.numEnchants or 0) or (BUFF_ACTUAL_DISPLAY + (BuffFrame.numEnchants or 0))
	local numRows = ceil(numBuffs/BUFFS_PER_ROW)
	local buffHeight = TempEnchant1 and TempEnchant1:GetHeight() or 30

	local buff = _G[buttonName..index]
	if not buff then return end
	buff:ClearAllPoints()
	if index > 1 and mod(index, BUFFS_PER_ROW) == 1 then
		buff:SetPoint('TOP', _G[buttonName..(index-BUFFS_PER_ROW)], 'BOTTOM', 0, -BUFF_ROW_SPACING);
	elseif index == 1 then
		if numRows < 2 then
			buff:SetPoint('TOPRIGHT', ConsolidatedBuffs, 'BOTTOMRIGHT', -80, -1*((2*BUFF_ROW_SPACING)+buffHeight));
		else
			buff:SetPoint('TOPRIGHT', ConsolidatedBuffs, 'BOTTOMRIGHT', -80, -numRows*(BUFF_ROW_SPACING+buffHeight));
		end
	else
		buff:SetPoint('RIGHT', _G[buttonName..(index-1)], 'LEFT', -5, 0);
	end
end

function AuraFrameMixin:UpdateCollapseAndExpandButtonAnchor()
	local arrow = CreateFrame('Button', 'CollapseAndExpandButton', _G.MinimapCluster)
	arrow:SetSize(13, 26)
	arrow:SetPoint('LEFT', TempEnchant1, 'RIGHT', 2, 0)
	arrow:SetNormalTexture''
	arrow:SetPushedTexture''
	arrow:SetHighlightTexture''
	arrow:RegisterForClicks('LeftButtonUp')

	local normal = arrow:GetNormalTexture()
	atlas(normal, 'ui-hud-aura-arrow-invert')

	local pushed = arrow:GetPushedTexture()
	atlas(pushed, 'ui-hud-aura-arrow-invert')

	local highlight = arrow:GetHighlightTexture()
	atlas(highlight, 'ui-hud-aura-arrow-invert')
	highlight:SetAlpha(.2)
	highlight:SetBlendMode('ADD')
	
	arrow.collapse = false
	arrow:SetScript('OnClick',function(self)
		self.collapse = not self.collapse
		if self.collapse then
			atlas(normal, 'ui-hud-aura-arrow')
			atlas(pushed, 'ui-hud-aura-arrow')
			atlas(highlight, 'ui-hud-aura-arrow')
			BuffFrame:Hide()
		else
			atlas(normal, 'ui-hud-aura-arrow-invert')
			atlas(pushed, 'ui-hud-aura-arrow-invert')
			atlas(highlight, 'ui-hud-aura-arrow-invert')
			BuffFrame:Show()
		end
		if AuraFrameMixin.UpdateDeBuffsAnchor then
			local debuffCount = DEBUFF_ACTUAL_DISPLAY or 16
			for i = 1, debuffCount do
				AuraFrameMixin.UpdateDeBuffsAnchor('DebuffButton', i)
			end
		end
	end)

	BuffFrame:HookScript('OnShow', function(self)
		if arrow and arrow.collapse then
			self:Hide()
		end
	end)

	self.arrow = arrow
end
AuraFrameMixin:UpdateCollapseAndExpandButtonAnchor();

function AuraFrameMixin:RefreshCollapseExpandButtonState(numBuffs)
	shown(self.arrow, numBuffs > 0);
	if self.arrow and self.arrow.collapse then
		BuffFrame:Hide()
	end
end

hooksecurefunc('BuffFrame_UpdateAllBuffAnchors', function()
	AuraFrameMixin:UpdateBuffsAnchor()
	if AuraFrameMixin.arrow and AuraFrameMixin.arrow.collapse then
		BuffFrame:Hide()
	end
end)
hooksecurefunc('DebuffButton_UpdateAnchors', AuraFrameMixin.UpdateDeBuffsAnchor)

mixin(addon._map, AuraFrameMixin);