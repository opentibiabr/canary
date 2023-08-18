---@class Zone
---@method getName
---@method addArea
---@method getPositions
---@method getTiles
---@method getCreatures
---@method getPlayers
---@method getMonsters
---@method getNpcs
---@method getItems

---@class ZoneEvent
---@field public zone Zone
---@field public onEnter function
---@field public onLeave function
ZoneEvent = {}

setmetatable(ZoneEvent, {
	---@param zone Zone
	__call = function(self, zone)
		local obj = {}
		setmetatable(obj, {__index = ZoneEvent})
		obj.zone = zone
		obj.onEnter = nil
		obj.onLeave = nil
		return obj
end})


function ZoneEvent:register()
	if self.onEnter then
		local onEnter = EventCallback()
		function onEnter.zoneOnCreatureEnter(zone, creature)
			if zone ~= self.zone then return true end
			return self.onEnter(zone, creature)
		end
		onEnter:register()
	end

	if self.onLeave then
		local onLeave = EventCallback()
		function onLeave.zoneOnCreatureLeave(zone, creature)
			if zone ~= self.zone then return true end
			return self.onLeave(zone, creature)
		end
		onLeave:register()
	end
end
