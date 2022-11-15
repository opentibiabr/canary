local internalNpcName = "Gelagos"
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
	lookHead = 114,
	lookBody = 91,
	lookLegs = 85,
	lookFeet = 0,
	lookAddons = 0
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

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Barbarians are stupid."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "Bronbronbronbronbron. Bronnnn!"})
keywordHandler:addKeyword({'outfit'}, StdModule.say, {npcHandler = npcHandler, text = "Can I have free outfits?"})
keywordHandler:addKeyword({'gelagos'}, StdModule.say, {npcHandler = npcHandler, text = "That's me."})
keywordHandler:addKeyword({'brother'}, StdModule.say, {npcHandler = npcHandler, text = "Ajax is even more stupid."})
keywordHandler:addKeyword({'savage'}, StdModule.say, {npcHandler = npcHandler, text = "You are as stupid as Bron."})
keywordHandler:addKeyword({'cyclops'}, StdModule.say, {npcHandler = npcHandler, text = "Any cyclops is smarter than Bron."})

npcHandler:setMessage(MESSAGE_GREET, "Hehehe.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Hope you die and lose it.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
