local internalNpcName = "Tournament Merchant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = "Tournament Merchant"
npcConfig.description = "Tournament Merchant"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

npcConfig.outfit = {
	lookType = 146,
	lookHead = 95,
	lookBody = 57,
	lookLegs = 125,
	lookFeet = 38,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 20000,
	chance = 50,{text = "Compro seus Tournaments!"}}

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
    local player = Player(creature)
    if not player then
        return false
    end
    
   -- if message:lower() == "hi" then
        local accID = player:getAccountId()
        local resultId = db.storeQuery(string.format('SELECT `tournament_coins` FROM `accounts` WHERE `id` = %d;', accID))
        
        if resultId then
            local coins = result.getDataInt(resultId, "tournament_coins")
            result.free(resultId)
            
			player:sendTextMessage(MESSAGE_FAILURE, string.format("Olá! Você possui %d Tournament Coins", coins))
        else
            npc:say("Bem-Vindo ao Tournament Shop", TALKTYPE_SAY)
        end
   -- end
	npcHandler:onSay(npc, creature, type, message)

    return true
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


	if MsgContains(message, "addon") and player:getStorageValue(Storage.OutfitQuest.PirateBaseOutfit) == 1 then
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
    { itemName = "Conch Shell Horn", clientId = 43863, buy = 500 },
    { itemName = "Scarab Ocarina", clientId = 43740, buy = 500 },
    { itemName = "Anniversary Backpack", clientId = 14674, buy = 300 },
    { itemName = "Birthday Backpack", clientId = 24395, buy = 300 },
    { itemName = "Blessed Wooden Stake", clientId = 5942, buy = 350 },
    { itemName = "Blossom Bag", clientId = 25780, buy = 450 },
    { itemName = "Blueberry Cupcake", clientId = 28484, buy = 150 },
    { itemName = "Bone Fiddle", clientId = 28493, buy = 300 },
    { itemName = "Cake Backpack", clientId = 20347, buy = 300 },
    { itemName = "Crown", clientId = 3011, buy = 30000 },
    { itemName = "Crown Backpack", clientId = 9605, buy = 300 },
    { itemName = "Demonic Candy Ball", clientId = 11587, buy = 150 },
    { itemName = "Energetic Backpack", clientId = 23525, buy = 300 },
    { itemName = "Epiphany", clientId = 8103, buy = 12000 },
    { itemName = "Gleaming Starlight Vial", clientId = 25732, buy = 300 },
    { itemName = "Gold Token", clientId = 22721, buy = 20 },
    { itemName = "Golden Helmet", clientId = 3365, buy = 30000 },
    { itemName = "Lemon Cupcake", clientId = 28486, buy = 150 },
    { itemName = "Lit Torch", clientId = 34017, buy = 1500 },
    { itemName = "Magic Longsword", clientId = 3278, buy = 15000 },
    { itemName = "Magical Torch", clientId = 9042, buy = 1500 },
    { itemName = "Major Crystalline Token", clientId = 16129, buy = 50 },
    { itemName = "Minor Crystalline Token", clientId = 16128, buy = 150 },
    { itemName = "Minotaur Backpack", clientId = 10327, buy = 300 },
    { itemName = "Moon Mirror", clientId = 25975, buy = 300 },
    { itemName = "Obsidian Knife", clientId = 5908, buy = 350 },
    { itemName = "Pannier Backpack", clientId = 19159, buy = 300 },
    { itemName = "Santa Backpack", clientId = 10346, buy = 300 },
    { itemName = "Shining Sun Catcher", clientId = 25734, buy = 300 },
    { itemName = "Silver Raid Token", clientId = 19083, buy = 80 },
    { itemName = "Silver Token", clientId = 22516, buy = 20 },
    { itemName = "Sneaky Stabber of Eliteness", clientId = 9595, buy = 600 },
    { itemName = "Solar Axe", clientId = 8097, buy = 15000 },
    { itemName = "Squeezing Gear of Girlpower", clientId = 9597, buy = 700 },
    { itemName = "Strawberry Cupcake", clientId = 28485, buy = 150 },
    { itemName = "Swan Feather Cloak", clientId = 25779, buy = 2500 },
    { itemName = "Tiara of Power", clientId = 23475, buy = 200 },
    { itemName = "Werewolf Helmet", clientId = 22062, buy = 200 },
    { itemName = "Whacking Driller of Fate", clientId = 9599, buy = 600 },
    { itemName = "Winged Backpack", clientId = 31625, buy = 300 },
    { itemName = "Yellow Rose", clientId = 3660, buy = 10000 },
    { itemName = "Zaoan Chess Box", clientId = 18339, buy = 1000 },
	{ itemName = "durable exercise wand", clientId = 35284, buy = 300 },
	{ itemName = "durable exercise rod", clientId = 35283, buy = 300 },
	{ itemName = "durable exercise bow", clientId = 35282, buy = 300 },
	{ itemName = "durable exercise sword", clientId = 35279, buy = 300 },
	{ itemName = "durable exercise club", clientId = 35281, buy = 300 },
	{ itemName = "durable exercise axe", clientId = 35280, buy = 300 },
}


-- On buy npc shop message
local function getPlayerTournamentCoins(accID)

	local resultId = db.storeQuery(string.format('SELECT `tournament_coins` FROM `accounts` WHERE `id` = %i;', accID))
    if resultId then
            days = result.getDataInt(resultId, "tournament_coins")
			result.free(resultId)

			return days
		end
end


npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
    local accID = player:getAccountId()

    -- Check if the player has enough tournament_coins
    local playerCoins = getPlayerTournamentCoins(accID)
    if playerCoins >= totalCost then
        local updateQuery = string.format('UPDATE `accounts` SET `tournament_coins` = `tournament_coins` - %i WHERE `id` = %i', totalCost, accID)
        local updateResult = db.query(updateQuery)

        if updateResult then
            npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
            local updatedTournaments = getPlayerTournamentCoins(accID) -- Pass accID as an argument
            player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sucesso! Agora você possui %d Tournament Coins", updatedTournaments))
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "An error occurred while processing your purchase.")
        end
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Você não possui Tournament Coins o suficiente para comprar este item.")
    end
end





-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
