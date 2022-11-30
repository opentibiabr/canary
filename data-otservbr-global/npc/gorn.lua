local internalNpcName = "Gorn"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 58,
	lookBody = 68,
	lookLegs = 101,
	lookFeet = 95,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'General goods and paperware for sale!'}
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

-- Basic
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am selling equipment of all kinds. Do you need anything?"})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = "The king supports Tibia's economy a lot."})
keywordHandler:addAliasKeyword({'tibianus'})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = "Magic? Ask a sorcerer or druid about that."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am Gorn. My goods are known all over Tibia."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "It is exactly |TIME|. Maybe you want to buy a watch?"})
keywordHandler:addKeyword({'druids'}, StdModule.say, {npcHandler = npcHandler, text = "This druids are nice people, you will find them in the east of the town."})
keywordHandler:addKeyword({'knights'}, StdModule.say, {npcHandler = npcHandler, text = "Even the strong knights need my equipment on their travels though Tibia."})
keywordHandler:addKeyword({'sorcerers'}, StdModule.say, {npcHandler = npcHandler, text = "You can find him in the sorcerer guild."})
keywordHandler:addKeyword({'elane'}, StdModule.say, {npcHandler = npcHandler, text = "She's the leader of the paladin guild."})
keywordHandler:addKeyword({'baxter'}, StdModule.say, {npcHandler = npcHandler, text = "Old Baxter was a rowdy, once. In our youth we shared some adventures and women."})
keywordHandler:addKeyword({'bozo'}, StdModule.say, {npcHandler = npcHandler, text = "Bah! Go away with this bozoguy."})
keywordHandler:addKeyword({'frodo'}, StdModule.say, {npcHandler = npcHandler, text = "Frodo is a jolly fellow."})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = "We had a clash or two in the old days."})
keywordHandler:addKeyword({'gregor'}, StdModule.say, {npcHandler = npcHandler, text = "Even the strong knights need my equipment on their travels though Tibia."})
keywordHandler:addKeyword({'lynda'}, StdModule.say, {npcHandler = npcHandler, text = "That's a pretty one."})
keywordHandler:addKeyword({'mcronald'}, StdModule.say, {npcHandler = npcHandler, text = "I hardly know the McRonalds."})
keywordHandler:addKeyword({'muriel'}, StdModule.say, {npcHandler = npcHandler, text = "You can find him in the sorcerer guild."})
keywordHandler:addKeyword({'oswald'}, StdModule.say, {npcHandler = npcHandler, text = "This Oswald has not enough to work and too much time to spread rumours."})
keywordHandler:addKeyword({'quentin'}, StdModule.say, {npcHandler = npcHandler, text = "He advices newcomers to buy at my store. I love that guy!"})
keywordHandler:addKeyword({'sam'}, StdModule.say, {npcHandler = npcHandler, text = "Strong as an ox, could armwrestle a minotaur, I bet."})
keywordHandler:addKeyword({'xodet'}, StdModule.say, {npcHandler = npcHandler, text = "He owns the magic shop here. But be aware: The prices are enormous."})
npcHandler:setMessage(MESSAGE_GREET, "Oh, please come in, |PLAYERNAME|. What do you need?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares. {Footballs} have to be purchased separately.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "basket", clientId = 2855, buy = 6 },
	{ itemName = "black book", clientId = 2838, buy = 15 },
	{ itemName = "blue book", clientId = 2844, sell = 20 },
	{ itemName = "bottle", clientId = 2875, buy = 3 },
	{ itemName = "brown book", clientId = 2837, buy = 15 },
	{ itemName = "bucket", clientId = 2873, buy = 4 },
	{ itemName = "candelabrum", clientId = 2927, buy = 8 },
	{ itemName = "candlestick", clientId = 2917, buy = 2 },
	{ itemName = "closed trap", clientId = 3481, buy = 280, sell = 75 },
	{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
	{ itemName = "cup", clientId = 2884, buy = 2 },
	{ itemName = "document", clientId = 2818, buy = 12 },
	{ itemName = "fishing rod", clientId = 3483, buy = 150, sell = 40 },
	{ itemName = "gemmed book", clientId = 2842, sell = 100 },
	{ itemName = "green book", clientId = 2846, sell = 15 },
	{ itemName = "greeting card", clientId = 6386, buy = 30 },
	{ itemName = "grey small book", clientId = 2839, buy = 15 },
	{ itemName = "hand auger", clientId = 31334, buy = 25 },
	{ itemName = "inkwell", clientId = 3509, buy = 10, sell = 8 },
	{ itemName = "jug", clientId = 7244, buy = 10 },
	{ itemName = "machete", clientId = 3308, buy = 35, sell = 6 },
	{ itemName = "mug", clientId = 2880, buy = 4 },
	{ itemName = "net", clientId = 31489, buy = 50 },
	{ itemName = "orange backpack", clientId = 9602, buy = 20 },
	{ itemName = "orange bag", clientId = 9603, buy = 5 },
	{ itemName = "orange book", clientId = 2843, sell = 30 },
	{ itemName = "parchment", clientId = 2814, buy = 8, sell = 5 },
	{ itemName = "parchment", clientId = 2817, buy = 8 },
	{ itemName = "pick", clientId = 3456, buy = 50, sell = 15 },
	{ itemName = "plate", clientId = 2905, buy = 6 },
	{ itemName = "present", clientId = 2856, buy = 10 },
	{ itemName = "rope", clientId = 3003, buy = 50, sell = 15 },
	{ itemName = "scroll", clientId = 2815, buy = 5 },
	{ itemName = "scythe", clientId = 3453, buy = 50, sell = 10 },
	{ itemName = "shovel", clientId = 3457, buy = 50, sell = 8 },
	{ itemName = "torch", clientId = 2920, buy = 2 },
	{ itemName = "valentine's card", clientId = 6538, buy = 30 },
	{ itemName = "watch", clientId = 2906, buy = 20, sell = 6 },
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
