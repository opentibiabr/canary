local internalNpcName = "Tarun"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 0,
	lookBody = 67,
	lookLegs = 0,
	lookFeet = 67,
	lookAddons = 2,
	lookMount = 0,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not player then
		return false
	end
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local theLostBrotherStorage = player:getStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest)
	if MsgContains(message, "mission") then
		if theLostBrotherStorage < 1 then
			npcHandler:say({
				"My brother is missing. I fear, he went to this evil palace north of here. A place of great beauty, certainly filled with riches and luxury. But in truth it is a threshold to hell and demonesses are after his blood. ...",
				"He is my brother, and I am deeply ashamed to admit but I don't dare to go there. Perhaps your heart is more courageous than mine. Would you go to see this place and search for my brother?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif theLostBrotherStorage == 1 then
			npcHandler:say("I hope you will find my brother.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif theLostBrotherStorage == 2 then
			npcHandler:say({
				"So, he is dead as I feared. I warned him not to go with this woman, but he gave in to temptation. My heart darkens and moans. But you have my sincere thanks. ...",
				"Without your help I would have stayed in the dark about his fate. Please, take this as a little recompense.",
			}, npc, creature)
			player:addItem(3039, 1)
			player:addExperience(3000, true)
			player:setStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest, 3)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say("I thank you! This is more than I could hope!", npc, creature)
			if theLostBrotherStorage < 1 then
				player:setStorageValue(Storage.Quest.U9_80.AdventurersGuild.QuestLine, 1)
			end
			player:setStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest, 1)
		elseif MsgContains(message, "no") then
			npcHandler:say("As you wish.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

local function onTradeRequest(npc, creature)
	local player = Player(creature)
	if not player then
		return false
	end
	local playerId = player:getId()

	if player:getStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest) ~= 3 then
		return false
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just have a look.")
npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "colourful feather", clientId = 11514, sell = 110 },
	{ itemName = "empty potion flask", clientId = 283, sell = 5 },
	{ itemName = "empty potion flask", clientId = 284, sell = 5 },
	{ itemName = "empty potion flask", clientId = 285, sell = 5 },
	{ itemName = "golden lotus brooch", clientId = 21974, sell = 270 },
	{ itemName = "great health potion", clientId = 239, buy = 225 },
	{ itemName = "great mana potion", clientId = 238, buy = 158 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 254 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "hellspawn tail", clientId = 10304, sell = 475 },
	{ itemName = "mammoth tusk", clientId = 10321, sell = 100 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "orc tusk", clientId = 7786, sell = 700 },
	{ itemName = "peacock feather fan", clientId = 21975, sell = 350 },
	{ itemName = "sabretooth", clientId = 10311, sell = 400 },
	{ itemName = "spider silk", clientId = 5879, sell = 100 },
	{ itemName = "strong health potion", clientId = 236, buy = 115 },
	{ itemName = "strong mana potion", clientId = 237, buy = 108 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 650 },
	{ itemName = "tusk", clientId = 3044, sell = 100 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 488 },
	{ itemName = "ultimate spirit potion", clientId = 23374, buy = 488 },
	{ itemName = "vial", clientId = 2874, sell = 5 },
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
