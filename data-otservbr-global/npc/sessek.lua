local internalNpcName = "Sessek"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 339
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
	{ itemName = "banana", clientId = 3587, buy = 6 },
	{ itemName = "coconut", clientId = 3589, buy = 8 },
	{ itemName = "cookie", clientId = 3598, buy = 2 },
	{ itemName = "fish", clientId = 3578, buy = 5 },
	{ itemName = "jalapeno pepper", clientId = 8016, buy = 4 },
	{ itemName = "mango", clientId = 5096, buy = 10 },
	{ itemName = "melon", clientId = 3593, buy = 12 },
	{ itemName = "orange", clientId = 3586, buy = 5 },
	{ itemName = "peas", clientId = 11683, buy = 3 },
	{ itemName = "pineapple", clientId = 11459, buy = 14 },
	{ itemName = "roll", clientId = 3601, buy = 2 },
	{ itemName = "vial of coconut milk", clientId = 2874, buy = 2, count = 15 },
	{ itemName = "vial of fruit juice", clientId = 2874, buy = 6, count = 14 },
	{ itemName = "vial of tea", clientId = 2874, buy = 3, count = 17 },
	{ itemName = "vial of water", clientId = 2874, buy = 2, count = 1 },
	{ itemName = "vial of wine", clientId = 2874, buy = 3, count = 2 }
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
