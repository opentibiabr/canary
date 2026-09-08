local internalNpcName = "Quero"
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
	lookHead = 55,
	lookBody = 30,
	lookLegs = 24,
	lookFeet = 115,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

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
keywordHandler:addKeyword({ "benjamin" }, StdModule.say, { npcHandler = npcHandler, text = "He's nice." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "That name rings a bell, wait... I've last seen him several days ago when he went to buy some bread at the farm." })
keywordHandler:addKeyword({ "music" }, StdModule.say, { npcHandler = npcHandler, text = "I love the music of the elves." })
keywordHandler:addKeyword({ "elves" }, StdModule.say, { npcHandler = npcHandler, text = "They live in the northeast of Tibia." })
keywordHandler:addKeyword({ "child" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, I have a small daughter. Her room is upstairs." })
keywordHandler:addKeyword({ "tooth" }, StdModule.say, { npcHandler = npcHandler, text = "I wonder why this matters to you. But yes, my daughter lost her first tooth a few days ago." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Quero." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, I don't know what time it is." })
keywordHandler:addKeyword({ "bard" }, StdModule.say, { npcHandler = npcHandler, text = "Selling instruments isn't enough to live on and I love music. That's why I wander through the lands from time to time." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I make instruments and sometimes I'm wandering through the lands of Tibia as a bard." })
keywordHandler:addKeyword({ "elf" }, StdModule.say, { npcHandler = npcHandler, text = "They live in the northeast of Tibia." })
keywordHandler:addKeyword({ "kid" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, I have a small daughter. Her room is upstairs." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "drum", clientId = 14253, buy = 140 },
	{ itemName = "lute", clientId = 2950, buy = 195 },
	{ itemName = "lyre", clientId = 2949, buy = 120 },
	{ itemName = "simple fanfare", clientId = 2954, buy = 150 },
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

npcType:register(npcConfig)
