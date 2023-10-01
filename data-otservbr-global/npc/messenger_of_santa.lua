local internalNpcName = "Messenger of Santa"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 159,
	lookHead = 39,
	lookBody = 99,
	lookLegs = 60,
	lookFeet = 117,
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
	{ itemName = "blue christmas bundle", clientId = 6507, buy = 60 },
	{ itemName = "blue christmas garland", clientId = 6504, buy = 25 },
	{ itemName = "christmas branch", clientId = 6488, buy = 40 },
	{ itemName = "christmas card", clientId = 6387, buy = 10 },
	{ itemName = "christmas garland", clientId = 6502, buy = 25 },
	{ itemName = "christmas present green", clientId = 6509, buy = 20 },
	{ itemName = "christmas present red", clientId = 6505, buy = 20 },
	{ itemName = "christmas tree package", clientId = 10207, buy = 50 },
	{ itemName = "christmas wreath", clientId = 6501, buy = 45 },
	{ itemName = "green christmas bundle", clientId = 6508, buy = 80 },
	{ itemName = "red christmas bundle", clientId = 6506, buy = 70 },
	{ itemName = "red christmas garland", clientId = 6503, buy = 25 }
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
