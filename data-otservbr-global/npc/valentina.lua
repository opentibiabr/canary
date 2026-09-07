local internalNpcName = "Valentina"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 157,
	lookHead = 116,
	lookBody = 116,
	lookLegs = 98,
	lookFeet = 45,
	lookAddons = 1,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Love is beautiful, we are loved." },
}

npcConfig.shop = {
	{ itemName = "crimson rose", clientId = 21954, buy = 15 },
	{ itemName = "flower bouquet", clientId = 649, buy = 20 },
	{ itemName = "heart backpack", clientId = 10202, buy = 500 },
	{ itemName = "present", clientId = 2856, buy = 10 },
	{ itemName = "sweetheart ring", clientId = 21955, buy = 500 },
	{ itemName = "truelove teddy", clientId = 21953, buy = 1000 },
	{ itemName = "valentines cake", clientId = 6392, buy = 30 },
	{ itemName = "valentines card", clientId = 6538, buy = 5 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

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

-- Basic
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am known as the saleswoman of love, as a cupid." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome to Valentine's Store. Let's {trade} something?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "greenshore" }, StdModule.say, { npcHandler = npcHandler, text = "I grew up in Greenshore, I spent most of my time here and it is very likely that I will die here. Greenshore is a lovely place." })
keywordHandler:addKeyword({ "monastery" }, StdModule.say, { npcHandler = npcHandler, text = "Sometimes, the wind takes the choral singing of the monks to our coast. I alway get goosebumps when I hear it. It's so beautiful." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "He has so many followers but <whispers> I think he is doing a bad job. He should do more against the crimes happening right in front of his nose." })
keywordHandler:addKeyword({ "solitude" }, StdModule.say, { npcHandler = npcHandler, text = "It's not very far to the Isle of Solitude from here but there is simply no way. Isn't that a little bit odd?!?" })
keywordHandler:addKeyword({ "flower" }, StdModule.say, { npcHandler = npcHandler, text = "All flowers around Greenshore have been grown by myself." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "Sometimes, when the air is crystal clear, you can see it from the shore." })
keywordHandler:addKeyword({ "rumour" }, StdModule.say, { npcHandler = npcHandler, text = "You must know, many people came here to look for an underground passage to the Isle of Solitude. The people of Greenshore believe that there is one but no one ever proved its existence." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "It's sad to see how it changed. As a child I used to go there regularly but today I avoid going there. It's no safe place for an old woman like me." })
keywordHandler:addKeyword({ "ocean" }, StdModule.say, { npcHandler = npcHandler, text = "The ocean is part of Greenshore. The sound of the sea lapping against the shore, the salty air and the vastness when you look at the horizon <sigh> - it's so peaceful." })
keywordHandler:addKeyword({ "story" }, StdModule.say, { npcHandler = npcHandler, text = "What should I tell you? I'm old and I've got many things to tell even if most of them apply to Greenshore and its surrounding, the ocean and its islands offshore." })
keywordHandler:addKeyword({ "love" }, StdModule.say, { npcHandler = npcHandler, text = "Love is the most important thing in the world and I help you to express it. Just ask me about my offers and I'll tell you what you can buy." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "He has so many followers but <whispers> I think he is doing a bad job. He should do more against the crimes happening right in front of his nose." })
keywordHandler:addKeyword({ "sea" }, StdModule.say, { npcHandler = npcHandler, text = "The ocean is part of Greenshore. The sound of the sea lapping against the shore, the salty air and the vastness when you look at the horizon <sigh> - it's so peaceful." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
