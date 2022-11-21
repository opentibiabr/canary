local internalNpcName = "Alissa"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 140,
	lookHead = 114,
	lookBody = 3,
	lookLegs = 72,
	lookFeet = 16,
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
	{ itemName = "banana", clientId = 3587, buy = 3 },
	{ itemName = "blueberry", clientId = 3588, buy = 1 },
	{ itemName = "carrot", clientId = 3595, buy = 3 },
	{ itemName = "cherry", clientId = 3590, buy = 1 },
	{ itemName = "cucumber", clientId = 8014, buy = 5 },
	{ itemName = "grapes", clientId = 3592, buy = 3 },
	{ itemName = "mango", clientId = 5096, buy = 8 },
	{ itemName = "melon", clientId = 3593, buy = 8 },
	{ itemName = "orange", clientId = 3586, buy = 6 },
	{ itemName = "pear", clientId = 3584, buy = 5 },
	{ itemName = "plum", clientId = 8011, buy = 3 },
	{ itemName = "potato", clientId = 8010, buy = 5 },
	{ itemName = "pumpkin", clientId = 3594, buy = 10 },
	{ itemName = "raspberry", clientId = 8012, buy = 1 },
	{ itemName = "red apple", clientId = 3585, buy = 3 },
	{ itemName = "strawberry", clientId = 3591, buy = 1 },
	{ itemName = "tomato", clientId = 3596, buy = 4 }
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
