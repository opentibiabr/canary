Hazard = {
	areas = {},
}

function Hazard.new(prototype)
	local instance = {}

	instance.name = prototype.name
	instance.from = prototype.from
	instance.to = prototype.to
	instance.maxLevel = prototype.maxLevel
	instance.storageMax = prototype.storageMax ---@deprecated
	instance.storageCurrent = prototype.storageCurrent ---@deprecated
	instance.crit = prototype.crit
	instance.dodge = prototype.dodge
	instance.damageBoost = prototype.damageBoost

	instance.zone = Zone(instance.name)
	if instance.from and instance.to then
		instance.zone:addArea(instance.from, instance.to)
	end

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
	if self.storageCurrent then
		local fromStorage = player:getStorageValue(self.storageCurrent)
		return fromStorage <= 0 and 1 or fromStorage
	end
	local fromKV = player:kv():scoped(self.name):get("currentLevel") or 1
	return fromKV <= 0 and 1 or fromKV
end

function Hazard:setPlayerCurrentLevel(player, level)
	local max = self:getPlayerMaxLevel(player)
	if level > max then
		return false
	end
	if self.storageCurrent then
		player:setStorageValue(self.storageCurrent, level)
	else
		player:kv():scoped(self.name):set("currentLevel", level)
	end
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
	if self.storageMax then
		local fromStorage = player:getStorageValue(self.storageMax)
		return fromStorage <= 0 and 1 or fromStorage
	end
	local fromKV = player:kv():scoped(self.name):get("maxLevel")
	return fromKV <= 0 and 1 or fromKV
end

function Hazard:levelUp(player)
	if self.storageMax and self.storageCurrent then
		local current = self:getPlayerCurrentLevel(player)
		local max = self:getPlayerMaxLevel(player)
		if current == max then
			self:setPlayerMaxLevel(player, max + 1)
		end
		return
	end

	local current = player:kv(self.name):get("currentLevel")
	local max = player:kv(self.name):get("maxLevel")
	if current == max then
		player:kv(self.name):set("maxLevel", max + 1)
	end
end

function Hazard:setPlayerMaxLevel(player, level)
	if level > self.maxLevel then
		level = self.maxLevel
	end

	if self.storageMax then
		player:setStorageValue(self.storageMax, level)
		return
	end
	player:kv():scoped(self.name):set("maxLevel", level)
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
		logger.debug("Player {} entered hazard zone {}", player:getName(), zone:getName())
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
