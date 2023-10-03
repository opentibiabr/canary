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
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
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
	{ itemName = "blue footboard", clientId = 32482, buy = 40 },
	{ itemName = "blue headboard", clientId = 32473, buy = 40 },
	{ itemName = "canopy footboard", clientId = 32490, buy = 40 },
	{ itemName = "canopy headboard", clientId = 32481, buy = 40 },
	{ itemName = "cot footboard", clientId = 32486, buy = 40 },
	{ itemName = "cot headboard", clientId = 32477, buy = 40 },
	{ itemName = "green cushioned chair kit", clientId = 2378, buy = 40 },
	{ itemName = "green footboard", clientId = 32483, buy = 40 },
	{ itemName = "green headboard", clientId = 32474, buy = 40 },
	{ itemName = "hammock foot section", clientId = 32487, buy = 40 },
	{ itemName = "hammock head section", clientId = 32478, buy = 40 },
	{ itemName = "red cushioned chair kit", clientId = 2374, buy = 40 },
	{ itemName = "red footboard", clientId = 32484, buy = 40 },
	{ itemName = "red headboard", clientId = 32475, buy = 40 },
	{ itemName = "rocking chair kit", clientId = 2382, buy = 25 },
	{ itemName = "simple footboard", clientId = 32488, buy = 40 },
	{ itemName = "simple headboard", clientId = 32479, buy = 40 },
	{ itemName = "sofa chair kit", clientId = 2366, buy = 55 },
	{ itemName = "straw mat foot section", clientId = 32489, buy = 40 },
	{ itemName = "straw mat head section", clientId = 32480, buy = 40 },
	{ itemName = "treasure chest", clientId = 2478, buy = 1000 },
	{ itemName = "venorean cabinet kit", clientId = 18015, buy = 90 },
	{ itemName = "venorean drawer kit", clientId = 18019, buy = 40 },
	{ itemName = "venorean wardrobe kit", clientId = 18017, buy = 50 },
	{ itemName = "wooden chair kit", clientId = 2360, buy = 15 },
	{ itemName = "yellow footboard", clientId = 32485, buy = 40 },
	{ itemName = "yellow headboard", clientId = 32476, buy = 40 },
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
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
