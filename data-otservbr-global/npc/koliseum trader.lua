local internalNpcName = "Koliseum Trader"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2
npcConfig.currency = 22724

npcConfig.outfit = {
	lookType = 1301,
	lookHead = 38,
	lookBody = 0,
	lookLegs = 38,
	lookFeet = 43,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 80,
	{text = 'Come and trade your Koliseum Tokens for Powerful Badges.'}
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


npcHandler:setMessage(MESSAGE_GREET, "Welcome")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "Veteran Badge", clientId = 5785, buy = 1000 },
	{ itemName = "Fierce Trophy", clientId = 9209, buy = 700 },
	{ itemName = "Gold Medal", clientId = 9215, buy = 800 },
	{ itemName = "Silver Medal", clientId = 9216, buy = 1000 },
	{ itemName = "Sharpshoot Badge", clientId = 9218, buy = 800 },
	{ itemName = "Arcane Badge", clientId = 9219, buy = 900 },
	{ itemName = "Blood Badge", clientId = 9220, buy = 900 },
	{ itemName = "Void Badge", clientId = 9222, buy = 900 },
	{ itemName = "Elder Badge", clientId = 9223, buy = 700 },
	{ itemName = "Sage Badge", clientId = 9221, buy = 700 },
	{ itemName = "Swift Badge", clientId = 23487, buy = 700 },

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
