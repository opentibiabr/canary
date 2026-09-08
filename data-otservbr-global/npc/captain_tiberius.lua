local internalNpcName = "Captain Tiberius"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 134,
	lookHead = 97,
	lookBody = 79,
	lookLegs = 95,
	lookFeet = 116,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "sailor",
}
npcConfig.speechBubble = SPEECHBUBBLE_SAILOR

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
keywordHandler:addKeyword({ "transfer" }, StdModule.say, { npcHandler = npcHandler, text = "Are you here for the character world transfer? Well, if you have any questions I suggest asking Sharon, below on the deck. She knows everything and more." })
keywordHandler:addKeyword({ "travora" }, StdModule.say, { npcHandler = npcHandler, text = "Nothing much of an island when it was still there, to tell the truth. Only notable thing about it was the fact that the veil between worlds is thin here, hence the possibility to change worlds." })
keywordHandler:addKeyword({ "corpse" }, StdModule.say, { npcHandler = npcHandler, text = "Oh. Well, the sea's a harsh mistress, 'tis true. Break it gently to Sharon, will you? I'm not really the right person for that." })
keywordHandler:addKeyword({ "sharon" }, StdModule.say, { npcHandler = npcHandler, text = "Don't be shy to ask her for information if you need any. She doesn't bite." })
keywordHandler:addKeyword({ "change" }, StdModule.say, { npcHandler = npcHandler, text = "Not my field of expertise. If you want to know more or change to another world, talk to Sharon on the deck below." })
keywordHandler:addKeyword({ "elgar" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Hm. Didn't really know him. Only time I talked to him was a long time ago, when he came to open up his business on Travora. Never set foot on the island myself, though. ... When the waters swallowed Travora, we found Sharon and that dwarf stranded on a sand bank below. He didn't talk much then, either. Crawled into the belly of my ship to get dry again, and that's the last thing I know.",
})
keywordHandler:addKeyword({ "world" }, StdModule.say, { npcHandler = npcHandler, text = "Not my field of expertise. If you want to know more or change to another world, talk to Sharon on the deck below." })
keywordHandler:addKeyword({ "dead" }, StdModule.say, { npcHandler = npcHandler, text = "Oh. Well, the sea's a harsh mistress, 'tis true. Break it gently to Sharon, will you? I'm not really the right person for that." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I'm Captain Tiberius, at your service." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I transport my passengers back to the continent." })
keywordHandler:addKeyword({ "map" }, StdModule.say, { npcHandler = npcHandler, text = "We have to keep track of changes in these waters of course, lest we navigate into a reef." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
