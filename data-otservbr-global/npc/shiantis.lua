local internalNpcName = "Shiantis"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 136,
	lookHead = 0,
	lookBody = 36,
	lookLegs = 13,
	lookFeet = 76,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Containers, decoration and general goods, all here!'}
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
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "football") then
		npcHandler:say("Do you want to buy a football for 111 gold?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			local player = Player(creature)
			if player:getMoney() + player:getBankBalance() >= 111 then
				npcHandler:say("Here it is.", npc, creature)
				player:addItem(2990, 1)
				player:removeMoneyBank(111)
			else
				npcHandler:say("You don't have enough money.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Oh, please come in, |PLAYERNAME|. What can I do for you? If you need adventure equipment, ask me for a {trade}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "basket", clientId = 2855, buy = 6 },
	{ itemName = "birdcage kit", clientId = 2796, buy = 50 },
	{ itemName = "black book", clientId = 2838, buy = 15 },
	{ itemName = "blue book", clientId = 2844, sell = 20 },
	{ itemName = "bottle", clientId = 2875, buy = 3 },
	{ itemName = "brown book", clientId = 2837, buy = 15 },
	{ itemName = "bucket", clientId = 2873, buy = 4 },
	{ itemName = "candelabrum", clientId = 2911, buy = 8 },
	{ itemName = "candlestick", clientId = 2917, buy = 2 },
	{ itemName = "chimney kit", clientId = 7864, buy = 200 },
	{ itemName = "closed trap", clientId = 3481, buy = 280, sell = 75 },
	{ itemName = "coal basin kit", clientId = 2806, buy = 25 },
	{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
	{ itemName = "cuckoo clock", clientId = 2664, buy = 40 },
	{ itemName = "document", clientId = 2834, buy = 12 },
	{ itemName = "empty goldfish bowl", clientId = 5928, buy = 50 },
	{ itemName = "fishing rod", clientId = 3483, buy = 150, sell = 40 },
	{ itemName = "gemmed book", clientId = 2842, sell = 100 },
	{ itemName = "globe kit", clientId = 2797, buy = 50 },
	{ itemName = "green book", clientId = 2846, sell = 15 },
	{ itemName = "greeting card", clientId = 6386, buy = 30 },
	{ itemName = "grey small book", clientId = 2839, buy = 15 },
	{ itemName = "hand auger", clientId = 31334, buy = 25 },
	{ itemName = "inkwell", clientId = 3509, buy = 10, sell = 8 },
	{ itemName = "machete", clientId = 3308, buy = 35, sell = 6 },
	{ itemName = "net", clientId = 31489, buy = 50 },
	{ itemName = "orange book", clientId = 2843, sell = 30 },
	{ itemName = "oven kit", clientId = 6371, buy = 80 },
	{ itemName = "parchment", clientId = 2817, buy = 8 },
	{ itemName = "pendulum clock kit", clientId = 2801, buy = 75 },
	{ itemName = "pick", clientId = 3456, sell = 15 },
	{ itemName = "picture", clientId = 2639, buy = 50 },
	{ itemName = "picture", clientId = 2640, buy = 50 },
	{ itemName = "picture", clientId = 2641, buy = 50 },
	{ itemName = "present", clientId = 2856, buy = 10 },
	{ itemName = "red backpack", clientId = 2867, buy = 20 },
	{ itemName = "red bag", clientId = 2859, buy = 5 },
	{ itemName = "rocking horse kit", clientId = 2800, buy = 30 },
	{ itemName = "rope", clientId = 3003, buy = 50, sell = 15 },
	{ itemName = "scroll", clientId = 2815, buy = 5 },
	{ itemName = "scythe", clientId = 3453, buy = 50, sell = 10 },
	{ itemName = "shovel", clientId = 3457, buy = 50, sell = 8 },
	{ itemName = "table lamp kit", clientId = 2798, buy = 35 },
	{ itemName = "telescope kit", clientId = 2799, buy = 70 },
	{ itemName = "torch", clientId = 2920, buy = 2 },
	{ itemName = "valentine's card", clientId = 6538, buy = 30 },
	{ itemName = "vial", clientId = 2874, sell = 5 },
	{ itemName = "vial of oil", clientId = 2874, buy = 20, count = 7 },
	{ itemName = "wall mirror", clientId = 2638, buy = 40 },
	{ itemName = "watch", clientId = 6092, buy = 20 },
	{ itemName = "water pipe", clientId = 2974, buy = 40 },
	{ itemName = "wooden hammer", clientId = 3459, sell = 15 },
	{ itemName = "worm", clientId = 3492, buy = 1 }
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
