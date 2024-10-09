local internalNpcName = "Jondrin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 78,
	lookBody = 25,
	lookLegs = 30,
	lookFeet = 97,
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

	if MsgContains(message, "necrometer") and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission09) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission10) < 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission09) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.OramondTaskProbing) == 1 then
		npcHandler:say({
			"A necrometer? Have you any idea how rare and expensive a necrometer is? There is no way I could justify giving a necrometer to an inexperienced adventurer. Hm, although ... if you weren't inexperienced that would be a different matter. ...",
			"Did you do any measuring task for Doubleday lately?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission10) >= 1 then
		npcHandler:say("You already got the Necrometer.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Indeed I heard you did a good job out there. <sigh> I guess that means I can hand you one of our necrometers. Handle it with care.", npc, creature)
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission10, 1)
		player:addItem(21124, 1)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
