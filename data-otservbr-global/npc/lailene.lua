local internalNpcName = "Lailene"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 279,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 113,
	lookFeet = 114,
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

keywordHandler:addKeyword({'brotherhood of bones'}, StdModule.say, {npcHandler = npcHandler, text = "... what?! Uh - no, no. Of course I wouldn't have anything to do with... them."})

npcHandler:setMessage(MESSAGE_GREET, "What do you want in my magical robe store? I doubt I have anything that's of interest to you.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See ya, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See ya, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Here.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "batwing hat", clientId = 9103, sell = 8000 },
	{ itemName = "ethno coat", clientId = 8064, buy = 750, sell = 200 },
	{ itemName = "focus cape", clientId = 8043, sell = 6000 },
	{ itemName = "jade hat", clientId = 10451, sell = 9000 },
	{ itemName = "magicians robe", clientId = 7991, buy = 450 },
	{ itemName = "spellweavers rob", clientId = 10438, sell = 12000 },
	{ itemName = "spirit cloak", clientId = 8042, buy = 1000, sell = 350 },
	{ itemName = "zaoan robe", clientId = 10439, sell = 12000 }
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
