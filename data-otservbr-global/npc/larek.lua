local internalNpcName = "Larek"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 472,
	lookHead = 19,
	lookBody = 50,
	lookLegs = 10,
	lookFeet = 3,
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
	{ itemName = "black pearl", clientId = 3027, sell = 280 },
	{ itemName = "cookie", clientId = 3598, buy = 7 },
	{ itemName = "flour", clientId = 3603, buy = 30 },
	{ itemName = "hoe", clientId = 3455, buy = 15 },
	{ itemName = "juice squeezer", clientId = 5865, buy = 100 },
	{ itemName = "kitchen knife", clientId = 3469, buy = 20 },
	{ itemName = "onyx chip", clientId = 22193, sell = 500 },
	{ itemName = "opal", clientId = 22194, sell = 500 },
	{ itemName = "rope", clientId = 3003, buy = 50 },
	{ itemName = "shovel", clientId = 3457, buy = 50 },
	{ itemName = "small ruby", clientId = 3030, sell = 250 },
	{ itemName = "small topaz", clientId = 9057, sell = 200 },
	{ itemName = "vial", clientId = 2874, buy = 20 },
	{ itemName = "vial of milk", clientId = 2874, buy = 50, count = 9 },
	{ itemName = "white pearl", clientId = 3026, sell = 160 }
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
