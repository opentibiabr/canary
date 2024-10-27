local internalNpcName = "Navega"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 134,
	lookHead = 95,
	lookBody = 57,
	lookLegs = 76,
	lookFeet = 39,
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

	{ itemName = "bag you desire", clientId = 34109, buy = 60000000 },
	{ itemName = "primal bag", clientId = 39546, buy = 90000000 },
	{ itemName = "sliver", clientId = 37109, buy = 10000 },
	--	{ itemName = "bone club", clientId = 3337, sell = 5 },
	--	{ itemName = "bone sword", clientId = 3338, buy = 75, sell = 20 },
	--	{ itemName = "orcish axe", clientId = 3316, sell = 350 },
	--	{ itemName = "plate armor", clientId = 3357, buy = 1200, sell = 400 },
	--	{ itemName = "plate legs", clientId = 3557, sell = 115 },
	--	{ itemName = "plate shield", clientId = 3410, buy = 125, sell = 45 },
	--	{ itemName = "rapier", clientId = 3272, buy = 15, sell = 5 },
	--	{ itemName = "rubber cap", clientId = 21165, sell = 11000 },
	--	{ itemName = "sabre", clientId = 3273, buy = 35, sell = 12 },
	--	{ itemName = "scale armor", clientId = 3377, buy = 260, sell = 75 },
	--	{ itemName = "short sword", clientId = 3294, buy = 26, sell = 10 },
	--	{ itemName = "sickle", clientId = 3293, buy = 7, sell = 3 },
	--	{ itemName = "small axe", clientId = 3462, sell = 5 },
	--	{ itemName = "soldier helmet", clientId = 3375, buy = 110, sell = 16 },
	--	{ itemName = "spike sword", clientId = 3271, buy = 8000, sell = 240 },
	--	{ itemName = "steel helmet", clientId = 3351, buy = 580, sell = 293 },
	--	{ itemName = "steel shield", clientId = 3409, buy = 240, sell = 80 },
	--	{ itemName = "studded armor", clientId = 3378, buy = 90, sell = 25 },
	--	{ itemName = "studded club", clientId = 3336, sell = 10 },
	--	{ itemName = "studded helmet", clientId = 3376, buy = 63 },
	--	{ itemName = "studded legs", clientId = 3362, buy = 50 },
	--	{ itemName = "studded shield", clientId = 3426, buy = 50 },
	--	{ itemName = "sword", clientId = 3264, buy = 85 },
	--	{ itemName = "throwing knife", clientId = 3298, buy = 25 },
	--	{ itemName = "two handed sword", clientId = 3265, buy = 950 },
	--	{ itemName = "viking helmet", clientId = 3367, buy = 265 },
	--	{ itemName = "viking shield", clientId = 3431, buy = 260 },
	--	{ itemName = "war hammer", clientId = 3279, buy = 10000 },
	--	{ itemName = "wooden shield", clientId = 3412, buy = 15 },
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
