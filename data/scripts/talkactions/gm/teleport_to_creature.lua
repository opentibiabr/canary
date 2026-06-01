local teleportToCreature = TalkAction("/goto")
local lastForgeIdByPlayer = {}
local lastCreatureNameIdByPlayer = {}
local GLOBAL_GOTO_SCAN_RANGE = 5000

local function getOrderedForgeMonsters(monsterIds)
	local ordered = {}
	for _, cid in pairs(monsterIds) do
		local monster = Monster(cid)
		if monster then
			table.insert(ordered, monster)
		end
	end

	table.sort(ordered, function(a, b)
		return a:getId() < b:getId()
	end)

	return ordered
end

local function getNextForgeMonster(player, kind)
	local list = kind == "fiendish" and Game.getFiendishMonsters() or Game.getInfluencedMonsters()
	local key = string.format("%s:%s", player:getGuid(), kind)
	local monsters = getOrderedForgeMonsters(list)
	if #monsters == 0 then
		lastForgeIdByPlayer[key] = nil
		return nil
	end

	local lastId = lastForgeIdByPlayer[key] or 0
	local selected = monsters[1]
	for _, monster in ipairs(monsters) do
		if monster:getId() > lastId then
			selected = monster
			break
		end
	end

	lastForgeIdByPlayer[key] = selected:getId()
	local currentIndex = 1
	for index, monster in ipairs(monsters) do
		if monster:getId() == selected:getId() then
			currentIndex = index
			break
		end
	end
	return selected, currentIndex, #monsters
end

local function getOrderedCreaturesByName(player, creatureName)
	local ordered = {}
	local loweredName = creatureName:lower()
	local spectators = Game.getSpectators(player:getPosition(), true, false, GLOBAL_GOTO_SCAN_RANGE, GLOBAL_GOTO_SCAN_RANGE, GLOBAL_GOTO_SCAN_RANGE, GLOBAL_GOTO_SCAN_RANGE)
	for _, creature in pairs(spectators) do
		if creature and creature:getName():lower() == loweredName then
			table.insert(ordered, creature)
		end
	end

	table.sort(ordered, function(a, b)
		return a:getId() < b:getId()
	end)

	return ordered
end

local function getNextCreatureByName(player, creatureName)
	local loweredName = creatureName:lower()
	local key = string.format("%s:name:%s", player:getGuid(), loweredName)
	local creatures = getOrderedCreaturesByName(player, creatureName)
	if #creatures == 0 then
		lastCreatureNameIdByPlayer[key] = nil
		return nil
	end

	local lastId = lastCreatureNameIdByPlayer[key] or 0
	local selected = creatures[1]
	for _, creature in ipairs(creatures) do
		if creature:getId() > lastId then
			selected = creature
			break
		end
	end

	lastCreatureNameIdByPlayer[key] = selected:getId()
	local currentIndex = 1
	for index, creature in ipairs(creatures) do
		if creature:getId() == selected:getId() then
			currentIndex = index
			break
		end
	end
	return selected, currentIndex, #creatures
end

function teleportToCreature.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local loweredParam = param:lower()
	if loweredParam == "fiendish" or loweredParam == "influenced" then
		local monster, index, total = getNextForgeMonster(player, loweredParam)
		if not monster then
			player:sendCancelMessage("There are not " .. loweredParam .. " monsters right now.")
			return true
		end

		player:teleportTo(monster:getPosition())
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Teleported to %s monster %d/%d: %s.", loweredParam, index, total, monster:getName()))
		return true
	end

	local target, index, total = getNextCreatureByName(player, param)
	if target then
		player:teleportTo(target:getPosition())
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Teleported to creature %d/%d: %s.", index, total, target:getName()))
		return true
	end

	target = Creature(param)
	if target then
		player:teleportTo(target:getPosition())
	else
		player:sendCancelMessage("Creature not found.")
	end
	return true
end

teleportToCreature:separator(" ")
teleportToCreature:groupType("gamemaster")
teleportToCreature:register()
