local internalNpcName = "Luna"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 137,
	lookHead = 0,
	lookBody = 100,
	lookLegs = 100,
	lookFeet = 115,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Selling herbs, mushrooms and flowers, all picked under the light of the full moon!'}
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

keywordHandler:addKeyword({'offers'}, StdModule.say, {npcHandler = npcHandler, text = "I'm selling various herbs, mushrooms, and flowers. If you'd like to see my offers, ask me for a {trade}."})

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller. Maybe you'd like to take a look at my {offers}...")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye, traveller.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Goodbye, traveller.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bamboo stick", clientId = 11445, sell = 30 },
	{ itemName = "brown mushroom", clientId = 3725, buy = 10 },
	{ itemName = "bundle of cursed straw", clientId = 9688, sell = 800 },
	{ itemName = "carniphila seeds", clientId = 10300, sell = 50 },
	{ itemName = "dark mushroom", clientId = 3728, sell = 100 },
	{ itemName = "dung ball", clientId = 14225, sell = 130 },
	{ itemName = "fern", clientId = 3737, buy = 24 },
	{ itemName = "fire mushroom", clientId = 3731, sell = 200 },
	{ itemName = "goat grass", clientId = 3674, sell = 50 },
	{ itemName = "grave flower", clientId = 3661, sell = 25 },
	{ itemName = "green mushroom", clientId = 3732, sell = 100 },
	{ itemName = "lump of dirt", clientId = 9692, sell = 10 },
	{ itemName = "lump of earth", clientId = 10305, sell = 130 },
	{ itemName = "nettle blossom", clientId = 10314, sell = 75 },
	{ itemName = "nettle spit", clientId = 11476, sell = 25 },
	{ itemName = "orange mushroom", clientId = 3726, sell = 150 },
	{ itemName = "powder herb", clientId = 3739, sell = 10 },
	{ itemName = "red mushroom", clientId = 3724, buy = 12 },
	{ itemName = "red rose", clientId = 3658, buy = 11 },
	{ itemName = "seeds", clientId = 647, sell = 150 },
	{ itemName = "shadow herb", clientId = 3740, sell = 20 },
	{ itemName = "sling herb", clientId = 3738, sell = 10 },
	{ itemName = "star herb", clientId = 3736, buy = 21 },
	{ itemName = "stone herb", clientId = 3735, buy = 28 },
	{ itemName = "swamp grass", clientId = 9686, sell = 20 },
	{ itemName = "troll green", clientId = 3741, sell = 25 },
	{ itemName = "trollroot", clientId = 11515, sell = 50 },
	{ itemName = "tulip", clientId = 3668, buy = 9 },
	{ itemName = "white mushroom", clientId = 3723, buy = 6 },
	{ itemName = "wood mushroom", clientId = 3727, sell = 15 }
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
