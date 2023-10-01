local internalNpcName = "Nina"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 152,
	lookHead = 114,
	lookBody = 95,
	lookLegs = 95,
	lookFeet = 95,
	lookAddons = 3
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

keywordHandler:addKeyword({'chosen'}, StdModule.say, {npcHandler = npcHandler, text = "The lizards here are the chosen ones of their kind. We believe them to be the strongest warriors in these lands.So I lead my people here to learn their ways. We are mere assassins but they are using foreign techniques and seem to be far more efficient"})
keywordHandler:addAliasKeyword({'lizard'})
keywordHandler:addKeyword({'fire dragon dojo'}, StdModule.say, {npcHandler = npcHandler, text = "We of the Grey Shadow clan are studying the ways of the Chosen. Our training is hard, encounters with the lizards often deadly. Every one of us fights on his own. Each one more deadly than the other. Under my lead we wil rise renewed, as the Shadow Nina."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am Nina, leader of the Grey Shadow clan. Me and my followers, the Shadow Nina, are exploring the largely uncharted parts of the continent Zao."})
keywordHandler:addAliasKeyword({'shadow nina'})
keywordHandler:addAliasKeyword({'nina'})
keywordHandler:addAliasKeyword({'grey shadow clan'})

npcHandler:setMessage(MESSAGE_GREET, "Beware, if you go any further you will have to fight a large group of Chosen. This place is called the Fire Dragon Dojo. Tread carefully since these are lizard training grounds.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye. Human. Being!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Goodbye. Human. Being!")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
