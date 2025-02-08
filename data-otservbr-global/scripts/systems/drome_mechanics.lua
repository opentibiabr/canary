-- by arah
local generalArea = {
	from = Position(32246, 32177, 12),
	to = Position(32264, 32195, 12),
}

local mechanics = {}
local restrictedPosition = Position(32259, 32178, 12)
local activeMechanics = {}

function activateRandomMechanics()
	for _, mechanic in pairs(activeMechanics) do
		if type(mechanic) == "function" then
			mechanic("stop")
		end
	end

	activeMechanics = {}

	local keys = {}
	for key in pairs(mechanics) do
		table.insert(keys, key)
	end

	if #keys < 2 then
		return
	end

	math.randomseed(os.time())

	while true do
		local firstIndex = math.random(#keys)
		local firstKey = keys[firstIndex]
		table.remove(keys, firstIndex)

		if #keys == 0 then
			return
		end

		local secondKey = keys[math.random(#keys)]

		if
			not (
				(firstKey == "startFearMechanics" and secondKey == "startBadRootsMechanics")
				or (firstKey == "startBadRootsMechanics" and secondKey == "startFearMechanics")
				or (firstKey == "startLavaEvent" and (secondKey == "startBeamMeUpEvent" or secondKey == "startTankedUpEvent"))
				or (firstKey == "startBeamMeUpEvent" and (secondKey == "startLavaEvent" or secondKey == "startTankedUpEvent"))
				or (firstKey == "startTankedUpEvent" and (secondKey == "startLavaEvent" or secondKey == "startBeamMeUpEvent"))
			)
		then
			table.insert(activeMechanics, mechanics[firstKey])
			table.insert(activeMechanics, mechanics[secondKey])

			if type(mechanics[firstKey]) == "function" then
				mechanics[firstKey]("start")
			end
			if type(mechanics[secondKey]) == "function" then
				mechanics[secondKey]("start")
			end

			print("Activated mechanics:", firstKey, secondKey)
			break
		end

		table.insert(keys, firstKey)
	end
end

function teleportSingleMonsterToPlayer(action)
	if action == "stop" then
		return
	end

	local monstersInArea = {}
	for x = generalArea.from.x, generalArea.to.x do
		for y = generalArea.from.y, generalArea.to.y do
			local position = Position(x, y, generalArea.from.z)
			local tile = Tile(position)
			if tile then
				for _, creature in pairs(tile:getCreatures()) do
					if creature:isMonster() then
						table.insert(monstersInArea, creature)
					end
				end
			end
		end
	end

	if #monstersInArea > 0 then
		if math.random(100) <= 15 then
			local randomMonster = monstersInArea[math.random(#monstersInArea)]
			local playersInArea = {}
			local centerPosition = Position(generalArea.from.x + (rangeX / 2), generalArea.from.y + (rangeY / 2), generalArea.from.z)
			local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)

			for _, spectator in ipairs(spectators) do
				if spectator:getPosition():isInRange(generalArea.from, generalArea.to) then
					table.insert(playersInArea, spectator)
				end
			end

			if #playersInArea > 0 then
				local randomPlayer = playersInArea[math.random(#playersInArea)]
				local playerPosition = randomPlayer:getPosition()
				randomMonster:teleportTo(playerPosition)
				playerPosition:sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	end
	addEvent(teleportSingleMonsterToPlayer, 2000)
end

lavaFields = {}
function startLavaEvent(action)
	if action == "stop" then
		lavaFields = {}
		return
	end

	addEvent(function()
		placeLavaFields()
		startLavaEvent()
	end, 15000)
end

function placeLavaFields()
	if not arePlayersInArea() then
		return
	end

	lavaFields = {}
	for _ = 1, 100 do
		local position = getRandomWalkablePosition()
		if position and position ~= restrictedPosition then
			local item = Game.createItem(36927, 1, position)
			table.insert(lavaFields, { position = position, created_time = os.time() })
			addEvent(function()
				item:remove()
			end, 5000)
		end
	end

	addEvent(applyLavaDamage, 3000)
end

function applyLavaDamage()
	local current_time = os.time()
	local centerPosition = Position(generalArea.from.x + (rangeX / 2), generalArea.from.y + (rangeY / 2), generalArea.from.z)
	local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)

	for _, spectator in ipairs(spectators) do
		local player_position = spectator:getPosition()
		for _, field in ipairs(lavaFields) do
			if player_position == field.position then
				if current_time - field.created_time >= 3 then
					local damage = spectator:getHealth() * 0.6
					spectator:addHealth(-damage)
				end
			end
		end
	end
end

beamFields = {}
function startBeamMeUpEvent(action)
	if action == "stop" then
		beamFields = {}
		return
	end

	addEvent(function()
		if not arePlayersInArea() then
			return
		end

		placeBeamFields()
		startBeamMeUpEvent()
	end, 15000)
end

function placeBeamFields()
	beamFields = {}
	for _ = 1, 100 do
		local position = getRandomWalkablePosition()
		if position and position ~= restrictedPosition then
			local item = Game.createItem(36925, 1, position)
			table.insert(beamFields, { position = position, created_time = os.time() })
			addEvent(function()
				item:remove()
			end, 5000)
		end
	end
	addEvent(teleportPlayers, 1000)
end

function teleportPlayers()
	local centerPosition = Position(generalArea.from.x + (rangeX / 2), generalArea.from.y + (rangeY / 2), generalArea.from.z)
	local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)

	for _, spectator in ipairs(spectators) do
		local playerPosition = spectator:getPosition()
		for _, field in ipairs(beamFields) do
			if playerPosition == field.position then
				local randomPos = getRandomWalkablePosition()
				spectator:teleportTo(randomPos)
				break
			end
		end
	end
end

tankedUpFields = {}
function startTankedUpEvent(action)
	if action == "stop" then
		tankedUpFields = {}
		return
	end

	addEvent(function()
		placeTankedUpFields()
		startTankedUpEvent()
	end, 15000)
end

function placeTankedUpFields()
	if not arePlayersInArea() then
		return
	end

	tankedUpFields = {}
	for _ = 1, 100 do
		local position = getRandomWalkablePosition()
		if position and position ~= restrictedPosition then
			local item = Game.createItem(36926, 1, position)
			table.insert(tankedUpFields, { position = position, created_time = os.time() })
			addEvent(function()
				item:remove()
			end, 5000)
		end
	end
	addEvent(applySuperdrunkEffect, 1000)
end

function applySuperdrunkEffect()
	local centerPosition = Position(generalArea.from.x + (rangeX / 2), generalArea.from.y + (rangeY / 2), generalArea.from.z)
	local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)

	for _, spectator in ipairs(spectators) do
		local playerPosition = spectator:getPosition()
		for _, field in ipairs(tankedUpFields) do
			if playerPosition == field.position then
				local drunk = Condition(CONDITION_DRUNK)
				drunk:setParameter(CONDITION_PARAM_TICKS, 40000)
				spectator:addCondition(drunk)
				break
			end
		end
	end
end

function getRandomWalkablePosition()
	local minX, minY, maxX, maxY = generalArea.from.x, generalArea.from.y, generalArea.to.x, generalArea.to.y
	local position
	for _ = 1, 10 do
		local x = math.random(minX, maxX)
		local y = math.random(minY, maxY)
		position = Position(x, y, generalArea.from.z)
		if isWalkable(position) then
			return position
		end
	end
	return nil
end

function isWalkable(position)
	if position == restrictedPosition then
		return false
	end

	local tile = Tile(position)
	return tile and tile:isWalkable()
end

function arePlayersInArea()
	local centerPosition = Position(generalArea.from.x + (rangeX / 2), generalArea.from.y + (rangeY / 2), generalArea.from.z)
	local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)

	for _, spectator in ipairs(spectators) do
		if isInSpecArea(spectator:getPosition()) then
			return true
		end
	end
	return false
end

function isInSpecArea(position)
	return position.x >= generalArea.from.x and position.x <= generalArea.to.x and position.y >= generalArea.from.y and position.y <= generalArea.to.y and position.z == generalArea.from.z
end
-- end beam

-- Targeted Exploding Corpses Mechanic
local activeMechanic = nil
targetedExplodingCorpses = {}
function startTargetedExplodingCorpsesMechanic(action)
	if action == "stop" then
		activeMechanic = nil
		targetedExplodingCorpses = {}
		return
	elseif action == "start" then
		activeMechanic = "targeted"
	end
end

local TARGETED_DAMAGE_PERCENTAGE = 0.40
local targetedSpellArea = {
	from = Position(32246, 32177, 12),
	to = Position(32264, 32195, 12),
}

local targetedValidMonsters = {
	["Domestikion"] = true,
	["Hoodinion"] = true,
	["Mearidion"] = true,
	["Murmillion"] = true,
	["Scissorion"] = true,
}

local targetSpellPattern = {
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 2, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

local function findNearestTargetedPlayer(monsterPosition)
	local playersInArea = Game.getSpectators(monsterPosition, false, true, 8, 8, 8, 8)
	local nearestPlayer = nil
	local shortestDistance = math.huge

	for _, player in ipairs(playersInArea) do
		if player:isPlayer() then
			local distance = monsterPosition:getDistance(player:getPosition())
			if distance < shortestDistance then
				nearestPlayer = player
				shortestDistance = distance
			end
		end
	end

	return nearestPlayer
end

local function isInTargetedSpellArea(position)
	return position.x >= targetedSpellArea.from.x and position.x <= targetedSpellArea.to.x and position.y >= targetedSpellArea.from.y and position.y <= targetedSpellArea.to.y and position.z == targetedSpellArea.from.z
end

local function getTargetedAffectedPositions(centerPosition)
	local affectedPositions = {}
	local offset = math.floor(#targetSpellPattern / 2)
	for y = 1, #targetSpellPattern do
		for x = 1, #targetSpellPattern[y] do
			if targetSpellPattern[y][x] > 0 then
				local pos = Position(centerPosition.x + (x - offset - 1), centerPosition.y + (y - offset - 1), centerPosition.z)
				table.insert(affectedPositions, pos)
			end
		end
	end
	return affectedPositions
end

local function handleTargetedSpell(monster)
	local monsterPosition = monster:getPosition()

	if not isInTargetedSpellArea(monsterPosition) then
		return
	end

	local targetPlayer = findNearestTargetedPlayer(monsterPosition)
	if not targetPlayer then
		return
	end

	local targetPosition = targetPlayer:getPosition()
	for _, pos in ipairs(getTargetedAffectedPositions(targetPosition)) do
		pos:sendMagicEffect(CONST_ME_FIREAREA)
	end

	for _, pos in ipairs(getTargetedAffectedPositions(targetPosition)) do
		local playersInTile = Tile(pos):getCreatures()
		if playersInTile then
			for _, player in ipairs(playersInTile) do
				if player:isPlayer() then
					local currentHealth = player:getHealth()
					local damage = math.floor(currentHealth * TARGETED_DAMAGE_PERCENTAGE)
					player:addHealth(-damage)
				end
			end
		end
	end
end

local targetedExplodingCorpses = CreatureEvent("TargetedExplodingCorpses")

function targetedExplodingCorpses.onDeath(creature, corpse, killer, mostDamageKiller, unjustified)
	if activeMechanic ~= "targeted" then
		return false
	end
	if creature and creature:isMonster() and targetedValidMonsters[creature:getName()] then
		handleTargetedSpell(creature)
	end
	return true
end

targetedExplodingCorpses:register()

-----------------------------------separate mechanic
--explodingCorpses
explodingCorpses = {}
function startExplodingCorpsesMechanic(action)
	if action == "stop" then
		activeMechanic = nil
		explodingCorpses = {}
		return
	elseif action == "start" then
		activeMechanic = "exploding"
	end
end

local DAMAGE_PERCENTAGE = 0.25
local explosionArea = {
	from = Position(32246, 32177, 12),
	to = Position(32264, 32195, 12),
}

local validMonsters = {
	["Domestikion"] = true,
	["Hoodinion"] = true,
	["Mearidion"] = true,
	["Murmillion"] = true,
	["Scissorion"] = true,
}

local explosionPattern = {
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 2, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

local function isInExplosionArea(position)
	return position.x >= explosionArea.from.x and position.x <= explosionArea.to.x and position.y >= explosionArea.from.y and position.y <= explosionArea.to.y and position.z == explosionArea.from.z
end

local function getAffectedPositions(centerPosition)
	local affectedPositions = {}
	local offset = math.floor(#explosionPattern / 2)
	for y = 1, #explosionPattern do
		for x = 1, #explosionPattern[y] do
			if explosionPattern[y][x] > 0 then
				local pos = Position(centerPosition.x + (x - offset - 1), centerPosition.y + (y - offset - 1), centerPosition.z)
				table.insert(affectedPositions, pos)
			end
		end
	end
	return affectedPositions
end

local function showExplosionEffect(centerPosition)
	for _, pos in ipairs(getAffectedPositions(centerPosition)) do
		if isInExplosionArea(pos) then
			pos:sendMagicEffect(CONST_ME_FIREAREA)
		end
	end
end

local function handleExplosion(monster)
	local monsterPosition = monster:getPosition()

	if not isInExplosionArea(monsterPosition) then
		return
	end

	showExplosionEffect(monsterPosition)

	local affectedPositions = getAffectedPositions(monsterPosition)
	for _, pos in ipairs(affectedPositions) do
		local playersInTile = Tile(pos):getCreatures()
		if playersInTile then
			for _, player in ipairs(playersInTile) do
				if player:isPlayer() then
					local currentHealth = player:getHealth()
					local damage = math.floor(currentHealth * DAMAGE_PERCENTAGE)
					player:addHealth(-damage)
				end
			end
		end
	end
end

local explodingCorpses = CreatureEvent("ExplodingCorpses")

function explodingCorpses.onDeath(creature, corpse, killer, mostDamageKiller, unjustified)
	if activeMechanic ~= "exploding" then
		return false
	end
	if creature and creature:isMonster() and validMonsters[creature:getName()] then
		handleExplosion(creature)
	end
	return true
end

explodingCorpses:register()

------------------------------------- fear mechanic --------------------------
fearMechanic = {}
function startFearMechanics(action)
	if action == "stop" then
		fearMechanic = {}
		return
	elseif action == "start" then
		createFearAfterPlayerDetection()
	end
end

local function isTileWalkable(position)
	if position == restrictedPosition then
		return false
	end

	local tile = Tile(position)
	if not tile then
		return false
	end
	return not tile:hasFlag(TILESTATE_BLOCKSOLID) and not tile:hasFlag(TILESTATE_PROTECTIONZONE)
end

local function getRandomWalkablePosition(from, to)
	local attempts = 100
	while attempts > 0 do
		local randomX = math.random(from.x, to.x)
		local randomY = math.random(from.y, to.y)
		local position = Position(randomX, randomY, from.z)
		if isWalkable(position) and position ~= restrictedPosition then
			return position
		end
		attempts = attempts - 1
	end
	return nil
end

local function isPlayerInArea(from, to)
	for x = from.x, to.x do
		for y = from.y, to.y do
			local tile = Tile(Position(x, y, from.z))
			if tile then
				local creatures = tile:getCreatures()
				for _, creature in ipairs(creatures) do
					if creature:isPlayer() then
						return true
					end
				end
			end
		end
	end
	return false
end

local fear = { 36934, 36935 }
local playersSteppedOnItem = {}

local fearSeedStepIn = MoveEvent("fearSeedStepIn")
function fearSeedStepIn.onStepIn(creature, item, position, fromPosition)
	if item:getId() == 36934 or item:getId() == 36935 then
		if creature and creature:isPlayer() then
			item:remove()
			playersSteppedOnItem[creature:getId()] = true
		end
	end
	return true
end

fearSeedStepIn:type("stepin")
fearSeedStepIn:id(36934, 36935)
fearSeedStepIn:register()

local function applyFearConditionToPlayers(from, to)
	for x = from.x, to.x do
		for y = from.y, to.y do
			local tile = Tile(Position(x, y, from.z))
			if tile then
				local creatures = tile:getCreatures()
				for _, creature in ipairs(creatures) do
					if creature:isPlayer() then
						if not playersSteppedOnItem[creature:getId()] then
							local player = creature
							local condition = Condition(CONDITION_FEARED)
							condition:setTicks(3000)
							player:addCondition(condition)
							player:getPosition():sendMagicEffect(CONST_ME_GHOST_SMOKE)
						end
					end
				end
			end
		end
	end
end

function createFearAfterPlayerDetection()
	local spawnAreaFrom = Position(32246, 32177, 12)
	local spawnAreaTo = Position(32264, 32195, 12)

	if isPlayerInArea(spawnAreaFrom, spawnAreaTo) then
		addEvent(function()
			local position = getRandomWalkablePosition(spawnAreaFrom, spawnAreaTo)
			if position then
				local item = Game.createItem(36934, 1, position)
				if item then
					addEvent(function()
						local tile = Tile(position)
						if tile then
							local seedItem = tile:getItemById(36934)
							if seedItem then
								seedItem:remove()
								Game.createItem(36935, 1, position)
								addEvent(function()
									local tile = Tile(position)
									if tile then
										local transformedItem = tile:getItemById(36935)
										if transformedItem then
											transformedItem:remove()
										end

										applyFearConditionToPlayers(spawnAreaFrom, spawnAreaTo)
									end
								end, 6000)
							end
						end
					end, 3000)
				end
			end
		end, 20000)
	end

	addEvent(function()
		playersSteppedOnItem = {}
	end, 20000)

	addEvent(createFearAfterPlayerDetection, 20000)
end

--------------------------------------- bad roots -------------------

rootMechanic = {}
function startBadRootsMechanics(action)
	if action == "stop" then
		rootMechanic = {}
		return
	elseif action == "start" then
		createBadRootAfterPlayerDetection()
	end
end

local function isTileWalkable(position)
	if position == restrictedPosition then
		return false
	end

	local tile = Tile(position)
	if not tile then
		return false
	end
	return not tile:hasFlag(TILESTATE_BLOCKSOLID) and not tile:hasFlag(TILESTATE_PROTECTIONZONE)
end

local function getRandomWalkablePosition(from, to)
	local attempts = 100
	while attempts > 0 do
		local randomX = math.random(from.x, to.x)
		local randomY = math.random(from.y, to.y)
		local position = Position(randomX, randomY, from.z)
		if position ~= restrictedPosition and isTileWalkable(position) then
			return position
		end
		attempts = attempts - 1
	end
	return nil
end

local function isPlayerInArea(from, to)
	for x = from.x, to.x do
		for y = from.y, to.y do
			local tile = Tile(Position(x, y, from.z))
			if tile then
				local creatures = tile:getCreatures()
				for _, creature in ipairs(creatures) do
					if creature:isPlayer() then
						return true
					end
				end
			end
		end
	end
	return false
end

local eggs = { 36936, 36937 }
local playersSteppedOnItem = {}

local eggsSeedStepIn = MoveEvent("eggsSeedStepIn")
function eggsSeedStepIn.onStepIn(creature, item, position, fromPosition)
	if item:getId() == 36936 or item:getId() == 36937 then
		if creature and creature:isPlayer() then
			item:remove()
			playersSteppedOnItem[creature:getId()] = true
		end
	end
	return true
end

eggsSeedStepIn:type("stepin")
eggsSeedStepIn:id(36936, 36937)
eggsSeedStepIn:register()

local function applyRootedConditionToPlayers(from, to)
	for x = from.x, to.x do
		for y = from.y, to.y do
			local tile = Tile(Position(x, y, from.z))
			if tile then
				local creatures = tile:getCreatures()
				for _, creature in ipairs(creatures) do
					if creature:isPlayer() then
						if not playersSteppedOnItem[creature:getId()] then
							local player = creature
							local condition = Condition(CONDITION_ROOTED)
							condition:setTicks(5000)
							player:addCondition(condition)
							player:getPosition():sendMagicEffect(CONST_ME_ROOTS)
						end
					end
				end
			end
		end
	end
end

function createBadRootAfterPlayerDetection()
	local spawnAreaFrom = Position(32246, 32177, 12)
	local spawnAreaTo = Position(32264, 32195, 12)

	if isPlayerInArea(spawnAreaFrom, spawnAreaTo) then
		addEvent(function()
			local position = getRandomWalkablePosition(spawnAreaFrom, spawnAreaTo)
			if position then
				local item = Game.createItem(36936, 1, position)
				if item then
					addEvent(function()
						local tile = Tile(position)
						if tile then
							local seedItem = tile:getItemById(36936)
							if seedItem then
								seedItem:remove()
								Game.createItem(36937, 1, position)
								addEvent(function()
									local tile = Tile(position)
									if tile then
										local transformedItem = tile:getItemById(36937)
										if transformedItem then
											transformedItem:remove()
										end

										applyRootedConditionToPlayers(spawnAreaFrom, spawnAreaTo)
									end
								end, 6000)
							end
						end
					end, 3000)
				end
			end
		end, 20000)
	end

	addEvent(function()
		playersSteppedOnItem = {}
	end, 20000)

	addEvent(createBadRootAfterPlayerDetection, 20000)
end

mechanics.startFearMechanics = startFearMechanics
mechanics.startBadRootsMechanics = startBadRootsMechanics
mechanics.startExplodingCorpsesMechanic = startExplodingCorpsesMechanic
mechanics.startTargetedExplodingCorpsesMechanic = startTargetedExplodingCorpsesMechanic
mechanics.startLavaEvent = startLavaEvent
mechanics.startBeamMeUpEvent = startBeamMeUpEvent
mechanics.startTankedUpEvent = startTankedUpEvent
mechanics.teleportSingleMonsterToPlayer = teleportSingleMonsterToPlayer

-- by Arah
