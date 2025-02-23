local internalNpcName = "Rowenna"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 139,
	lookHead = 115,
	lookBody = 38,
	lookLegs = 76,
	lookFeet = 38,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Selling and buying fine weapons!" },
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

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the finest weaponshop in the land, |PLAYERNAME|! Tell me if you're looking for a good {trade}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Come back soon.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye. Come back soon.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "axe", clientId = 3274, buy = 20, sell = 7 },
	{ itemName = "battle axe", clientId = 3266, buy = 235, sell = 80 },
	{ itemName = "battle hammer", clientId = 3305, buy = 350, sell = 120 },
	{ itemName = "bone club", clientId = 3337, sell = 5 },
	{ itemName = "bone sword", clientId = 3338, buy = 75, sell = 20 },
	{ itemName = "carlin sword", clientId = 3283, buy = 473, sell = 118 },
	{ itemName = "club", clientId = 3270, buy = 5, sell = 1 },
	{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
	{ itemName = "dagger", clientId = 3267, buy = 5, sell = 2 },
	{ itemName = "double axe", clientId = 3275, sell = 260 },
	{ itemName = "durable exercise axe", clientId = 35280, buy = 1250000, count = 1800 },
	{ itemName = "durable exercise bow", clientId = 35282, buy = 1250000, count = 1800 },
	{ itemName = "durable exercise club", clientId = 35281, buy = 1250000, count = 1800 },
	{ itemName = "durable exercise shield", clientId = 44066, buy = 1250000, count = 1800 },
	{ itemName = "durable exercise sword", clientId = 35279, buy = 1250000, count = 1800 },
	{ itemName = "exercise axe", clientId = 28553, buy = 347222, count = 500 },
	{ itemName = "exercise bow", clientId = 28555, buy = 347222, count = 500 },
	{ itemName = "exercise club", clientId = 28554, buy = 347222, count = 500 },
	{ itemName = "exercise shield", clientId = 44065, buy = 347222, count = 500 },
	{ itemName = "exercise sword", clientId = 28552, buy = 347222, count = 500 },
	{ itemName = "fire sword", clientId = 3280, sell = 1000 },
	{ itemName = "halberd", clientId = 3269, sell = 400 },
	{ itemName = "hand axe", clientId = 3268, buy = 8, sell = 4 },
	{ itemName = "hatchet", clientId = 3276, sell = 25 },
	{ itemName = "katana", clientId = 3300, sell = 35 },
	{ itemName = "lasting exercise axe", clientId = 35286, buy = 10000000, count = 14400 },
	{ itemName = "lasting exercise bow", clientId = 35288, buy = 10000000, count = 14400 },
	{ itemName = "lasting exercise club", clientId = 35287, buy = 10000000, count = 14400 },
	{ itemName = "lasting exercise shield", clientId = 44067, buy = 10000000, count = 14400 },
	{ itemName = "lasting exercise sword", clientId = 35285, buy = 10000000, count = 14400 },
	{ itemName = "longsword", clientId = 3285, buy = 160, sell = 51 },
	{ itemName = "mace", clientId = 3286, buy = 90, sell = 30 },
	{ itemName = "morning star", clientId = 3282, buy = 430, sell = 100 },
	{ itemName = "orcish axe", clientId = 3316, sell = 350 },
	{ itemName = "rapier", clientId = 3272, buy = 15, sell = 5 },
	{ itemName = "sabre", clientId = 3273, buy = 35 },
	{ itemName = "short sword", clientId = 3294, buy = 26 },
	{ itemName = "sickle", clientId = 3293, buy = 7 },
	{ itemName = "spike sword", clientId = 3271, buy = 8000 },
	{ itemName = "sword", clientId = 3264, buy = 85 },
	{ itemName = "throwing knife", clientId = 3298, buy = 25 },
	{ itemName = "two handed sword", clientId = 3265, buy = 950 },
	{ itemName = "war hammer", clientId = 3279, buy = 10000 },
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
