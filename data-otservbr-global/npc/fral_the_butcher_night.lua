local internalNpcName = "Fral the Butcher"
local npcType = Game.createNpcType("Fral the Butcher (Night)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 159,
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

	if MsgContains(message, "yselda") and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide) >= 1 and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FralTask) < 1 and player:getItemCount(3582) >= 20 then
		npcHandler:say({
			"Good, I can smell about 20 pieces of raw ham there in your pockets. ...",
			"Will you hand those over to me?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yselda") and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide) >= 1 and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FralTask) < 1 then
		npcHandler:say("If you want to prove trustworthy to me, I need you to bring me some raw ham, about 20 chunks if you can. Then we'll see.", npc, creature)
	elseif message:lower() == "yes" and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FralTask) < 1 then
		if npcHandler:getTopic(playerId) == 1 and player:removeItem(3582, 20) then
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FralTask, 1)
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust, player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust) + 1)
			npcHandler:say("Great, thanks. And? Oh, yes. Consider my trust... earned.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome! Looking to buy or sell some meat?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "meat", clientId = 3577, sell = 2, buy = 15 },
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
