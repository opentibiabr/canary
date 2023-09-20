Hazard = {
	areas = {},
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

function Hazard:getHazardPlayerAndPoints(damageMap)
	local hazardPlayer = nil
	local hazardPoints = -1
	for key, _ in pairs(damageMap) do
		local player = Player(key)
		if player then
			local playerHazardPoints = self:getPlayerCurrentLevel(player)

			if playerHazardPoints < hazardPoints or hazardPoints == -1 then
				hazardPlayer = player
				hazardPoints = playerHazardPoints
			end
		end
	end

	if hazardPoints == -1 then
		hazardPoints = 1
	end

	return hazardPlayer, hazardPoints
end

function Hazard:getPlayerCurrentLevel(player)
	local fromStorage = player:getStorageValue(self.storageCurrent)
	return fromStorage <= 0 and 1 or fromStorage
end

function Hazard:setPlayerCurrentLevel(player, level)
	local max = self:getPlayerMaxLevel(player)
	if level > max then
		return false
	end
	player:setStorageValue(self.storageCurrent, level)
	local zones = player:getZones()
	if not zones then
		return true
	end
	for _, zone in ipairs(zones) do
		local hazard = Hazard.getByName(zone:getName())
		if hazard then
			if hazard == self then
				player:setHazardSystemPoints(level)
			else
				player:setHazardSystemPoints(0)
			end
		end
	end
	return true
end

function Hazard:getPlayerMaxLevel(player)
	local fromStorage = player:getStorageValue(self.storageMax)
	return fromStorage <= 0 and 1 or fromStorage
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
	local zones = position:getZones()
	if not zones then
		return false
	end
	for _, zone in ipairs(zones) do
		local hazard = Hazard.getByName(zone:getName())
		if hazard then
			return hazard == self
		end
	end
	return false
end

function Hazard:register()
	if not configManager.getBoolean(configKeys.TOGGLE_HAZARDSYSTEM) then
		return
	end

	local event = ZoneEvent(self.zone)

	function event.afterEnter(zone, creature)
		local player = creature:getPlayer()
		if not player then
			return
		end
		player:setHazardSystemPoints(self:getPlayerCurrentLevel(player))
	end

	function event.afterLeave(zone, creature)
		local player = creature:getPlayer()
		if not player then
			return
		end
		player:setHazardSystemPoints(0)
	end

	Hazard.areas[self.name] = self
	event:register()
end

function Hazard.getByName(name)
	return Hazard.areas[name]
end

if not HazardMonster then
	HazardMonster = { eventName = "HazardMonster" }
end

function HazardMonster.onSpawn(monster, position)
	local monsterType = monster:getType()
	if not monsterType then
		return false
	end

	local zones = position:getZones()
	if not zones then
		return true
	end
	for _, zone in ipairs(zones) do
		local hazard = Hazard.getByName(zone:getName())
		if hazard then
			monster:hazard(true)
			if hazard then
				monster:hazardCrit(hazard.crit)
				monster:hazardDodge(hazard.dodge)
				monster:hazardDamageBoost(hazard.damageBoost)
			end
		end
	end
	return true
end
