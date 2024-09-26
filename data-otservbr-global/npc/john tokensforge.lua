local internalNpcName = "John Tokensforge"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2
npcConfig.currency = 6526

npcConfig.outfit = {
	lookType = 151,
	lookHead = 39,
	lookBody = 77,
	lookLegs = 98,
	lookFeet = 95,
	lookAddons = 1
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 80,
	{text = 'Come and trade your Online Tokens for equipment.'}
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


npcHandler:setMessage(MESSAGE_GREET, "Welcome to my shop")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "gill gugel", clientId = 16104, buy = 40 },
	{ itemName = "gill coat", clientId = 16105, buy = 40 },
	{ itemName = "gill legs", clientId = 16106, buy = 40 },
	{ itemName = "spellbook of vigilance", clientId = 16107, buy = 40 },
	{ itemName = "gill necklace", clientId = 16108, buy = 15 },
	{ itemName = "prismatic helmet", clientId = 16109, buy = 40 },
	{ itemName = "prismatic armor", clientId = 16110, buy = 40 },
	{ itemName = "prismatic shield", clientId = 16116, buy = 30 },
	{ itemName = "prismatic legs", clientId = 16111, buy = 40 },
	{ itemName = "prismatic boots", clientId = 16112, buy = 40 },
	{ itemName = "prismatic necklace", clientId = 16113, buy = 15 },
	{ itemName = "prismatic ring", clientId = 16114, buy = 15 },
	{ itemName = "minor crystalline token", clientId = 16128, buy = 7 },
	{ itemName = "sun catcher", clientId = 25977, buy = 25 },
	{ itemName = "moon mirror", clientId = 25975, buy = 25 },
	{ itemName = "starlight vial", clientId = 25976, buy = 25 },
	{ itemName = "bonefiddle", clientId = 28493, buy = 25 },
	{ itemName = "lit torch", clientId = 34016, buy = 25 },
	{ itemName = "cake backpack", clientId = 20347, buy = 10 },
	{ itemName = "birthday backpack", clientId = 24395, buy = 200 },
	{ itemName = "anniversary backpack", clientId = 14674, buy = 300 },
	{ itemName = "25 years backpack", clientId = 39693, buy = 400 },
	{ itemName = "foxtail amulet", clientId = 27565, buy = 50 },
	{ itemName = "blessed wooden stake", clientId = 5942, buy = 30 },
	{ itemName = "obsidian knife", clientId = 5908, buy = 20 },
	{ itemName = "vial of liquid silver", clientId = 22058, buy = 5 },
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
