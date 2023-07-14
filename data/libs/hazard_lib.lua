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

	setmetatable(instance, { __index = Hazard })

	Hazard.areas[instance.name] = instance
	return instance
end

function Hazard.createAreas()
	for _, area in pairs(Hazard.areas) do
		Game.createHazardArea(area.from, area.to)
	end
end

function Hazard.getPlayerCurrentLevel(self, player)
	return player:getStorageValue(self.storageCurrent) < 0 and 0 or player:getStorageValue(self.storageCurrent)
end

function Hazard.setPlayerCurrentLevel(self, player, level)
	local max = self:getPlayerMaxLevel(player)
	if level > max then
		return false
	end
	player:setStorageValue(self.storageCurrent, level)
	player:updateHazard()
	return true
end

function Hazard.getPlayerMaxLevel(self, player)
	return player:getStorageValue(self.storageMax) < 0 and 0 or player:getStorageValue(self.storageMax)
end

function Hazard.levelUp(self, player)
	local current = self:getPlayerCurrentLevel(player)
	local max = self:getPlayerMaxLevel(player)
	if current == max then
		self:setPlayerMaxLevel(player, max + 1)
	end
end

function Hazard.setPlayerMaxLevel(self, player, level)
	if level > self.maxLevel then
		level = self.maxLevel
	end
	player:setStorageValue(self.storageMax, level)
end

function Hazard.refresh(self, player)
	if player:getPosition():isInArea(self) then
		player:setHazardSystemPoints(self:getPlayerCurrentLevel(player))
	else
		player:setHazardSystemPoints(0)
	end
end

function Hazard.getByName(name)
	return Hazard.areas[name]
end

function Position.getHazardArea(self)
	for _, area in pairs(Hazard.areas) do
		if self.x >= area.from.x and self.y >= area.from.y and self.z >= area.from.z and self.x <= area.to.x and self.y <= area.to.y and self.z <= area.to.z then
			return area
		end
	end
	return nil
end

function Position.isInArea(self, area)
	return self.x >= area.from.x and self.y >= area.from.y and self.z >= area.from.z and self.x <= area.to.x and self.y <= area.to.y and self.z <= area.to.z
end

if not HazardMonster then
	HazardMonster = { eventName = 'HazardMonster' }
end

function HazardMonster.onSpawn(monster, position)
	local monsterType = monster:getType()
	if not monsterType then
		return false
	end

	local tile = Tile(position)
	if tile and tile:isHazard() then
		monster:hazard(true)
		local hazard = position:getHazardArea()
		if hazard then
			monster:hazardCrit(hazard.crit)
			monster:hazardDodge(hazard.dodge)
			monster:hazardDamageBoost(hazard.damageBoost)
		end
	end
	return true
end
