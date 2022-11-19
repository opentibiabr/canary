local internalNpcName = "Mirabell"
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
	lookHead = 96,
	lookBody = 12,
	lookLegs = 87,
	lookFeet = 77,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'The Horn of Plenty is always open for tired adventurers.'}
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


	if MsgContains(message, 'pies') then
		if player:getStorageValue(Storage.WhatAFoolish.PieBuying) == -1 then
			npcHandler:say('Oh you\'ve heard about my excellent pies, didn\'t you? I am flattered. Unfortunately I\'m completely out of flour. I need 2 portions of flour for one pie. Just tell me when you have enough flour for your pies.', npc, creature)
			return true
		end

		npcHandler:say('For 12 pies this is 240 gold. Do you want to buy them?', npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, 'flour') then
		npcHandler:say('Do you bring me the flour needed for your pies?', npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			if not player:removeItem(3603, 24) then
				npcHandler:say('I think you are confusing the dust in your pockets with flour. You certainly do not have enough flour for 12 pies.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.PieBuying, player:getStorageValue(Storage.WhatAFoolish.PieBuying) + 1)
			npcHandler:say('Excellent. Now I can start baking the pies. As you helped me, I will make you a good price for them.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if not player:removeMoneyBank(240) then
				npcHandler:say('You don\'t have enough money, don\'t try to fool me.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:addItem(119, 1)
			player:setStorageValue(Storage.WhatAFoolish.PieBuying, player:getStorageValue(Storage.WhatAFoolish.PieBuying) - 1)
			player:setStorageValue(Storage.WhatAFoolish.PieBoxTimer, os.time() + 1200) -- 20 minutes to deliver
			npcHandler:say({
				'Here they are. Wait! Two things you should know: Firstly, they won\'t last long in the sun so you better get them to their destination as quickly as possible ...',
				'Secondly, since my pies are that delicious it is forbidden to leave the town with them. We can\'t afford to attract more tourists to Edron.'
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'no') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say('Without flour I can\'t do anything, sorry.', npc, creature)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say('What are you? Some kind of fool?', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

keywordHandler:addKeyword({'drink'}, StdModule.say, {npcHandler = npcHandler, text = 'I can offer you beer, wine, lemonade and water. If you\'d like to see my offers, ask me for a {trade}.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you looking for food? I have bread, cheese, ham, and meat. If you\'d like to see my offers, ask me for a {trade}.'})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the Horn of Plenty, |PLAYERNAME|. Sit down, have a {drink} or some {food}!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Come back soon, traveller.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back soon, traveller.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, take a look at my tasty offers.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 4 },
	{ itemName = "cheese", clientId = 3607, buy = 6 },
	{ itemName = "ham", clientId = 3582, buy = 8 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
	{ itemName = "mug of beer", clientId = 2880, buy = 2, count = 3 },
	{ itemName = "mug of lemonade", clientId = 2880, buy = 2, count = 12 },
	{ itemName = "mug of water", clientId = 2880, buy = 1, count = 1 },
	{ itemName = "mug of wine", clientId = 2880, buy = 3, count = 2 }
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
