local internalNpcName = "Meraki Trader"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 1611,
	lookHead = 0,
	lookBody = 19,
	lookLegs = 76,
	lookFeet = 114,
	lookAddons = 3
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

local function creatureSayCallback(npc, creature, type, message)
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Seja bem vindo, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Fallow, |PLAYERNAME|, vai pela sombra.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Volta ai porra!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Vai na calma de Jeova!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.currency = 37317

npcConfig.shop = {
	
	{ name = "Dust Refil", clientId = 19082, buy = 3000 },
	{ name = "Stamina Refil", clientId = 33893, buy = 4000 },
	{ name = "Teleport Cube", clientId = 31633, buy = 1000 },
	{ name = "squeezing gear of girlpower", clientId = 9596, buy = 200 },
	{ name = "bone fiddle", clientId = 28493, buy = 500 },
	{ name = "moon mirror", clientId = 25975, buy = 500 },
	{ name = "starlight vial", clientId = 25976, buy = 500 },
	{ name = "lit torch", clientId = 34017, buy = 500 },
	{ name = "hydra tongue salad", clientId = 9080, buy = 50 },
	{ name = "blueberry cupcakes", clientId = 28484, buy = 50 },
	{ name = "strawberry cupcake", clientId = 28485, buy = 50 },
	{ name = "Blade Of Destruction", clientId = 27449, buy = 1000 },
	{ name = "Slayer of Destruction", clientId = 27450, buy = 1000 },
	{ name = "Axe of Destruction", clientId = 27451, buy = 1000 },
	{ name = "Chopper Of Destruction", clientId = 27452, buy = 1000 },
	{ name = "Mace Of Destruction", clientId = 27453, buy = 1000 },
	{ name = "Hammer Of Destruction", clientId = 27454, buy = 1000 },
	{ name = "Bow_Of_Destruction", clientId = 27455, buy = 1000 },
	{ name = "Crossbow Of Destruction", clientId = 27456, buy = 1000 },
	{ name = "Wand of Destruction", clientId = 27457, buy = 1000 },
	{ name = "Rod of Destruction", clientId = 27458, buy = 1000 },
	{ name = "surprise bag", clientId = 30316, buy = 5000 },
	{ name = "remove skull", clientId = 37338, buy = 2000 },
	{ name = "gnome armor", clientId = 27648, buy = 1000 },
	{ name = "loot 2x", clientId = 36727, buy = 500 },
	{ name = "gnome helmet", clientId = 27647, buy = 1000 },
	{ name = "gnome legs", clientId = 27649, buy = 1000 },
	{ name = "gnome sword", clientId = 27651, buy = 1000 },
	{ name = "gnome shield", clientId = 27650, buy = 1000 },
	{ name = "lasting exercise wand", clientId = 35290, buy = 700 },
	{ name = "lasting exercise sword", clientId = 35285, buy = 700 },
	{ name = "lasting exercise rod", clientId = 35289, buy = 700 },
	{ name = "lasting exercise club", clientId = 35287, buy = 700 },
	{ name = "lasting exercise axe", clientId = 35286, buy = 700 },
	{ name = "lasting exercise bow", clientId = 35288, buy = 700 },
	
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
