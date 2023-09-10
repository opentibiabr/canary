local internalNpcName = "Captain Jack Rat"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1346,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
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

local function greetCallback(npc, creature)
	local player = Player(creature)

	if player:getStorageValue(Storage.Quest.U12_60.APiratesTail.TentuglyKilled) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Hail, pirat! Come on board to go home! Welcome on board of the ship Flying Bat. Should I set {sail}s?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "...")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "sail") and player:getStorageValue(Storage.Quest.U12_60.APiratesTail.TentuglyKilled) == 1 then
		npcHandler:say("There are two different routes. The dangerous one will be available once a day and it is likely that a seemonster will attack the ship once again. And a {safe} route that we can take directly there.", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "safe") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Do you want to take the safe route?", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			creature:teleportTo(Position(33839, 31222, 5))
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
