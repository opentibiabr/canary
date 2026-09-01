local internalNpcName = "Hoggle"
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
	lookHead = 21,
	lookBody = 46,
	lookLegs = 88,
	lookFeet = 94,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Oh, this misery..." },
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

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my humble home!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "fisherman" }, StdModule.say, { npcHandler = npcHandler, text = "It's a very hard job, cause without a boat I have to swim and fish at the same time!" })
keywordHandler:addKeyword({ "mountain" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, there is a mountain to the north, but it's of no interest. There isn't any fish on it." })
keywordHandler:addKeyword({ "pet name" }, StdModule.say, { npcHandler = npcHandler, text = "Once there was a magician who named all his creatures like their species read backward." })
keywordHandler:addKeyword({ "mermaid" }, StdModule.say, { npcHandler = npcHandler, text = "I saw one! She had the body of a fish, and also the head of a fish. Amazing!" })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "There are stories about a city behind the mountain, but why should I go there? There is enough fish here." })
keywordHandler:addKeyword({ "stupid" }, StdModule.say, { npcHandler = npcHandler, text = "My mom always said, stupid is who stupid does." })
keywordHandler:addKeyword({ "secret" }, StdModule.say, { npcHandler = npcHandler, text = "Can you keep a secret? I think fish can't breath on land!" })
keywordHandler:addKeyword({ "finger" }, StdModule.say, { npcHandler = npcHandler, text = "No, fish don't have fingers." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "I know this city. Sometimes I sell fish to Frodo." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "He buys my fish." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Hoggle. I live in this house." })
keywordHandler:addKeyword({ "home" }, StdModule.say, { npcHandler = npcHandler, text = "I'm just a poor fisherman. Leave me alone in my misery, ok?" })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "No, this is not the time to go fishing." })
keywordHandler:addKeyword({ "boat" }, StdModule.say, { npcHandler = npcHandler, text = "My boat sunk. I thought it would be more aerodynamic with holes in it." })
keywordHandler:addKeyword({ "fish" }, StdModule.say, { npcHandler = npcHandler, text = "I think they can talk, but they are wise enough to be silent. Once I saw a mermaid." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm just a poor fisherman. Leave me alone in my misery, ok?" })
keywordHandler:addKeyword({ "map" }, StdModule.say, { npcHandler = npcHandler, text = "If you go north-west you will find Lubo and his adventurer shop. I think he sells maps." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
