local internalNpcName = "Hal"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 58,
	lookBody = 43,
	lookLegs = 38,
	lookFeet = 76,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "report") then
		if player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 8 or player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) == 12 then
			npcHandler:say("Hicks! I... I... <he is obviously drunk and his report more than confusing>. ", npc, creature)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline) + 1)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission02, player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission02) + 1) -- StorageValue for Questlog "Mission 02: Watching the Watchmen"
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "pass") then
		npcHandler:say("You can {pass} either to the {Arena Quarter} or {Alchemist Quarter}. Which one will it be?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "arena") then
		if npcHandler:getTopic(playerId) == 1 then
			local destination = Position(32688, 31193, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "alchemist") then
		if npcHandler:getTopic(playerId) == 1 then
			local destination = Position(32688, 31188, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
