local internalNpcName = "Lea"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 138,
	lookHead = 59,
	lookBody = 95,
	lookLegs = 113,
	lookFeet = 113,
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

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the archsorcerer of Carlin. I keep the secrets of our order."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Lea."})
--keywordHandler:addKeyword({'spell'}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, I only sell spells to sorcerers."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Time is a force we sorcerers will master one day."})
keywordHandler:addKeyword({'sorcerer'}, StdModule.say, {npcHandler = npcHandler, text = "Any sorcerer dedicates his whole life to the study of the arcane arts."})
keywordHandler:addKeyword({'power'}, StdModule.say, {npcHandler = npcHandler, text = "We sorcerers wield arcane powers beyond comprehension of men."})
keywordHandler:addKeyword({'arcane'}, StdModule.say, {npcHandler = npcHandler, text = "We sorcerers wield arcane powers beyond comprehension of men."})

npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care on your journeys.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
