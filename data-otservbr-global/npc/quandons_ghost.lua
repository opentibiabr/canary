local internalNpcName = "Quandons Ghost"
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
	lookHead = 85,
	lookBody = 9,
	lookLegs = 85,
	lookFeet = 9,
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
	local playerId = player:getId()

	if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission15) == 3 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission16) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, {
			"He murdered me. I shouldn't have trusted him! The money! All that money blinded me! To the east I brought his stuff. In night and darkness, covered by some kind of magic of his. The minotaurs did not bother us, like he promised. ...",
			"His ... his true name is Shargon and he is a priest of some kind. He belongs to a powerful secret society and is looking for something on their behalves. ...",
			"We brought his stuff to a hideout, I'll mark it on your map! The things that I've seen there! Horrible, horrible things! I fled, but he found me, killed me. He murdered me!",
		})
		player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission16, 1)
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hi!")
	end

	return true
end

local function creatureSayCallback(npc, creature, type, message) end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
