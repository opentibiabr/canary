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

function Zone:randomPosition()
	local positions = self:getPositions()
	if #positions == 0 then
		logger.error("Zone:randomPosition() - Zone {} has no positions", self:getName())
		return nil
	end
	local destination = positions[math.random(1, #positions)]
	local tile = destination:getTile()
	while not tile or not tile:isWalkable(false, false, false, false, true) do
		destination = positions[math.random(1, #positions)]
		tile = destination:getTile()
	end
	return destination
end

function Zone:sendTextMessage(...)
	local players = self:getPlayers()
	for _, player in ipairs(players) do
		player:sendTextMessage(...)
	end
end

function Zone:countMonsters(name)
	local count = 0
	for _, monster in ipairs(self:getMonsters()) do
		if not name or monster:getName():lower() == name:lower() then
			count = count + 1
		end
	end
	return count
end

function Zone:getMonstersByName(name)
	local monsters = {}
	for _, monster in ipairs(self:getMonsters()) do
		if monster:getName():lower() == name:lower() then
			table.insert(monsters, monster)
		end
	end
	return monsters
end

function Zone:countPlayers(notFlag)
	local players = self:getPlayers()
	local count = 0
	for _, player in ipairs(players) do
		if notFlag then
			if not player:hasGroupFlag(notFlag) then
				count = count + 1
			end
		else
			count = count + 1
		end
	end
	return count
end

function Zone:isInZone(position)
	local zones = position:getZones()
	if not zones then
		return false
	end
	for _, zone in ipairs(zones) do
		if zone == self then
			return true
		end
	end
	return false
end

---@class ZoneEvent
---@field public zone Zone
---@field public beforeEnter function
---@field public beforeLeave function
---@field public afterEnter function
---@field public afterLeave function
---@field public onSpawn function
ZoneEvent = {}

setmetatable(ZoneEvent, {
	---@param zone Zone
	__call = function(self, zone)
		local obj = {}
		setmetatable(obj, { __index = ZoneEvent })
		obj.zone = zone
		return obj
	end,
})

function ZoneEvent:register()
	if self.beforeEnter then
		local beforeEnter = EventCallback()
		function beforeEnter.zoneBeforeCreatureEnter(zone, creature)
			if zone ~= self.zone then
				return true
			end
			return self.beforeEnter(zone, creature)
		end

		beforeEnter:register()
	end

	if self.beforeLeave then
		local beforeLeave = EventCallback()
		function beforeLeave.zoneBeforeCreatureLeave(zone, creature)
			if zone ~= self.zone then
				return true
			end
			return self.beforeLeave(zone, creature)
		end

		beforeLeave:register()
	end

	if self.afterEnter then
		local afterEnter = EventCallback()
		function afterEnter.zoneAfterCreatureEnter(zone, creature)
			if zone ~= self.zone then
				return true
			end
			self.afterEnter(zone, creature)
		end

		afterEnter:register()
	end

	if self.afterLeave then
		local afterLeave = EventCallback()
		function afterLeave.zoneAfterCreatureLeave(zone, creature)
			if zone ~= self.zone then
				return true
			end
			self.afterLeave(zone, creature)
		end

		afterLeave:register()
	end

	if self.onSpawn then
		local afterEnter = EventCallback()
		function afterEnter.zoneAfterCreatureEnter(zone, creature)
			if zone ~= self.zone then
				return true
			end
			local monster = creature:getMonster()
			if not monster then
				return true
			end
			self.onSpawn(monster, monster:getPosition())
		end

		afterEnter:register()
	end
end

function Zone:blockFamiliars()
	local event = ZoneEvent(self)
	function event.beforeEnter(_zone, creature)
		local monster = creature:getMonster()
		return not (monster and monster:getMaster() and monster:getMaster():isPlayer())
	end

	event:register()
end

function Zone:trapMonsters()
	local event = ZoneEvent(self)
	function event.beforeLeave(_zone, creature)
		local monster = creature:getMonster()
		return not monster
	end

	event:register()
end

function Zone:monsterIcon(category, icon, count)
	local event = ZoneEvent(self)
	function event.afterEnter(_zone, creature)
		if not creature:isMonster() then
			return
		end
		creature:setIcon(category, icon, count)
	end

	event:register()
end
