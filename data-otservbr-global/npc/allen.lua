local internalNpcName = "Allen"
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
	lookHead = 76,
	lookBody = 43,
	lookLegs = 38,
	lookFeet = 76,
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

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "blue bed kit", clientId = 834, buy = 80 },
	{ itemName = "canopy bed kit", clientId = 17972, buy = 200 },
	{ itemName = "green bed kit", clientId = 831, buy = 80 },
	{ itemName = "green cushioned chair kit", clientId = 2776, buy = 40 },
	{ itemName = "red bed kit", clientId = 833, buy = 80 },
	{ itemName = "red cushioned chair kit", clientId = 2775, buy = 40 },
	{ itemName = "rocking chair kit", clientId = 2778, buy = 25 },
	{ itemName = "sofa chair kit", clientId = 2779, buy = 55 },
	{ itemName = "treasure chest", clientId = 2478, buy = 1000 },
	{ itemName = "venorean cabinet kit", clientId = 17974, buy = 90 },
	{ itemName = "venorean drawer kit", clientId = 17977, buy = 40 },
	{ itemName = "venorean wardrobe kit", clientId = 17975, buy = 50 },
	{ itemName = "wooden chair kit", clientId = 2777, buy = 15 },
	{ itemName = "yellow bed kit", clientId = 832, buy = 80 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
