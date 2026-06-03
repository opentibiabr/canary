local internalNpcName = "Jehan The Baker"
local npcType = Game.createNpcType("Jehan The Baker (Night)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 19,
	lookBody = 21,
	lookLegs = 39,
	lookFeet = 116,
	lookAddons = 0,
}

npcConfig.respawnType = {
	period = RESPAWNPERIOD_NIGHT,
	underground = false,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {}

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

	if MsgContains(message, "yselda") and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide) >= 1 and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.JehanTask) < 1 and player:getItemCount(3600) >= 10 then
		npcHandler:say("Ten loafs of bread! Colour me impressed. Will you hand those over to me?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yselda") and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide) >= 1 and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.JehanTask) < 1 then
		npcHandler:say("To prove trustworthy to me... hm, well, you could... oh, yes! Of course, we have a severe shortage of bread! If I knew someone who could organise about ten loafs of bread, I'd be saved for today!", npc, creature)
	elseif message:lower() == "yes" and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.JehanTask) < 1 then
		if npcHandler:getTopic(playerId) == 1 and player:removeItem(3600, 10) then
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.JehanTask, 1)
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust, player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust) + 1)
			npcHandler:say("Thanks, you saved my day and most certainly earned my trust!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the Bread & Butter! Do you want to buy pastries or butter? Because we're all out of bread.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, sell = 1, buy = 10 },
	{ itemName = "roll", clientId = 3601, sell = 1, buy = 8 },
	{ itemName = "cake", clientId = 6277, buy = 50 },
	{ itemName = "cookie", clientId = 3598, buy = 2 },
	{ itemName = "egg", clientId = 3606, buy = 2 },
	{ itemName = "red apple", clientId = 3585, buy = 3 },
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
