local internalNpcName = "Palomino"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 116,
	lookBody = 39,
	lookLegs = 12,
	lookFeet = 97,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local RAID_STORAGE = 120226
local waveEvent = nil

local raidAreas = {
	{ from = Position(32456, 32193, 7), to = Position(32491, 32261, 7) },
	{ from = Position(32431, 32240, 7), to = Position(32464, 32280, 7) },
}

local stableAreaPalomino = {
	from = Position(32437, 32230, 7),
	to = Position(32448, 32239, 7),
}

local stableAreaAppaloosa = {
	from = Position(32846, 32114, 7),
	to = Position(32850, 32120, 7),
}

local function removeStableHorses()
	for x = stableAreaPalomino.from.x, stableAreaPalomino.to.x do
		for y = stableAreaPalomino.from.y, stableAreaPalomino.to.y do
			local tile = Tile(Position(x, y, stableAreaPalomino.from.z))
			if tile then
				local creatures = tile:getCreatures()
				if creatures then
					for _, creature in ipairs(creatures) do
						local monster = Monster(creature)
						if monster and (monster:getName() == "Horse" or monster:getName() == "Grey Horse" or monster:getName() == "Brown Horse") then
							monster:remove()
						end
					end
				end
			end
		end
	end

	for x = stableAreaAppaloosa.from.x, stableAreaAppaloosa.to.x do
		for y = stableAreaAppaloosa.from.y, stableAreaAppaloosa.to.y do
			local tile = Tile(Position(x, y, stableAreaAppaloosa.from.z))
			if tile then
				local creatures = tile:getCreatures()
				if creatures then
					for _, creature in ipairs(creatures) do
						local monster = Monster(creature)
						if monster and (monster:getName() == "Horse" or monster:getName() == "Grey Horse" or monster:getName() == "Brown Horse") then
							monster:remove()
						end
					end
				end
			end
		end
	end
end

local function spawnRaidHorses()
	local raidEndTime = Game.getStorageValue(RAID_STORAGE) or 0

	if raidEndTime <= os.time() then
		if waveEvent then
			stopEvent(waveEvent)
			waveEvent = nil
		end
		return
	end

	for _, area in ipairs(raidAreas) do
		for i = 1, 3 do
			local x1 = math.random(area.from.x, area.to.x)
			local y1 = math.random(area.from.y, area.to.y)
			Game.createMonster("Wild Horse", Position(x1, y1, area.from.z), true, true)

			local x2 = math.random(area.from.x, area.to.x)
			local y2 = math.random(area.from.y, area.to.y)
			Game.createMonster("Horse", Position(x2, y2, area.from.z), true, true)

			local x3 = math.random(area.from.x, area.to.x)
			local y3 = math.random(area.from.y, area.to.y)
			Game.createMonster("Grey Horse", Position(x3, y3, area.from.z), true, true)

			local x4 = math.random(area.from.x, area.to.x)
			local y4 = math.random(area.from.y, area.to.y)
			Game.createMonster("Brown Horse", Position(x4, y4, area.from.z), true, true)
		end
	end

	waveEvent = addEvent(function()
		spawnRaidHorses()
	end, 3 * 60 * 60 * 1000)
end

local function tryStartWildHorsesRaid()
	local currentTime = os.time()
	local raidEndTime = Game.getStorageValue(RAID_STORAGE) or 0

	if raidEndTime > currentTime then
		return false
	end

	local random = math.random(10)
	if random <= 3 then
		if waveEvent then
			stopEvent(waveEvent)
			waveEvent = nil
		end

		Game.setStorageValue(RAID_STORAGE, currentTime + 86400)
		removeStableHorses()
		spawnRaidHorses()

		return true
	end

	return false
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "transport") then
		local raidEndTime = Game.getStorageValue(RAID_STORAGE) or 0
		if raidEndTime > os.time() then
			npcHandler:say("Right now our horses are on the loose. As long as not enough horses are chased back into the barn there is no horse transport service.", npc, creature)
			return true
		end
		npcHandler:say("We can bring you to Venore with one of our coaches for 125 gold. Are you interested?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif table.contains({ "rent", "horses" }, message) then
		local raidEndTime = Game.getStorageValue(RAID_STORAGE) or 0
		if raidEndTime > os.time() then
			npcHandler:say("Right now our horses are on the loose. As long as not enough horses are chased back into the barn there are no horses to rent.", npc, creature)
			return true
		end

		npcHandler:say("Do you want to rent a horse for one day at a price of 500 gold?", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "yes") then
		local player = Player(creature)
		if npcHandler:getTopic(playerId) == 1 then
			if player:isPzLocked() then
				npcHandler:say("First get rid of those blood stains!", npc, creature)
				return true
			end

			if not player:removeMoneyBank(125) then
				npcHandler:say("You don't have enough money.", npc, creature)
				return true
			end

			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			local destination = Position(32850, 32124, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:say("Have a nice trip!", npc, creature)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.Quest.U9_1.HorseStationWorldChange.Timer) >= os.time() then
				npcHandler:say("You already have a horse.", npc, creature)
				return true
			end

			if not player:removeMoneyBank(500) then
				npcHandler:say("You do not have enough money to rent a horse!", npc, creature)
				return true
			end

			local mountId = { 22, 25, 26 }
			local selectedMount = mountId[math.random(#mountId)]
			player:addMount(selectedMount)
			player:setStorageValue(Storage.Quest.U9_1.HorseStationWorldChange.Timer, os.time() + 86400)
			player:addAchievement("Natural Born Cowboy")
			tryStartWildHorsesRaid()
			npcHandler:say("I'll give you one of our experienced ones. Take care! Look out for low hanging branches.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) > 0 then
		npcHandler:say("Then not.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Salutations, |PLAYERNAME| I guess you are here for the {horses}.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
