local internalNpcName = "Robin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 77,
	lookBody = 118,
	lookLegs = 118,
	lookFeet = 115,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

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

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "harkath bloodblade" }, StdModule.say, { npcHandler = npcHandler, text = "Another one of a few friends of my youth who's still left." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "A misguided follower of evil." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "I don't like swords in general." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "I meet him often at Frodo's. He's a fine fellow, but he always tells me the same stories because he forgets that he already told them to me." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "I am his Master of the Hunt as I was his father's Master of the Hunt." })
keywordHandler:addKeyword({ "mcronald" }, StdModule.say, { npcHandler = npcHandler, text = "The farmers are fine fellows." })
keywordHandler:addKeyword({ "sorcerer" }, StdModule.say, { npcHandler = npcHandler, text = "These mages still give me shivers. I remember the first time this Ferumbras guy showed his ugly face here." })
keywordHandler:addKeyword({ "visitor" }, StdModule.say, { npcHandler = npcHandler, text = "I am the Chief Huntsman of Thais." })
keywordHandler:addKeyword({ "formula" }, StdModule.say, { npcHandler = npcHandler, text = "Hum? No, he never told me anything like that." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "My buddy Quentin is getting old, too. Things were different in our youth." })
keywordHandler:addKeyword({ "general" }, StdModule.say, { npcHandler = npcHandler, text = "These kids call themselves an army... In the old times we had a REAL army, I tell ya..." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "These mages still give me shivers. I remember the first time this Ferumbras guy showed his ugly face here." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "Druids have their ways with nature, but they would rather cuddle a bear than hunt it." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "Can you imagine this youngster handling a guild? Ah, come on." })
keywordHandler:addKeyword({ "sherry" }, StdModule.say, { npcHandler = npcHandler, text = "The farmers are fine fellows." })
keywordHandler:addKeyword({ "baxter" }, StdModule.say, { npcHandler = npcHandler, text = "I hardly know him." })
keywordHandler:addKeyword({ "oswald" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, what a charming young man. He's often here asking me about my youth and the people I met in my life." })
keywordHandler:addKeyword({ "crunor" }, StdModule.say, { npcHandler = npcHandler, text = "Crunor gives and takes. That is his way. As long as we don't hunt more than we need, we are at balance with Crunor." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, I love that hut. I liked it as it was Iwan's hut, I loved it as it was Pridence's hut, and I think I will never stop to love this place." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "A master, or better mistress, of the bow. But with her big feet she just chases all game away." })
keywordHandler:addKeyword({ "lugri" }, StdModule.say, { npcHandler = npcHandler, text = "Can you imagine his father was such a fine guy? A shame what his son has become." })
keywordHandler:addKeyword({ "lynda" }, StdModule.say, { npcHandler = npcHandler, text = "So young and so beautiful! She makes even an old man as me... um... feel a bit younger again." })
keywordHandler:addKeyword({ "druid" }, StdModule.say, { npcHandler = npcHandler, text = "Druids have their ways with nature, but they would rather cuddle a bear than hunt it." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "I am his Master of the Hunt as I was his father's Master of the Hunt." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "Such guys don't live long. The grandfather of our king had a new jester every season." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "Sells a lot of useful stuff, that guy. I remember the days when we were so poor that we could not afford anything the former owner offered." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "News? In the woods I learn nothing of importance to the world." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "These kids call themselves an army... In the old times we had a REAL army, I tell ya..." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Time... it's running that fast when you are as old as me." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Robin. Some call me Rob, others Woody." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "I have not much use for heavy armor." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the Chief Huntsman of Thais." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
