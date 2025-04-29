local function createCreaturesAround(player, maxRadius, creatureName, creatureCount, creatureForge, forceCreateMonsters)
	local playerPosition = player:getPosition()
	local createdCreatureCount = 0
	local sendMessage = false
	local canSetFiendish, canSetInfluenced, influencedLevel = CheckDustLevel(creatureForge, player)

	for radius = 1, maxRadius do
		if createdCreatureCount >= creatureCount then
			break
		end

		local minX, maxX = playerPosition.x - radius, playerPosition.x + radius
		local minY, maxY = playerPosition.y - radius, playerPosition.y + radius
		for dx = minX, maxX do
			for dy = minY, maxY do
				if (dx == minX or dx == maxX or dy == minY or dy == maxY) and createdCreatureCount < creatureCount then
					local checkPosition = Position(dx, dy, playerPosition.z)
					local tile = Tile(checkPosition)
					if tile and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then
						local monster = Game.createMonster(creatureName, checkPosition, false, forceCreateMonsters)
						if monster then
							createdCreatureCount = createdCreatureCount + 1
							monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
							playerPosition:sendMagicEffect(CONST_ME_MAGIC_RED)

							if creatureForge and monster:isForgeable() then
								local monsterType = monster:getType()
								if canSetFiendish then
									SetFiendish(monsterType, playerPosition, player, monster)
								end

								if canSetInfluenced then
									SetInfluenced(monsterType, monster, player, influencedLevel)
								end
							elseif not sendMessage then
								sendMessage = true
							end
						end
					end
				end
			end
		end
	end

	if sendMessage then
		player:sendCancelMessage("Only allowed monsters can be fiendish or influenced.")
	end
end

local createMonster = TalkAction("/m")

function createMonster.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Monster name param required.")
		return true
	end

	local playerPosition = player:getPosition()
	local splitParams = param:split(",")
	local monsterName = splitParams[1]
	local monsterCount = tonumber(splitParams[2] or 1)
	local monsterForge = splitParams[3] and splitParams[3]:trimSpace() or nil
	local spawnRadius = tonumber(splitParams[4] or 5)
	local forceCreate = splitParams[5] and true or false

	if monsterCount > 1 then
		createCreaturesAround(player, spawnRadius, monsterName, monsterCount, monsterForge, forceCreate)
		return true
	end

	local monster = Game.createMonster(monsterName, playerPosition)
	if monster then
		local canSetFiendish, canSetInfluenced, influencedLevel = CheckDustLevel(monsterForge, player)
		monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		playerPosition:sendMagicEffect(CONST_ME_MAGIC_RED)

		if monsterForge and not monster:isForgeable() then
			player:sendCancelMessage("Only allowed monsters can be fiendish or influenced.")
			return true
		end

		local monsterType = monster:getType()
		if canSetFiendish then
			SetFiendish(monsterType, playerPosition, player, monster)
		end

		if canSetInfluenced then
			SetInfluenced(monsterType, monster, player, influencedLevel)
		end
	else
		player:sendCancelMessage("There is not enough room.")
		playerPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

createMonster:separator(" ")
createMonster:groupType("god")
createMonster:register()

local setMonsterName = TalkAction("/setmonstername")

function setMonsterName.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local splitParams = param:split(",")
	local newMonsterName = splitParams[1]
	local spectators, spectator = Game.getSpectators(player:getPosition(), false, false, 4, 4, 4, 4)

	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:setName(newMonsterName)
		end
	end
	return true
end

setMonsterName:separator(" ")
setMonsterName:groupType("god")
setMonsterName:register()
