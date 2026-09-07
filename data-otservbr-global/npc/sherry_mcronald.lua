local internalNpcName = "Sherry McRonald"
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
	lookHead = 78,
	lookBody = 94,
	lookLegs = 19,
	lookFeet = 97,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Isn't this a beautiful day? Perfect for farming." },
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

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! Welcome to our humble farm.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Grace our home with another visit soon, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "What a strange person.")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "harkath bloodblade" }, StdModule.say, { npcHandler = npcHandler, text = "He is an impressive warrior as far as I can tell." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "King Tibianus granted us this farm to earn a living." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, he's a nice old man. He often comes and buys our goods. I haven't seen him since a while though." })
keywordHandler:addKeyword({ "husband" }, StdModule.say, { npcHandler = npcHandler, text = "My husband Donald is busy on the fields almost all night and day." })
keywordHandler:addKeyword({ "weather" }, StdModule.say, { npcHandler = npcHandler, text = "The weather is the best friend and the worst enemy of a farmer." })
keywordHandler:addKeyword({ "spooked" }, StdModule.say, { npcHandler = npcHandler, text = "I don't know for sure. The miller claims that his mill is threatened by some monsters sometimes." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "What a nice person he is." })
keywordHandler:addKeyword({ "fields" }, StdModule.say, { npcHandler = npcHandler, text = "The druids helped us by placing a blessing on our fields." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "We a mere peasants and don't know much about the guild leaders." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "We a mere peasants and don't know much about the guild leaders." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "We a mere peasants and don't know much about the guild leaders." })
keywordHandler:addKeyword({ "oswald" }, StdModule.say, { npcHandler = npcHandler, text = "This lazy fellow has nothing better to do than to spread rumours." })
keywordHandler:addKeyword({ "crops" }, StdModule.say, { npcHandler = npcHandler, text = "It's hard to harvest it, carry it to the mill in the north and make flour. If you can bake some bread I will buy it for 2 gold." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "We a mere peasants and don't know much about the guild leaders." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "He is a friend of my husband." })
keywordHandler:addKeyword({ "lynda" }, StdModule.say, { npcHandler = npcHandler, text = "She is sooo charming. I can't believe she is not married yet! Have you met her?" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Sherry McRonald." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, I don't have a watch." })
keywordHandler:addKeyword({ "farm" }, StdModule.say, { npcHandler = npcHandler, text = "It is a hard work, but the city needs us." })
keywordHandler:addKeyword({ "city" }, StdModule.say, { npcHandler = npcHandler, text = "The city needs our crops." })
keywordHandler:addKeyword({ "mill" }, StdModule.say, { npcHandler = npcHandler, text = "The miller is a lazy fellow and afraid of his own mill, because he thinks it is spooked." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "King Tibianus granted us this farm to earn a living." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "He doesn't talk much to us." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I and my husband run this farm." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "He is too busy to care much about farmers like us." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, sell = 2 },
	{ itemName = "cheese", clientId = 3607, buy = 5 },
	{ itemName = "cherry", clientId = 3590, buy = 1 },
	{ itemName = "melon", clientId = 3593, buy = 8 },
	{ itemName = "pumpkin", clientId = 3594, buy = 10 },
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
