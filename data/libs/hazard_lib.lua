Hazard = {
	areas = {}
}

function Hazard.new(prototype)
	local instance = {}

	instance.name = prototype.name
	instance.from = prototype.from
	instance.to = prototype.to
	instance.maxLevel = prototype.maxLevel
	instance.storageMax = prototype.storageMax
	instance.storageCurrent = prototype.storageCurrent
	instance.crit = prototype.crit
	instance.dodge = prototype.dodge
	instance.damageBoost = prototype.damageBoost

	instance.zone = Zone(instance.name)
	instance.zone:addArea(instance.from, instance.to)

	setmetatable(instance, { __index = Hazard })

	return instance
end

function Hazard:getPlayerCurrentLevel(player)
	return player:getStorageValue(self.storageCurrent) < 0 and 0 or player:getStorageValue(self.storageCurrent)
end

function Hazard:setPlayerCurrentLevel(player, level)
	local max = self:getPlayerMaxLevel(player)
	if level > max then
		return false
	end
	player:setStorageValue(self.storageCurrent, level)
	if player:getZone() == self.zone then
		player:setHazardSystemPoints(level)
	end
	return true
end

function Hazard:getPlayerMaxLevel(player)
	return player:getStorageValue(self.storageMax) < 0 and 0 or player:getStorageValue(self.storageMax)
end

function Hazard:levelUp(player)
	local current = self:getPlayerCurrentLevel(player)
	local max = self:getPlayerMaxLevel(player)
	if current == max then
		self:setPlayerMaxLevel(player, max + 1)
	end
end

function Hazard:setPlayerMaxLevel(player, level)
	if level > self.maxLevel then
		level = self.maxLevel
	end
	player:setStorageValue(self.storageMax, level)
end

function Hazard:isInZone(position)
	local zone = position:getZone()
	if not zone then return false end
	local hazard = Hazard.getByName(zone:getName())
	if not hazard then return false end
	return hazard == self
end

function Hazard:register()
	if not configManager.getBoolean(configKeys.TOGGLE_HAZARDSYSTEM) then
		return
	end

	local onEnter = EventCallback()
	local onLeave = EventCallback()

	function onEnter.zoneOnCreatureEnter(zone, creature)
		if zone ~= self.zone then return true end
		local player = creature:getPlayer()
		if not player then return true end
		player:setHazardSystemPoints(self:getPlayerCurrentLevel(player))
		return true
	end

	function onLeave.zoneOnCreatureLeave(zone, creature)
		if zone ~= self.zone then return true end
		local player = creature:getPlayer()
		if not player then return true end
		player:setHazardSystemPoints(0)
		return true
	end

	onEnter:register()
	onLeave:register()

	Hazard.areas[self.name] = self
	self.zone:register()
end

function Hazard.getByName(name)
	return Hazard.areas[name]
end

if not HazardMonster then
	HazardMonster = { eventName = 'HazardMonster' }
end

function HazardMonster.onSpawn(monster, position)
	local monsterType = monster:getType()
	if not monsterType then
		return false
	end

	local zone = position:getZone()
	if not zone then return true end
	local hazard = Hazard.getByName(zone:getName())
	if hazard then
		monster:hazard(true)
		if hazard then
			monster:hazardCrit(hazard.crit)
			monster:hazardDodge(hazard.dodge)
			monster:hazardDamageBoost(hazard.damageBoost)
		end
	end
	return true
end
