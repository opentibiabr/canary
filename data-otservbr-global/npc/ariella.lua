local internalNpcName = "Ariella"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 155,
	lookHead = 115,
	lookBody = 3,
	lookLegs = 1,
	lookFeet = 76,
	lookAddons = 2
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,{text = "Have a drink in Meriana's only tavern!"}}

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

	if MsgContains(message, "cookie") then
		if player:getStorageValue(Storage.WhatAFoolish.Questline) == 31 and
		player:getStorageValue(Storage.WhatAFoolish.CookieDelivery.Ariella) ~= 1 then
			npcHandler:say("So you brought a cookie to a pirate?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "addon") and player:getStorageValue(Storage.OutfitQuest.PirateBaseOutfit) == 1 then
		npcHandler:say(
		"To get pirate hat you need give me Brutus Bloodbeard's Hat, \
		Lethal Lissy's Shirt, Ron the Ripper's Sabre and Deadeye Devious' Eye Patch. Do you have them with you?",
		npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "mission") then
		if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 1 then
			npcHandler:say(
			"You know, we have plenty of rum here but we lack some basic food. \
			Especially food that easily becomes mouldy is a problem. Bring me 100 breads and you will help me a lot.",
			npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 2)
		elseif player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 2 then
			npcHandler:say("Are you here to bring me the 100 pieces of bread that I requested?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 10 then
			npcHandler:say(
			{
				"The sailors always tell tales about the famous beer of Carlin. \
				You must know, alcohol is forbidden in that city. ...",
				"The beer is served in a secret whisper bar anyway. \
				Bring me a sample of the whisper beer, NOT the usual beer but whisper beer. I hope you are listening."
			},
			npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 11)
		elseif player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 12 then
			npcHandler:say("Did you get a sample of the whisper beer from Carlin?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			if not player:removeItem(130, 1) then
				npcHandler:say("You have no cookie that I'd like.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.WhatAFoolish.CookieDelivery.Ariella, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement("Allow Cookies?")
			end

			npc:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say(
			"How sweet of you ... Uhh ... OH NO ... Bozo did it again. Tell this prankster I'll pay him back.",
			npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.OutfitQuest.PirateHatAddon) == -1 then
				if player:getItemCount(6101) > 0 and player:getItemCount(6102) > 0 and player:getItemCount(6100) > 0 and
				player:getItemCount(6099) > 0
				then
					if
					player:removeItem(6101, 1) and player:removeItem(6102, 1) and player:removeItem(6100, 1) and
					player:removeItem(6099, 1)
					then
						npcHandler:say("Ah, right! The pirate hat! Here you go.", npc, creature)
						player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
						player:setStorageValue(Storage.OutfitQuest.PirateHatAddon, 1)
						player:addOutfitAddon(155, 2)
						player:addOutfitAddon(151, 2)
					end
				else
					npcHandler:say("You do not have all the required items.", npc, creature)
					npcHandler:setTopic(playerId, 0)
				end
			else
				npcHandler:say("It seems you already have this addon, don't you try to mock me son!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 2 then
				if player:removeItem(3600, 100) then
					npcHandler:say("What a joy. At least for a few days adequate supply is ensured.", npc, creature)
					player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 3)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("Come back when you got all neccessary items.", npc, creature)
					npcHandler:setTopic(playerId, 0)
				end
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 12 then
				if player:removeItem(6106, 1) then
					npcHandler:say("Thank you very much. I will test this beauty in privacy.", npc, creature)
					player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 14)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("Come back when you got the neccessary item.", npc, creature)
					npcHandler:setTopic(playerId, 0)
				end
			end
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("I see.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Alright then. Come back when you got all neccessary items.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "banana", clientId = 3587, buy = 5 },
	{ itemName = "blueberry", clientId = 3588, buy = 1 },
	{ itemName = "cheese", clientId = 3607, buy = 6 },
	{ itemName = "ham", clientId = 3582, buy = 8 },
	{ itemName = "juice squeezer", clientId = 5865, buy = 100 },
	{ itemName = "mango", clientId = 5096, buy = 10 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
	{ itemName = "melon", clientId = 3593, buy = 10 },
	{ itemName = "orange", clientId = 3586, buy = 10 },
	{ itemName = "pear", clientId = 3584, buy = 5 },
	{ itemName = "pumpkin", clientId = 3594, buy = 10 },
	{ itemName = "red apple", clientId = 3585, buy = 5 },
	{ itemName = "strawberry", clientId = 3591, buy = 2 },
	{ itemName = "valentine's cake", clientId = 6392, buy = 100 }
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
