local addon = select(2,...);
local tinsert = table.insert;
local select, next = select, next;
addon.package = {};

function addon.package:RegisterEvents(callback, ...)
	local numParams = select('#', ...)
	assert(type(callback) == 'function', ':RegisterEvents() requires a callback function')
	for index=1, numParams do
		local event = select(index, ...)
		assert(type(event) == 'string', ':RegisterEvents() received incorrect parameter')
		
		if not self.events[event] then
			self.events[event] = {}
		end
		local isRegistered = false
		for _,module in next, self.events[event] do
			if module == callback then
				isRegistered = true
				break
			end
		end
		if not isRegistered then
			tinsert(self.events[event], callback)
			self.events:RegisterEvent(event)
		end
	end
end

function addon.package:fire_event(event, ...)
	if not self[event] then return; end
	for index=1, #self[event] do
		self[event][index](self, event, ...)
	end
end

-- addon.package.events = {}
addon.package.events = CreateFrame('Frame');
addon.package.events:SetScript('OnEvent', addon.package.fire_event);