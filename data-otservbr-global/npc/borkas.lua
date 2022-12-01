local internalNpcName = "Borkas"
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
	lookHead = 77,
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

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "armor rack kit", clientId = 6114, buy = 90 },
	{ itemName = "barrel kit", clientId = 2793, buy = 12 },
	{ itemName = "bookcase kit", clientId = 6372, buy = 70 },
	{ itemName = "box", clientId = 2469, buy = 10 },
	{ itemName = "chest", clientId = 2472, buy = 10 },
	{ itemName = "crate", clientId = 2471, buy = 10 },
	{ itemName = "drawer kit", clientId = 2789, buy = 18 },
	{ itemName = "dresser kit", clientId = 2790, buy = 25 },
	{ itemName = "locker kit", clientId = 2791, buy = 30 },
	{ itemName = "treasure chest", clientId = 2478, buy = 1000 },
	{ itemName = "trough kit", clientId = 2792, buy = 7 },
	{ itemName = "trunk kit", clientId = 2794, buy = 10 },
	{ itemName = "venorean cabinet kit", clientId = 17974, buy = 90 },
	{ itemName = "venorean drawer kit", clientId = 17977, buy = 40 },
	{ itemName = "venorean wardrobe kit", clientId = 17975, buy = 50 },
	{ itemName = "weapon rack kit", clientId = 6115, buy = 90 }
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
