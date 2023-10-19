local defaultPeriod = "30s"

if SpawnZone then
	for _, spawnZone in pairs(SpawnZone.registry) do
		spawnZone:unregister()
	end
	SpawnZone.registry = {}
else
	SpawnZone = {
		registry = {},
	}
end

local SpawnMonster = {}
setmetatable(SpawnMonster, {
	---@param self SpawnMonster
	---@param zone SpawnZone
	---@param pos Position
	---@param period string
	__call = function(self, zone, pos, period)
		return setmetatable({
			zone = zone,
			pos = Position(pos),
			lastCheck = 0,
			monsterId = 0,
			period = ParseDuration(period) / 1000,
		}, { __index = SpawnMonster })
	end,
})

function SpawnMonster:isAlive()
	if self.monsterId == 0 then
		return false
	end
	local monster = Monster(self.monsterId)
	return monster ~= nil
end

function SpawnMonster:canSpawn()
	if self:isAlive() then
		self.lastCheck = os.time()
		return false
	end
	if os.time() - self.lastCheck < self.period then
		return false
	end
	return true
end

function SpawnMonster:spawn()
	if not self:canSpawn() then
		return
	end
	local monsterName = self.zone:randomMonster()
	if not monsterName then
		return
	end
	self.lastCheck = os.time()
	for i = 1, 3 do
		addEvent(function(position)
			position:sendMagicEffect(CONST_ME_TELEPORT)
		end, i * 1000, self.pos)
	end
	addEvent(function(monsterName, position)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		local monster = Game.createMonster(monsterName, position)
		if monster then
			self.monsterId = monster:getId()
		else
			self.zone:removeSpawn(self)
		end
	end, 4000, monsterName, self.pos)
end

setmetatable(SpawnZone, {
	---@param self SpawnZone
	---@param name string
	__call = function(self, name)
		return setmetatable({
			zoneName = name,
			monstersPerCluster = { 3, 5 },
			clusterRadius = { 2, 5 },
			clusterSpacing = { 7, 12 },
			period = defaultPeriod,
			outlierChance = 0,
			monsters = {},
			occupiedPositions = {},
			spawns = {},
		}, { __index = SpawnZone })
	end,
})

function SpawnZone:setPeriod(period)
	self.period = period
end

function SpawnZone:setOutlierChance(chance)
	self.outlierChance = chance
end

function SpawnZone:setMonstersPerCluster(min, max)
	self.monstersPerCluster = { min, max }
end

function SpawnZone:setClusterRadius(min, max)
	self.clusterRadius = { min, max }
end

function SpawnZone:setClusterSpacing(min, max)
	self.clusterSpacing = { min, max }
end

function SpawnZone:configureMonster(monsterName, likelihood)
	self.monsters[monsterName] = likelihood
end

function SpawnZone:zone()
	return Zone.getByName(self.zoneName)
end

function SpawnZone:register()
	addEvent(function(spawnZone)
		local zone = spawnZone:zone()
		if not zone then
			spawnZone:register()
			return
		end
		spawnZone:doRegister()
	end, 2000, self)
end

function SpawnZone:doRegister()
	SpawnZone.registry[self.zoneName] = self
	local zone = self:zone()
	local startTime = os.clock()
	logger.debug("Registering spawn zone {}", zone:getName())
	self.occupiedPositions = {}
	self.spawns = {}
	local positions = zone:getPositions()
	if #positions == 0 then
		logger.error("Zone:randomPosition() - Zone {} has no positions", self:getName())
		return nil
	end
	local randomStart = math.random(1, #positions)
	for attempt = 0, 2 do
		local added = 0
		for i = 1, #positions do
			local pos = positions[(randomStart + i) % #positions + 1]
			local tile = pos:getTile()
			if SpawnZone.canUseTile(tile) then
				local spacing = math.random(self.clusterSpacing[1], self.clusterSpacing[2])
				local radius = math.random(self.clusterRadius[1] - attempt, self.clusterRadius[2])
				if self:isValidClusterCenter(pos, radius) then
					local monsterCount = math.random(self.monstersPerCluster[1] - attempt, self.monstersPerCluster[2] - attempt)
					local monsterPositions = self:generateMonsterPositions(pos, radius, monsterCount)
					for _, position in ipairs(monsterPositions) do
						table.insert(self.spawns, SpawnMonster(self, position, self.period))
					end
					self:markRestrictedArea(pos, spacing)
					added = added + 1
				end
			end
		end
	end

	for _, pos in ipairs(positions) do
		if not self.occupiedPositions[pos:toString()] and math.random(0, 100 * 100) < self.outlierChance * 100 then
			table.insert(self.spawns, SpawnMonster(self, pos, self.period))
		end
	end

	logger.debug("Registered spawn zone {} in {}s", zone:getName(), os.clock() - startTime)

	self.event = addEvent(function()
		self:spawnMonsters()
	end, 1000, self)
end

function SpawnZone:unregister()
	logger.debug("Unregistering spawn zone {}", self.zoneName)
	stopEvent(self.event)
	self:zone():removeMonsters()
end

-- private

function SpawnZone:markRestrictedArea(pos, spacing)
	for dx = -spacing, spacing do
		for dy = -spacing, spacing do
			local markPos = Position({ x = pos.x + dx, y = pos.y + dy, z = pos.z })
			self.occupiedPositions[markPos:toString()] = true
		end
	end
end

function SpawnZone:isValidClusterCenter(center, radius)
	for dx = -radius, radius do
		for dy = -radius, radius do
			if dx * dx + dy * dy <= radius * radius then
				local pos = Position({ x = center.x + dx, y = center.y + dy, z = center.z })
				if self.occupiedPositions[pos:toString()] then
					return false
				end
				local tile = Tile(pos)
				if not SpawnZone.canUseTile(tile) then
					return false
				end
			end
		end
	end
	return true
end

function SpawnZone:generateMonsterPositions(center, radius, numMonsters)
	local monsterPositions = {}
	while #monsterPositions < numMonsters do
		local angle = 2 * math.pi * math.random()
		local distance = radius * math.sqrt(math.random())
		local dx = math.floor(distance * math.cos(angle))
		local dy = math.floor(distance * math.sin(angle))

		local newPos = { x = center.x + dx, y = center.y + dy, z = center.z }
		local tile = Tile(newPos)
		if SpawnZone.canUseTile(tile) then
			table.insert(monsterPositions, newPos)
		end
	end
	return monsterPositions
end

function SpawnZone:randomMonster()
	local totalLikelihood = 0
	for _, likelihood in pairs(self.monsters) do
		totalLikelihood = totalLikelihood + likelihood
	end

	local random = math.random() * totalLikelihood
	local cumulative = 0
	for monsterName, likelihood in pairs(self.monsters) do
		cumulative = cumulative + likelihood
		if random <= cumulative then
			return monsterName
		end
	end

	return nil
end

function SpawnZone:spawnMonsters()
	local zone = self:zone()
	stopEvent(self.event)
	for _, spawn in ipairs(self.spawns) do
		spawn:spawn()
	end
	self.event = addEvent(function()
		self:spawnMonsters()
	end, 2000, self)
end

function SpawnZone:removeSpawn(spawn)
	for i, s in ipairs(self.spawns) do
		if s == spawn then
			table.remove(self.spawns, i)
			return
		end
	end
end

function SpawnZone.canUseTile(tile)
	if not tile then
		return false
	end
	if not tile:isWalkable(true, true, true, true, true) then
		return false
	end
	return true
end
