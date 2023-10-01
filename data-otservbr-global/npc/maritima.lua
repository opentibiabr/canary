local internalNpcName = "Maritima"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 5811
}

npcConfig.flags = {
	floorchange = false
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

	if(MsgContains(message, "quara")) then
		if(player:getStorageValue(Storage.InServiceofYalahar.Questline) == 41 and player:getStorageValue(Storage.InServiceofYalahar.QuaraInky) < 1  and player:getStorageValue(Storage.InServiceofYalahar.QuaraSplasher) < 1 and player:getStorageValue(Storage.InServiceofYalahar.QuaraSharptooth) < 1) then
			npcHandler:say({
				"The quara in this area are a strange race that seeks for inner perfection rather than physical one. ...",
				"However, recently the quara got mad because their area is flooded with toxic sewage from the city. If you could inform someone about it, they might stop the sewage and the quara could return to their own business."
			}, npc, creature)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 42)
			player:setStorageValue(Storage.InServiceofYalahar.Mission07, 3) -- StorageValue for Questlog "Mission 07: A Fishy Mission"
			player:setStorageValue(Storage.InServiceofYalahar.QuaraState, 1)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
