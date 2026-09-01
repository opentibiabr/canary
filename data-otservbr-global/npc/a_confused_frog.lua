local internalNpcName = "A Confused Frog"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 224,
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
keywordHandler:addKeyword({ "eeny meeny miny moe ribbit ribbit head to toe" }, StdModule.say, { npcHandler = npcHandler, text = "........ ... Ri..... ... Ritual didn't work. RIBBIT?! I can speak the human language again! Ribbit! Well, at least sometimes it seems. Ribbit. And who the heck are you??" })
keywordHandler:addKeyword({ "assistant" }, StdModule.say, { npcHandler = npcHandler, text = "I don't want to be an assistant anymore. Ribbit. I just want my dream pond." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "That old fool! He should be locked up with his weird theories and ideas and forced to study some serious magic! Rrrribbit!" })
keywordHandler:addKeyword({ "ribbit" }, StdModule.say, { npcHandler = npcHandler, text = "Ribbit?!" })
keywordHandler:addKeyword({ "player" }, StdModule.say, { npcHandler = npcHandler, text = "Are you? I see. I saw you poking around here earlier. Ribbit. Well whatever you were trying to do, I'm not sure it was successful. Ribbit. What was that princess thing all about, anyway??" })
keywordHandler:addKeyword({ "samael" }, StdModule.say, { npcHandler = npcHandler, text = "Yep, he told me one day that that was his name. In the tone of voice that makes your ears almost explode and singes your hair." })
keywordHandler:addKeyword({ "human" }, StdModule.say, { npcHandler = npcHandler, text = "You know... being a frog isn't that bad. Ribbit. I don't want to be a human again. I just wish I could get out of this cage and live by a lovely little pond." })
keywordHandler:addKeyword({ "magic" }, StdModule.say, { npcHandler = npcHandler, text = "Magic, pah. Ribbit. I don't need magic. I just want some flies, actually. Ribbit." })
keywordHandler:addKeyword({ "demon" }, StdModule.say, { npcHandler = npcHandler, text = "That demon is called ribbit. Erm, no, I mean Samael. He is one REALLY annoyed demon overlord, but we get along okay. Not sure if I'd let him out of there though. Ribbit." })
keywordHandler:addKeyword({ "kiss" }, StdModule.say, { npcHandler = npcHandler, text = "..... ..." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Well... ribbit... my name is Turian. But that doesn't really matter anymore." })
keywordHandler:addKeyword({ "frog" }, StdModule.say, { npcHandler = npcHandler, text = "You know... being a frog isn't that bad. Ribbit. I don't want to be a human again. I just wish I could get out of this cage and live by a lovely little pond." })
keywordHandler:addKeyword({ "pond" }, StdModule.say, { npcHandler = npcHandler, text = "I like the pond north of Thais. It's a really cosy place. Not just for humans, but especially for frogs. Ribbit." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I used to be Eclesius' assistant! Argh! Then - ribbit - one of his crazy experimental spells backfired and hit me. That's when I lost my job I guess. Ribbit." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
