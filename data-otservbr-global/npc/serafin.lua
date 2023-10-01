local internalNpcName = "Serafin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 96,
	lookBody = 123,
	lookLegs = 86,
	lookFeet = 98,
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

local BloodBrothers = Storage.Quest.U8_4.BloodBrothers
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()
	if message == "cookie" then
		if player:getStorageValue(BloodBrothers.Mission02) == 1 and player:getItemCount(8199) > 0 and player:getStorageValue(BloodBrothers.Cookies.Serafin) < 0 then
			npcHandler:say("Oh, no I don't sell cookies. Or, do you mean you'd like to give me one?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("It'd be better for you to leave now.", npc, creature)
		end
	elseif message == "yes" then
		if npcHandler:getTopic(playerId) == 1 and player:removeItem(8199, 1) then -- garlic cookie
			npcHandler:say("COUGH?! What kind of a mean trick is that? Get out of my shop!", npc, creature)
			player:setStorageValue(BloodBrothers.Cookies.Serafin, 1)
			npcHandler:setTopic(playerId, 0)
		end
	end
end
--Basic
keywordHandler:addKeyword({"alori mort"}, StdModule.say, {npcHandler = npcHandler, text = "There's something about these words which makes me feel awkward. Or maybe it's you who causes that feeling. You better get lost."}, function(player) return player:getStorageValue(BloodBrothers.Mission03) == 1 end)

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my fruit and vegetable store, |PLAYERNAME|! Ask me for a {trade} if you'd like to see my wares.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "aubergine", clientId = 11460, buy = 8 },
	{ itemName = "banana", clientId = 3587, buy = 5 },
	{ itemName = "blueberry", clientId = 3588, buy = 1 },
	{ itemName = "carrot", clientId = 3595, buy = 3 },
	{ itemName = "cherry", clientId = 3590, buy = 1 },
	{ itemName = "corncob", clientId = 3597, buy = 3 },
	{ itemName = "grapes", clientId = 3592, buy = 3 },
	{ itemName = "juice squeezer", clientId = 5865, buy = 100 },
	{ itemName = "lemon", clientId = 8013, buy = 3 },
	{ itemName = "mango", clientId = 5096, buy = 10 },
	{ itemName = "melon", clientId = 3593, buy = 10 },
	{ itemName = "orange", clientId = 3586, buy = 10 },
	{ itemName = "potato", clientId = 8010, buy = 4 },
	{ itemName = "pumpkin", clientId = 3594, buy = 10 },
	{ itemName = "strawberry", clientId = 3591, buy = 2 },
	{ itemName = "white mushroom", clientId = 3723, buy = 10 }
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
