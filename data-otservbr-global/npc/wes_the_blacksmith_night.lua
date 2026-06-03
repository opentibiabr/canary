local internalNpcName = "Wes the Blacksmith"
local npcType = Game.createNpcType("Wes the Blacksmith (Night)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 134,
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

	if MsgContains(message, "yselda") and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide) >= 1 and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.WesTask) < 1 then
		if npcHandler:getTopic(playerId) == 0 then
			npcHandler:say({
				"Ah yes, right. You came to the right place, ahem. ...",
				"Well, for quite some time we are planning to help our king during this awful siege. As you know the passphrase, one of us already trusts you. ...",
				"Outsiders are not welcome here during the siege. If you want to get into the castle, you will have to earn all our trust. ...",
				"If you can do that, a member of the lion guard who is in contact with us, will let you in. ...",
				"Just ask any of us the passphrase and we will see what we can do for you.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.WesTask, 1)
		elseif npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Alright then, let's see if you are really trustworthy. I need more material to forge better equipment for our men. ...",
				"Bring me about 20 broken longbows from fallen usurpers and we will see.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yselda") and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.WesTask) == 1 then
		npcHandler:say({
			"Alright then, let's see if you are really trustworthy. You have about 20 broken longbows there, this is exactly what I need to fulfill my next order from the king. ...",
			"Are you willing to hand them over to me?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif message:lower() == "yes" and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.WesTask) == 1 then
		if npcHandler:getTopic(playerId) == 1 and player:removeItem(34161, 20) then
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.WesTask, 2)
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust, player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust) + 1)
			npcHandler:say("Excellent, just what I needed. You have earned my trust, traveller. Good luck!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Hail, customer! Welcome to Wes and son, blacksmith (and teacher). Can I do something for you?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "axe", clientId = 3274, buy = 20, sell = 7 },
	{ itemName = "battle axe", clientId = 3266, buy = 235, sell = 80 },
	{ itemName = "battle hammer", clientId = 3305, buy = 350, sell = 120 },
	{ itemName = "battle shield", clientId = 3413, sell = 95 },
	{ itemName = "bone club", clientId = 3337, sell = 5 },
	{ itemName = "bone sword", clientId = 3338, buy = 75, sell = 20 },
	{ itemName = "brass armor", clientId = 3359, buy = 450, sell = 150 },
	{ itemName = "brass helmet", clientId = 3354, buy = 120, sell = 30 },
	{ itemName = "brass legs", clientId = 3372, buy = 195, sell = 49 },
	{ itemName = "brass shield", clientId = 3411, buy = 65, sell = 25 },
	{ itemName = "carlin sword", clientId = 3283, buy = 473, sell = 118 },
	{ itemName = "chain armor", clientId = 3358, buy = 200, sell = 70 },
	{ itemName = "chain helmet", clientId = 3352, buy = 52, sell = 17 },
	{ itemName = "chain legs", clientId = 3558, buy = 80, sell = 25 },
	{ itemName = "club", clientId = 3270, buy = 5, sell = 1 },
	{ itemName = "coat", clientId = 3562, buy = 8, sell = 1 },
	{ itemName = "copper shield", clientId = 3430, sell = 50 },
	{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
	{ itemName = "dagger", clientId = 3267, buy = 5, sell = 2 },
	{ itemName = "double axe", clientId = 3275, sell = 260 },
	{ itemName = "doublet", clientId = 3379, buy = 16, sell = 3 },
	{ itemName = "dwarven shield", clientId = 3425, buy = 500, sell = 100 },
	{ itemName = "fire sword", clientId = 3280, sell = 1000 },
	{ itemName = "halberd", clientId = 3269, sell = 400 },
	{ itemName = "hand axe", clientId = 3268, buy = 8, sell = 4 },
	{ itemName = "hatchet", clientId = 3276, sell = 25 },
	{ itemName = "iron helmet", clientId = 3353, buy = 390, sell = 150 },
	{ itemName = "jacket", clientId = 3561, buy = 12, sell = 1 },
	{ itemName = "katana", clientId = 3300, sell = 35 },
	{ itemName = "leather armor", clientId = 3361, buy = 35, sell = 12 },
	{ itemName = "leather helmet", clientId = 3355, buy = 12, sell = 4 },
	{ itemName = "leather legs", clientId = 3559, buy = 10, sell = 9 },
	{ itemName = "legion helmet", clientId = 3374, sell = 22 },
	{ itemName = "longsword", clientId = 3285, buy = 160, sell = 51 },
	{ itemName = "mace", clientId = 3286, buy = 90, sell = 30 },
	{ itemName = "morning star", clientId = 3282, buy = 430, sell = 100 },
	{ itemName = "nunchaku", clientId = 3347, buy = 405, sell = 135 },
	{ itemName = "orcish axe", clientId = 3316, sell = 350 },
	{ itemName = "pair of monk fists", clientId = 7423, buy = 270, sell = 90 },
	{ itemName = "plate armor", clientId = 3357, buy = 1200, sell = 400 },
	{ itemName = "plate legs", clientId = 3557, sell = 115 },
	{ itemName = "plate shield", clientId = 3410, buy = 125, sell = 45 },
	{ itemName = "rapier", clientId = 3272, buy = 15, sell = 5 },
	{ itemName = "sabre", clientId = 3273, buy = 35, sell = 12 },
	{ itemName = "sai", clientId = 10389, buy = 540, sell = 180 },
	{ itemName = "scale armor", clientId = 3377, buy = 260, sell = 75 },
	{ itemName = "short sword", clientId = 3294, buy = 26, sell = 10 },
	{ itemName = "sickle", clientId = 3293, buy = 7, sell = 3 },
	{ itemName = "soldier helmet", clientId = 3375, buy = 110, sell = 16 },
	{ itemName = "spike sword", clientId = 3271, buy = 8000, sell = 240 },
	{ itemName = "steel helmet", clientId = 3351, buy = 580, sell = 293 },
	{ itemName = "steel shield", clientId = 3409, buy = 240, sell = 80 },
	{ itemName = "studded armor", clientId = 3378, buy = 90, sell = 25 },
	{ itemName = "studded club", clientId = 3336, sell = 10 },
	{ itemName = "studded helmet", clientId = 3376, buy = 63, sell = 20 },
	{ itemName = "studded legs", clientId = 3362, buy = 50, sell = 15 },
	{ itemName = "studded shield", clientId = 3426, buy = 50, sell = 16 },
	{ itemName = "swampling club", clientId = 17824, sell = 40 },
	{ itemName = "sword", clientId = 3264, buy = 85, sell = 25 },
	{ itemName = "throwing knife", clientId = 3298, buy = 25, sell = 2 },
	{ itemName = "two handed sword", clientId = 3265, buy = 950, sell = 450 },
	{ itemName = "viking helmet", clientId = 3367, buy = 265, sell = 66 },
	{ itemName = "viking shield", clientId = 3431, buy = 260, sell = 85 },
	{ itemName = "war hammer", clientId = 3279, buy = 10000, sell = 470 },
	{ itemName = "wooden shield", clientId = 3412, buy = 15, sell = 5 },
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
