local internalNpcName = "Dane"
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
	lookHead = 79,
	lookBody = 97,
	lookLegs = 86,
	lookFeet = 96,
	lookAddons = 0
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

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the owner of this place of relaxation."})
keywordHandler:addKeyword({'wave cellar'}, StdModule.say, {npcHandler = npcHandler, text = "It's pretty, isn't it?"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am Dane."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "It is exactly |TIME|."})
keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you milk, water, and lemonade."})
keywordHandler:addKeyword({'alcohol'}, StdModule.say, {npcHandler = npcHandler, text = "Alcohol makes people too aggressive. We don't need such stuff in Carlin."})
keywordHandler:addKeyword({'beer'}, StdModule.say, {npcHandler = npcHandler, text = "Alcohol makes people too aggressive. We don't need such stuff in Carlin."})
keywordHandler:addKeyword({'wine'}, StdModule.say, {npcHandler = npcHandler, text = "Alcohol makes people too aggressive. We don't need such stuff in Carlin."})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the wave cellar, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bottle of lemonade", clientId = 2875, buy = 12, count = 12 },
	{ itemName = "bottle of milk", clientId = 2875, buy = 4, count = 9 },
	{ itemName = "bottle of water", clientId = 2875, buy = 2, count = 1 }
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
