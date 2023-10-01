local internalNpcName = "Graubart"
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
	lookHead = 25,
	lookBody = 107,
	lookLegs = 57,
	lookFeet = 114,
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

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Graubart, captain of the great SeaHawk!"})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, text = "Ah, my whole proud: My ship named SeaHawk. We rode out so many stormy nights together. I think I couldn't live without it."})
keywordHandler:addKeyword({'seahawk'}, StdModule.say, {npcHandler = npcHandler, text = "Ah, my whole proud: My ship named SeaHawk. We rode out so many stormy nights together. I think I couldn't live without it."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I'm a merchant. I sail all over the world with my ship and trade with many different races!"})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = "A merchant is someone who trades goods with other people and tries to make a little profit. *laughs*"})
keywordHandler:addKeyword({'trade'}, StdModule.say, {npcHandler = npcHandler, text = "I trade nearly everything, for example weapons, food, water, and even magic runes."})
keywordHandler:addKeyword({'races'}, StdModule.say, {npcHandler = npcHandler, text = "You know; elves, dwarfs, lizardmen, minotaurs and many others."})
keywordHandler:addKeyword({'water'}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, sold out."})
keywordHandler:addKeyword({'marlene'}, StdModule.say, {npcHandler = npcHandler, text = "Pssst. Marlene is not near right now...? You know... she is a lovely woman, but she talks too much! So I always try to keep distance from her because she can't stop talking."})
keywordHandler:addKeyword({'bruno'}, StdModule.say, {npcHandler = npcHandler, text = "Bruno is one of the best sailors I know. He is nearly as good as me. *laughs loudly*"})

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and don't forget me!")
npcHandler:setMessage(MESSAGE_GREET, "Ahoi, young man |PLAYERNAME|. Looking for work on my ship?")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
