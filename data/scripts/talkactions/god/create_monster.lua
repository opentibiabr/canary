local function createCreaturesAround(player, maxRadius, creatureName, creatureCount, creatureForge, mustBeReachable)
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
					if tile and tile:getCreatureCount() == 0 and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) and (not mustBeReachable or player:getPathTo(checkPosition)) then
						local monster = Game.createMonster(creatureName, checkPosition)
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
	player:sendCancelMessage("Only allowed monsters can be fiendish or influenced.")
end

local createMonster = TalkAction("/m")

function createMonster.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	-- Usage: "/m monstername, fiendish" for create a fiendish monster (/m rat, fiendish)
	-- Usage: "/m monstername, [1-5]" for create a influenced monster with specific level (/m rat, 2)
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
		split[2] = split[2]:gsub("^%s*(.-)$", "%1") --Trim left
		monsterCount = tonumber(split[2])
	end

	local monsterForge = nil
	if split[3] then
		split[3] = split[3]:gsub("^%s*(.-)$", "%1") --Trim left
		monsterForge = split[3]
	end
	-- Check dust level
	if monsterCount > 1 then
		createCreaturesAround(player, 20, monsterName, monsterCount, monsterForge, true)
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
