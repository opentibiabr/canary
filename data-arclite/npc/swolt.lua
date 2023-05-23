local internalNpcName = "Swolt"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 160,
	lookHead = 77,
	lookBody = 80,
	lookLegs = 79,
	lookFeet = 97,
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

local tomes = Storage.Quest.U8_54.TheNewFrontier.TomeofKnowledge
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "rice") and player:getStorageValue(tomes) > 3 then
		npcHandler:say("Aaargh! Cael and his strange thoughts! He bugged me so long about the lizard culture that I eventually agreed to prepare that rice for you if you need it. I need one ripe rice plant to prepare ten rice balls. OK?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		if player:getItemCount(10328) > 0 then
			npcHandler:say(string.format("Here you go. %d rice balls. Hope you buy a beer with them at least.", player:getItemCount(10328)*10), npc, creature)
			player:addItem(10329, player:getItemCount(10328)*10)
			player:removeItem(10328, player:getItemCount(10328))
		else
			npcHandler:say("You don't have a ripe rice plant. Thank fire and earth I was spared.", npc, creature)
		end
	end
	return true
end

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 4 },
	{ itemName = "bunch of ripe rice", clientId = 10328, sell = 75 },
	{ itemName = "cheese", clientId = 3607, buy = 6 },
	{ itemName = "ectoplasmic sushi", clientId = 11681, sell = 300 },
	{ itemName = "ham", clientId = 3582, buy = 8 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
	{ itemName = "mug of beer", clientId = 2880, buy = 2, count = 3 },
	{ itemName = "mug of water", clientId = 2880, buy = 1, count = 1 },
	{ itemName = "terramite eggs", clientId = 10453, sell = 50 }
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
-- Basic
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "Well, you see me standing behind a bar. Selling drinks. Food. And stuff. Now try figuring out what I could be making a living of down here."})
keywordHandler:addKeyword({"food"}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you bread, cheese, ham, or meat. And as drinks we serve beer and water. If you'd like to see what we have to offer, just ask me for a trade."})
keywordHandler:addAliasKeyword({"offer"})
keywordHandler:addAliasKeyword({"drinks"})
keywordHandler:addAliasKeyword({"buy"})
keywordHandler:addAliasKeyword({"sell"})
keywordHandler:addAliasKeyword({"equipment"})
keywordHandler:addAliasKeyword({"goods"})
keywordHandler:addAliasKeyword({"stuff"})
keywordHandler:addAliasKeyword({"ware"})
npcHandler:setMessage(MESSAGE_SENDTRADE, "Take a look, but not a sip before you've paid. And I hope it stays like this and you don't get any strange ideas about {rice}.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcType:register(npcConfig)
