local internalNpcName = "Berenice"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 140,
	lookHead = 5,
	lookBody = 87,
	lookLegs = 104,
	lookFeet = 106,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.ExplorerSociety.CalassaQuest) == 2 then
			npcHandler:say("OH! So you have safely returned from Calassa! Congratulations, were you able to retrieve the logbook?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheOrcPowder) > 34 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 34 then
			npcHandler:say("The most important mission we currently have is an expedition to {Calassa}.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "calassa") then
		if npcHandler:getTopic(playerId) == 1 and player:getStorageValue(Storage.ExplorerSociety.CalassaQuest) < 1 then
			npcHandler:say("Ah! So you have heard about our special mission to investigate the Quara race in their natural surrounding! Would you like to know more about it?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Captain Max will bring you to Calassa whenever you are ready. Please try to retrieve the missing logbook which must be in one of the sunken shipwrecks.", npc, creature)
			player:setStorageValue(Storage.ExplorerSociety.CalassaDoor, 1)
			player:setStorageValue(Storage.ExplorerSociety.CalassaQuest, 1)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.ExplorerSociety.CalassaQuest) == 2 then
			npcHandler:say("OH! So you have safely returned from Calassa! Congratulations, were you able to retrieve the logbook?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"Since you have already proved to be a valuable member of our society, I will happily entrust you with this mission, but there are a few things which you need to know, so listen carefully. ...",
				"Calassa is an underwater settlement, so you are in severe danger of drowning unless you are well-prepared. ...",
				"We have developed a new device called 'Helmet of the Deep' which will enable you to breathe even in the depths of the ocean. ...",
				"I will instruct Captain Max to bring you to Calassa and to lend one of these helmets to you. These helmets are very valuable, so there is a deposit of 5000 gold pieces on it. ...",
				"While in Calassa, do not take the helmet off under any circumstances. If you have any questions, don't hesitate to ask Captain Max. ...",
				"Your mission there, apart from observing the Quara, is to retrieve a special logbook from one of the shipwrecks buried there. ...",
				"One of our last expeditions there failed horribly and the ship sank, but we still do not know the exact reason. ...",
				"If you could retrieve the logbook, we'd finally know what happened. Have you understood your task and are willing to take this risk?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Excellent! I will immediately inform Captain Max to bring you to {Calassa} whenever you are ready. Don't forget to make thorough preparations!", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(21378, 1) then
				player:setStorageValue(Storage.ExplorerSociety.CalassaQuest, 3)
				npcHandler:say("Yes! That's the logbook! However... it seems that the water has already destroyed many of the pages. This is not your fault though, you did your best. Thank you!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "atlas", clientId = 6108, buy = 150 },
	{ itemName = "first verse of the hymn", clientId = 6087, sell = 100 },
	{ itemName = "fourth verse of the hymn", clientId = 6090, sell = 800 },
	{ itemName = "orichalcum pearl", clientId = 5021, buy = 80 },
	{ itemName = "second verse of the hymn", clientId = 6088, sell = 250 },
	{ itemName = "third verse of the hymn", clientId = 6089, sell = 400 }
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
