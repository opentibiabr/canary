local internalNpcName = "Ramina"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1199,
	lookHead = 114,
	lookBody = 0,
	lookLegs = 15,
	lookFeet = 79,
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
	{ itemName = "banana", clientId = 3587, buy = 7 },
	{ itemName = "brown bread", clientId = 3602, buy = 6 },
	{ itemName = "empty honey glass", clientId = 31331, sell = 270 },
	{ itemName = "fish", clientId = 3578, buy = 10 },
	{ itemName = "jar of honey", clientId = 31332, sell = 300 },
	{ itemName = "lemon", clientId = 8013, buy = 5 },
	{ itemName = "mango", clientId = 5096, buy = 12 },
	{ itemName = "melon", clientId = 3593, buy = 14 },
	{ itemName = "mug of wine", clientId = 2880, buy = 15, count = 2 },
	{ itemName = "orange", clientId = 3586, buy = 12 },
	{ itemName = "peas", clientId = 11683, buy = 5 },
	{ itemName = "vial of fruit juice", clientId = 2874, buy = 10, count = 14 },
	{ itemName = "vial of water", clientId = 2874, buy = 2, count = 1 }
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
