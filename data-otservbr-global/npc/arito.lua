local internalNpcName = "Arito"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 59,
	lookBody = 111,
	lookLegs = 99,
	lookFeet = 115,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
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

local function greetCallback(npc, player)
	if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.AritosTask) == 2 then
		npcHandler:setMessage(MESSAGE_GREET, "Thank god you are back!! Did you find....err...what we were talking about??")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Be mourned, pilgrim in flesh. Be mourned in my tavern.")
	end

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local AritosTask = player:getStorageValue(Storage.Quest.U8_1.TibiaTales.AritosTask)

	-- Check if the message contains "nomads"
	if MsgContains(message, "nomads") then
		if AritosTask <= 0 and player:getItemCount(7533) > 0 then
			npcHandler:say({
				"What?? My name on a deathlist which you retrieved from a nomad?? Show me!! ...",
				"Oh my god! They found me! You must help me! Please !!!! Are you willing to do that?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
		-- Check if the message contains "yes"
	elseif MsgContains(message, "yes") then
		local topic = npcHandler:getTopic(playerId)
		if topic == 1 then
			npcHandler:say({
				"Thank you thousand times! Well, I think I start telling you what I think they are after...",
				"You have to know, I was one of them before I opened that shop here. Sure they fear about their hideout being revealed by me. Please go to the north, there is a small cave in the mountains with a rock in the middle. ...",
				"If you stand in front of it, place a scimitar - which is the weapon of the nomads - left of you and make a sacrifice to the earth by pouring some water on the floor to your right. ...",
				"The entrance to their hideout will be revealed in front of you. I don't know who is in charge there right now but please tell him that I won't spoil their secret...",
				"... well, I just told you but anyway .... I won't tell it to anybody else. Now hurry up before they get here!!",
			}, npc, creature)
			if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart) <= 0 then
				player:setStorageValue(Storage.Quest.U8_1.TibiaTales.DefaultStart, 1)
			end
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.AritosTask, 1)
		elseif AritosTask == 2 then
			npcHandler:say("And what did they say?? Do I have to give up everything here? Come on tell me!!", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
		-- Check if the message contains "Acquitted" and topic is 2
	elseif MsgContains(message, "Acquitted") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say("These are great news!! Thank you for your help! I don't have much, but without you I wouldn't have anything so please take this as a reward.", npc, creature)
		player:setStorageValue(Storage.Quest.U8_1.TibiaTales.AritosTask, 3)
		player:addItem(3035, 100)
	end

	return true
end

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Come in, have a drink and something to eat." },
}

npcHandler:setMessage(MESSAGE_FAREWELL, "Do visit us again.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Do visit us again.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Sure, browse through my offers.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 8 },
	{ itemName = "cheese", clientId = 3607, buy = 12 },
	{ itemName = "fish", clientId = 3578, buy = 6 },
	{ itemName = "ham", clientId = 3582, buy = 16 },
	{ itemName = "ice cube", clientId = 7441, sell = 250 },
	{ itemName = "meat", clientId = 3577, buy = 10 },
	{ itemName = "mug of beer", clientId = 2880, buy = 2, count = 3 },
	{ itemName = "mug of lemonade", clientId = 2880, buy = 2, count = 12 },
	{ itemName = "mug of water", clientId = 2880, buy = 1, count = 1 },
	{ itemName = "mug of wine", clientId = 2880, buy = 3, count = 2 },
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
