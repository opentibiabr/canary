local internalNpcName = "Donald McRonald"
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
	lookHead = 22,
	lookBody = 94,
	lookLegs = 79,
	lookFeet = 117,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

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

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "bloodblade" }, StdModule.say, { npcHandler = npcHandler, text = "A general in the army." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "He sometimes comes to shop our food." })
keywordHandler:addKeyword({ "weather" }, StdModule.say, { npcHandler = npcHandler, text = "Weather is good enough to work on the fields." })
keywordHandler:addKeyword({ "spooked" }, StdModule.say, { npcHandler = npcHandler, text = "I dont know." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "A generous person." })
keywordHandler:addKeyword({ "donald" }, StdModule.say, { npcHandler = npcHandler, text = "I am Donald." })
keywordHandler:addKeyword({ "oswald" }, StdModule.say, { npcHandler = npcHandler, text = "He ignores us and we ignore him." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "I don't trust sorcerers like you." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "Knights always feel superior to us farmers." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "Druids are a great help for us, they know much about nature." })
keywordHandler:addKeyword({ "crops" }, StdModule.say, { npcHandler = npcHandler, text = "It is hard to grow but worth the effort." })
keywordHandler:addKeyword({ "field" }, StdModule.say, { npcHandler = npcHandler, text = "My fields are enchanted by the druids and the wheat grows very quickly." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "Frodo? He is a friend of mine." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "Too noble to care about us." })
keywordHandler:addKeyword({ "lynda" }, StdModule.say, { npcHandler = npcHandler, text = "She has a good soul." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Donald McRonald." })
keywordHandler:addKeyword({ "farm" }, StdModule.say, { npcHandler = npcHandler, text = "It is my farm, yes." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Who cares?" })
keywordHandler:addKeyword({ "wife" }, StdModule.say, { npcHandler = npcHandler, text = "Sherry is my wife." })
keywordHandler:addKeyword({ "city" }, StdModule.say, { npcHandler = npcHandler, text = "The city is to the north." })
keywordHandler:addKeyword({ "mill" }, StdModule.say, { npcHandler = npcHandler, text = "I sometimes have to bring the wheat there." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "King Tibianus is our king." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "Hardly know him." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I run a farm, what else?!" })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "A blacksmith, eh?" })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "beetroot", clientId = 8017, buy = 2 },
	{ itemName = "bunch of wheat", clientId = 3605, buy = 1 },
	{ itemName = "carrot", clientId = 3595, buy = 3 },
	{ itemName = "cheese", clientId = 3607, buy = 5 },
	{ itemName = "corncob", clientId = 3597, buy = 3 },
	{ itemName = "cucumber", clientId = 8014, buy = 3 },
	{ itemName = "dead spider", clientId = 3988, sell = 2 },
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
