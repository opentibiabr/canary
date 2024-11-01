local internalNpcName = "Iwar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 160,
	lookHead = 115,
	lookBody = 127,
	lookLegs = 123,
	lookFeet = 76,
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
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local valuePicture = 10000

	if MsgContains(message, "has the cat got your tongue?") and player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission) == 4 then
		npcHandler:say("Nice. You like your picture, haa? Give me 10,000 gold and I will deliver it to the museum. Do you {pay}?", npc, creature)
		npcHandler:setTopic(playerId, 2)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "pay") or MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			if (player:getMoney() + player:getBankBalance()) >= valuePicture then
				npcHandler:say("Well done. The picture will be delivered to the museum as last as possible.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				npcHandler:setTopic(playerId, 0)
				player:removeMoneyBank(valuePicture)
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 5)
			else
				npcHandler:say("You don't have enough money.", npc, creature)
				npcHandler:setTopic(playerId, 1)
				npcHandler:setTopic(playerId, 1)
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hiho Storm Killer! Welcome to Kazordoon furniture store.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "amphora", clientId = 2893, buy = 4 },
	{ itemName = "armor rack kit", clientId = 6111, buy = 90 },
	{ itemName = "barrel kit", clientId = 2523, buy = 12 },
	{ itemName = "big table kit", clientId = 2314, buy = 30 },
	{ itemName = "birdcage kit", clientId = 2976, buy = 50 },
	{ itemName = "blue footboard", clientId = 32482, buy = 40 },
	{ itemName = "blue headboard", clientId = 32473, buy = 40 },
	{ itemName = "blue pillow", clientId = 2394, buy = 25 },
	{ itemName = "blue tapestry", clientId = 2659, buy = 25 },
	{ itemName = "bookcase kit", clientId = 6370, buy = 70 },
	{ itemName = "box", clientId = 2469, buy = 10 },
	{ itemName = "canopy footboard", clientId = 32490, buy = 40 },
	{ itemName = "canopy headboard", clientId = 32481, buy = 40 },
	{ itemName = "chest", clientId = 2472, buy = 10 },
	{ itemName = "chimney kit", clientId = 7860, buy = 200 },
	{ itemName = "coal basin kit", clientId = 3513, buy = 25 },
	{ itemName = "cot footboard", clientId = 32486, buy = 40 },
	{ itemName = "cot headboard", clientId = 32477, buy = 40 },
	{ itemName = "crate", clientId = 2471, buy = 10 },
	{ itemName = "cuckoo clock", clientId = 2664, buy = 40 },
	{ itemName = "drawer kit", clientId = 2433, buy = 18 },
	{ itemName = "dresser kit", clientId = 2441, buy = 25 },
	{ itemName = "empty goldfish bowl", clientId = 5928, buy = 50 },
	{ itemName = "flower bowl", clientId = 2983, buy = 6 },
	{ itemName = "globe kit", clientId = 2998, buy = 50 },
	{ itemName = "goblin statue kit", clientId = 2030, buy = 50 },
	{ itemName = "god flowers", clientId = 2981, buy = 5 },
	{ itemName = "green cushioned chair kit", clientId = 2378, buy = 40 },
	{ itemName = "green footboard", clientId = 32483, buy = 40 },
	{ itemName = "green headboard", clientId = 32474, buy = 40 },
	{ itemName = "green pillow", clientId = 2396, buy = 25 },
	{ itemName = "green tapestry", clientId = 2647, buy = 25 },
	{ itemName = "hammock foot section", clientId = 32487, buy = 40 },
	{ itemName = "hammock head section", clientId = 32478, buy = 40 },
	{ itemName = "harp kit", clientId = 2963, buy = 50 },
	{ itemName = "heart pillow", clientId = 2393, buy = 30 },
	{ itemName = "honey flower", clientId = 2984, buy = 5 },
	{ itemName = "indoor plant kit", clientId = 2982, buy = 8 },
	{ itemName = "knight statue kit", clientId = 2025, buy = 50 },
	{ itemName = "large amphora kit", clientId = 2904, buy = 50 },
	{ itemName = "locker kit", clientId = 2449, buy = 30 },
	{ itemName = "minotaur statue kit", clientId = 2029, buy = 50 },
	{ itemName = "orange tapestry", clientId = 2653, buy = 25 },
	{ itemName = "oven kit", clientId = 6355, buy = 80 },
	{ itemName = "pendulum clock kit", clientId = 2445, buy = 75 },
	{ itemName = "piano kit", clientId = 2959, buy = 200 },
	{ itemName = "picture", clientId = 2639, buy = 50 },
	{ itemName = "picture", clientId = 2640, buy = 50 },
	{ itemName = "picture", clientId = 2641, buy = 50 },
	{ itemName = "potted flower", clientId = 2985, buy = 5 },
	{ itemName = "purple tapestry", clientId = 2644, buy = 25 },
	{ itemName = "red cushioned chair kit", clientId = 2374, buy = 40 },
	{ itemName = "red footboard", clientId = 32484, buy = 40 },
	{ itemName = "red headboard", clientId = 32475, buy = 40 },
	{ itemName = "red pillow", clientId = 2395, buy = 25 },
	{ itemName = "red tapestry", clientId = 2656, buy = 25 },
	{ itemName = "rocking chair kit", clientId = 2382, buy = 25 },
	{ itemName = "rocking horse kit", clientId = 2998, buy = 30 },
	{ itemName = "round blue pillow", clientId = 2398, buy = 25 },
	{ itemName = "round purple pillow", clientId = 2400, buy = 25 },
	{ itemName = "round red pillow", clientId = 2399, buy = 25 },
	{ itemName = "round table kit", clientId = 2316, buy = 25 },
	{ itemName = "round turquoise pillow", clientId = 2401, buy = 25 },
	{ itemName = "simple footboard", clientId = 32488, buy = 40 },
	{ itemName = "simple headboard", clientId = 32479, buy = 40 },
	{ itemName = "small blue pillow", clientId = 2389, buy = 20 },
	{ itemName = "small green pillow", clientId = 2387, buy = 20 },
	{ itemName = "small orange pillow", clientId = 2390, buy = 20 },
	{ itemName = "small purple pillow", clientId = 2386, buy = 20 },
	{ itemName = "small red pillow", clientId = 2388, buy = 20 },
	{ itemName = "small table kit", clientId = 2319, buy = 20 },
	{ itemName = "small turquoise pillow", clientId = 2391, buy = 20 },
	{ itemName = "small white pillow", clientId = 2392, buy = 20 },
	{ itemName = "sofa chair kit", clientId = 2366, buy = 55 },
	{ itemName = "square table kit", clientId = 2315, buy = 25 },
	{ itemName = "straw mat foot section", clientId = 32489, buy = 40 },
	{ itemName = "straw mat head section", clientId = 32480, buy = 40 },
	{ itemName = "table lamp kit", clientId = 2934, buy = 35 },
	{ itemName = "telescope kit", clientId = 3485, buy = 70 },
	{ itemName = "treasure chest", clientId = 2478, buy = 1000 },
	{ itemName = "trophy stand", clientId = 872, buy = 50 },
	{ itemName = "trough kit", clientId = 2524, buy = 7 },
	{ itemName = "trunk kit", clientId = 2483, buy = 10 },
	{ itemName = "vase", clientId = 2876, buy = 3 },
	{ itemName = "venorean cabinet kit", clientId = 18015, buy = 90 },
	{ itemName = "venorean drawer kit", clientId = 18019, buy = 40 },
	{ itemName = "venorean wardrobe kit", clientId = 18017, buy = 50 },
	{ itemName = "wall mirror", clientId = 2638, buy = 40 },
	{ itemName = "water pipe", clientId = 2980, buy = 40 },
	{ itemName = "weapon rack kit", clientId = 6109, buy = 90 },
	{ itemName = "white tapestry", clientId = 2667, buy = 25 },
	{ itemName = "wooden chair kit", clientId = 2360, buy = 15 },
	{ itemName = "yellow footboard", clientId = 32485, buy = 40 },
	{ itemName = "yellow headboard", clientId = 32476, buy = 40 },
	{ itemName = "yellow pillow", clientId = 900, buy = 25 },
	{ itemName = "yellow tapestry", clientId = 2650, buy = 25 },
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
