local function createCreaturesAround(player, maxRadius, creatureName, creatureCount, creatureForge, boolForceCreate)
	local position = player:getPosition()
	local createdCount = 0
	local sendMessage = false
	local canSetFiendish, canSetInfluenced, influencedLevel = CheckDustLevel(creatureForge, player)
	for radius = 1, maxRadius do
		if createdCount >= creatureCount then
			break
		end

		local minX = position.x - radius
		local maxX = position.x + radius
		local minY = position.y - radius
		local maxY = position.y + radius
		for dx = minX, maxX do
			for dy = minY, maxY do
				if (dx == minX or dx == maxX or dy == minY or dy == maxY) and createdCount < creatureCount then
					local checkPosition = Position(dx, dy, position.z)
					local tile = Tile(checkPosition)
					if tile and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then
						local monster = Game.createMonster(creatureName, checkPosition, false, boolForceCreate)
						if monster then
							createdCount = createdCount + 1
							monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
							position:sendMagicEffect(CONST_ME_MAGIC_RED)
							if creatureForge ~= nil and monster:isForgeable() then
								local monsterType = monster:getType()
								if canSetFiendish then
									SetFiendish(monsterType, position, player, monster)
								end
								if canSetInfluenced then
									SetInfluenced(monsterType, monster, player, influencedLevel)
								end
							elseif notSendMessage then
								sendMessage = true
							end
						end
					end
				end
			end
		end
	end
	if sendMessage == true then
		player:sendCancelMessage("Only allowed monsters can be fiendish or influenced.")
	end

	logger.info("Player {} created '{}' monsters", player:getName(), createdCount)
end

local createMonster = TalkAction("/m")

-- @function createMonster.onSay
-- @desc TalkAction to create monsters with multiple options.
-- @param player: The player executing the command.
-- @param words: Command words.
-- @param param: String containing the command parameters.
-- Format: "/m monstername, monstercount, [fiendish/influenced level], spawnRadius, [forceCreate]"
-- Example: "/m rat, 10, fiendish, 5, true"
-- @param: the last param is by default "false", if add "," or any value it's set to true
-- @return true if the command is executed successfully, false otherwise.
function createMonster.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)
	if param == "" then
		player:sendCancelMessage("Monster name param required.")
		logger.error("[createMonster.onSay] - Monster name param not found.")
		return true
	end

	local position = player:getPosition()

	local split = param:split(",")
	local monsterName = split[1]
	local monsterCount = 0
	if split[2] then
		split[2] = split[2]:trimSpace()
		monsterCount = tonumber(split[2])
	end

	local monsterForge = nil
	if split[3] then
		split[3] = split[3]:trimSpace()
		monsterForge = split[3]
	end

	if monsterCount > 1 then
		local spawnRadius = 5
		if split[4] then
			split[4] = split[4]:trimSpace()
			spawnRadius = split[4]
			print(spawnRadius)
		end

		local forceCreate = false
		if split[5] then
			forceCreate = true
		end

		createCreaturesAround(player, spawnRadius, monsterName, monsterCount, monsterForge, forceCreate)
		return true
	end

	local monster = Game.createMonster(monsterName, position)
	if monster then
		local canSetFiendish, canSetInfluenced, influencedLevel = CheckDustLevel(monsterForge, player)
		monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
		if monsterForge ~= nil and not monster:isForgeable() then
			player:sendCancelMessage("Only allowed monsters can be fiendish or influenced.")
			return true
		end

		local monsterType = monster:getType()
		if canSetFiendish then
			SetFiendish(monsterType, position, player, monster)
		end
		if canSetInfluenced then
			SetInfluenced(monsterType, monster, player, influencedLevel)
		end
	else
		player:sendCancelMessage("There is not enough room.")
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

createMonster:separator(" ")
createMonster:groupType("god")
createMonster:register()

----------------- Rename monster name -----------------
local setMonsterName = TalkAction("/setmonstername")

-- @function setMonsterName.onSay
-- @desc TalkAction to rename nearby monsters within a radius of 4 sqm.
-- Format: "/setmonstername newName"
function setMonsterName.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	local monsterNewName = split[1]

	local spectators, spectator = Game.getSpectators(player:getPosition(), false, false, 4, 4, 4, 4)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:setName(monsterNewName)
		end
	end

	return true
end

setMonsterName:separator(" ")
setMonsterName:groupType("god")
setMonsterName:register()
