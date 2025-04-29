local internalNpcName = "Perod"
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
	lookHead = 39,
	lookBody = 125,
	lookLegs = 29,
	lookFeet = 114,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Stop by before embarking on your great adventure! Distance weapons and general equipment on sale today!" },
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

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "black book", clientId = 2838, buy = 15 },
	{ itemName = "blue book", clientId = 2844, sell = 20 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "bottle", clientId = 2875, buy = 3 },
	{ itemName = "bow", clientId = 3350, buy = 400, sell = 400 },
	{ itemName = "brown book", clientId = 2837, buy = 15 },
	{ itemName = "bucket", clientId = 2873, buy = 4 },
	{ itemName = "camouflage backpack", clientId = 2872, buy = 20 },
	{ itemName = "camouflage bag", clientId = 2864, buy = 5 },
	{ itemName = "candelabrum", clientId = 2912, buy = 8 },
	{ itemName = "candlestick", clientId = 2917, buy = 2 },
	{ itemName = "closed trap", clientId = 3481, buy = 280 },
	{ itemName = "crossbow", clientId = 3349, buy = 500, sell = 500 },
	{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
	{ itemName = "crusher", clientId = 46627, buy = 500 },
	{ itemName = "crystalline arrow", clientId = 15793, buy = 20 },
	{ itemName = "cup", clientId = 2884, buy = 2 },
	{ itemName = "diamond arrow", clientId = 35901, buy = 130 },
	{ itemName = "document", clientId = 2818, buy = 12 },
	{ itemName = "drill bolt", clientId = 16142, buy = 12 },
	{ itemName = "earth arrow", clientId = 774, buy = 5 },
	{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
	{ itemName = "fishing rod", clientId = 3483, buy = 150, sell = 40 },
	{ itemName = "flaming arrow", clientId = 763, buy = 5 },
	{ itemName = "flash arrow", clientId = 761, buy = 5 },
	{ itemName = "gemmed book", clientId = 2842, sell = 100 },
	{ itemName = "green book", clientId = 2846, sell = 15 },
	{ itemName = "greeting card", clientId = 6386, buy = 30 },
	{ itemName = "grey small book", clientId = 2839, buy = 15 },
	{ itemName = "hand auger", clientId = 31334, buy = 25 },
	{ itemName = "inkwell", clientId = 3509, buy = 10, sell = 8 },
	{ itemName = "jug", clientId = 7244, buy = 10 },
	{ itemName = "machete", clientId = 3308, buy = 40, sell = 6 },
	{ itemName = "mug", clientId = 2880, buy = 4 },
	{ itemName = "net", clientId = 31489, buy = 50 },
	{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
	{ itemName = "orange book", clientId = 2843, sell = 30 },
	{ itemName = "parchment", clientId = 2817, buy = 8 },
	{ itemName = "pick", clientId = 3456, buy = 50, sell = 15 },
	{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
	{ itemName = "plate", clientId = 2905, buy = 6 },
	{ itemName = "power bolt", clientId = 3450, buy = 7 },
	{ itemName = "present", clientId = 2856, buy = 10 },
	{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "red quiver", clientId = 35849, buy = 400 },
	{ itemName = "rope", clientId = 3003, buy = 50, sell = 15 },
	{ itemName = "royal spear", clientId = 7378, buy = 15 },
	{ itemName = "scroll", clientId = 2815, buy = 5 },
	{ itemName = "scythe", clientId = 3453, buy = 50, sell = 10 },
	{ itemName = "shiver arrow", clientId = 762, buy = 5 },
	{ itemName = "shovel", clientId = 3457, buy = 50, sell = 8 },
	{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
	{ itemName = "spear", clientId = 3277, buy = 9, sell = 3 },
	{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
	{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
	{ itemName = "throwing star", clientId = 3287, buy = 42 },
	{ itemName = "torch", clientId = 2920, buy = 2 },
	{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
	{ itemName = "watch", clientId = 6092, buy = 20 },
	{ itemName = "wooden hammer", clientId = 3459, sell = 15 },
	{ itemName = "worm", clientId = 3492, buy = 1 },
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
