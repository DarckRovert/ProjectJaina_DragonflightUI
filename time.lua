local addon = select(2,...);
local config = addon.config;
local map = addon._map;
local atlas = addon.SetAtlas;
local shown = addon.SetShown;
local select = select;
local format = string.format;
local max = math.max;

local GameTimeFrame = GameTimeFrame;
local CalendarGetDate = CalendarGetDate;
if (not IsAddOnLoaded('Blizzard_TimeManager')) then
    LoadAddOn('Blizzard_TimeManager')
end

function map:SetCalendarDate()
	if not config.times.calendar then
		GameTimeFrame:Hide()
		return
	end
	
	local _, _, day = CalendarGetDate();
  	-- Ensure day is at least 1 and not 0, tolerating nil during early loading
	day = (day and max(1, day)) or 1
  	local atlasFormat = "ui-hud-calendar-%d-%s"
	
	GameTimeFrame:ClearAllPoints()
	GameTimeFrame:SetSize(21, 19)
	GameTimeFrame:SetPoint('TOPRIGHT', Minimap.BorderTop, 22, -1)
	GameTimeFrame:SetHitRectInsets(0, 0, 0, 0)
	
	local fontString = GameTimeFrame:GetFontString()
	if fontString then
		fontString:Hide()
	end
	
	local normal = GameTimeFrame:GetNormalTexture();
	local pushed = GameTimeFrame:GetPushedTexture();
	local highlight = GameTimeFrame:GetHighlightTexture();
	
	if normal then atlas(normal, atlasFormat:format(day, "up")) end
	if pushed then atlas(pushed, atlasFormat:format(day, "down")) end
	if highlight then atlas(highlight, atlasFormat:format(day, "mouseover")) end
end

-- Hook GameTimeFrame_Update to prevent Blizzard's FrameXML from resetting textures and restoring font text
if GameTimeFrame_Update then
	hooksecurefunc("GameTimeFrame_Update", function()
		if map and map.SetCalendarDate then
			map:SetCalendarDate()
		end
	end)
end

-- Ensure font string remains hidden even if Blizzard calls fontString:Show() directly
local fontString = GameTimeFrame and GameTimeFrame:GetFontString()
if fontString and not fontString.__jainaHooked then
	fontString.__jainaHooked = true
	hooksecurefunc(fontString, "Show", function(self)
		self:Hide()
	end)
end

-- Cleanly hide all background/border textures of TimeManagerClockButton
for _, region in ipairs({ TimeManagerClockButton:GetRegions() }) do
	if region:IsObjectType("Texture") and region ~= TimeManagerAlarmFiredTexture then
		region:SetTexture(nil)
		region:Hide()
	end
end

TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetWidth(40)
TimeManagerClockButton:SetHeight(18)
TimeManagerClockButton:SetPoint('TOPRIGHT', Minimap.BorderTop)

TimeManagerClockTicker:SetFont(config.assets.font, config.times.clock_font_size)
TimeManagerClockTicker:SetShadowOffset(1.25, -1.25)
TimeManagerClockTicker:SetPoint('TOPRIGHT', TimeManagerClockButton, -10, -2)
shown(TimeManagerClockTicker, config.times.clock)

TimeManagerAlarmFiredTexture:SetTexture(nil)

-- Register date update listener on day transition and calendar events
local TimeDate = CreateFrame('Frame')
TimeDate:RegisterEvent('PLAYER_LOGIN')
TimeDate:RegisterEvent('CALENDAR_UPDATE_PENDING_INVITES')
TimeDate:RegisterEvent('CALENDAR_ACTION_PENDING')
TimeDate:SetScript('OnEvent', function()
	if map and map.SetCalendarDate then
		map:SetCalendarDate()
	end
end)
