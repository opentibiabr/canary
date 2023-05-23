local internalNpcName = "Inkaef"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 114,
	lookBody = 86,
	lookLegs = 0,
	lookFeet = 86,
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

local items = {
	[VOCATION.BASE_ID.SORCERER] = 3074,
	[VOCATION.BASE_ID.DRUID] = 3066
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local itemId = items[player:getVocation():getBaseId()]
	if MsgContains(message, 'first rod') or MsgContains(message, 'first wand') then
		if player:isMage() then
			if player:getStorageValue(Storage.firstMageWeapon) == -1 then
				npcHandler:say('So you ask me for a {' .. ItemType(itemId):getName() .. '} to begin your adventure?', npc, creature)
				npcHandler:setTopic(playerId, 1)
			else
				npcHandler:say('What? I have already gave you one {' .. ItemType(itemId):getName() .. '}!', npc, creature)
			end
		else
			npcHandler:say('Sorry, you aren\'t a druid either a sorcerer.', npc, creature)
		end
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			player:addItem(itemId, 1)
			npcHandler:say('Here you are young adept, take care yourself.', npc, creature)
			player:setStorageValue(Storage.firstMageWeapon, 1)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, 'no') and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say('Ok then.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "armor rack", clientId = 6114, buy = 90 },
	{ itemName = "barrel", clientId = 2793, buy = 12 },
	{ itemName = "big table", clientId = 2785, buy = 30 },
	{ itemName = "birdcage", clientId = 2796, buy = 50 },
	{ itemName = "bookcase", clientId = 6372, buy = 70 },
	{ itemName = "box", clientId = 2469, buy = 10 },
	{ itemName = "chest", clientId = 2472, buy = 10 },
	{ itemName = "chest of drawers", clientId = 2789, buy = 18 },
	{ itemName = "chimney", clientId = 7864, buy = 200 },
	{ itemName = "crate", clientId = 2471, buy = 10 },
	{ itemName = "cuckoo clock", clientId = 2664, buy = 40 },
	{ itemName = "dresser", clientId = 2790, buy = 25 },
	{ itemName = "empty goldfish bowl", clientId = 5928, buy = 50 },
	{ itemName = "flower bowl", clientId = 2983, buy = 6 },
	{ itemName = "globe", clientId = 2797, buy = 50 },
	{ itemName = "goblin statue", clientId = 2804, buy = 50 },
	{ itemName = "god flowers", clientId = 2981, buy = 5 },
	{ itemName = "green cushioned chair", clientId = 2775, buy = 40 },
	{ itemName = "green pillow", clientId = 2396, buy = 25 },
	{ itemName = "green tapestry", clientId = 2647, buy = 25 },
	{ itemName = "harp", clientId = 2808, buy = 50 },
	{ itemName = "heart pillow", clientId = 2393, buy = 30 },
	{ itemName = "honey flower", clientId = 2984, buy = 5 },
	{ itemName = "indoor plant", clientId = 2811, buy = 8 },
	{ itemName = "knight statue", clientId = 2802, buy = 50 },
	{ itemName = "large amphora", clientId = 2805, buy = 50 },
	{ itemName = "large trunk", clientId = 2794, buy = 10 },
	{ itemName = "locker", clientId = 2791, buy = 30 },
	{ itemName = "minotaur statue", clientId = 2803, buy = 50 },
	{ itemName = "orange tapestry", clientId = 2653, buy = 25 },
	{ itemName = "oven", clientId = 6371, buy = 80 },
	{ itemName = "pendulum clock", clientId = 2801, buy = 75 },
	{ itemName = "piano", clientId = 2807, buy = 200 },
	{ itemName = "picture", clientId = 2639, buy = 50 },
	{ itemName = "picture", clientId = 2640, buy = 50 },
	{ itemName = "picture", clientId = 2641, buy = 50 },
	{ itemName = "potted flower", clientId = 2985, buy = 5 },
	{ itemName = "purple tapestry", clientId = 2644, buy = 25 },
	{ itemName = "red cushioned chair", clientId = 2775, buy = 40 },
	{ itemName = "red pillow", clientId = 2395, buy = 25 },
	{ itemName = "red tapestry", clientId = 2656, buy = 25 },
	{ itemName = "rocking chair", clientId = 2778, buy = 25 },
	{ itemName = "rocking horse", clientId = 2800, buy = 30 },
	{ itemName = "round blue pillow", clientId = 2398, buy = 25 },
	{ itemName = "round purple pillow", clientId = 2400, buy = 25 },
	{ itemName = "round red pillow", clientId = 2399, buy = 25 },
	{ itemName = "round turquoise pillow", clientId = 2401, buy = 25 },
	{ itemName = "small blue pillow", clientId = 2389, buy = 20 },
	{ itemName = "small green pillow", clientId = 2387, buy = 20 },
	{ itemName = "small orange pillow", clientId = 2390, buy = 20 },
	{ itemName = "small purple pillow", clientId = 2386, buy = 20 },
	{ itemName = "small red pillow", clientId = 2388, buy = 20 },
	{ itemName = "small round table", clientId = 2783, buy = 25 },
	{ itemName = "small table", clientId = 2782, buy = 20 },
	{ itemName = "small turquoise pillow", clientId = 2391, buy = 20 },
	{ itemName = "small white pillow", clientId = 2392, buy = 20 },
	{ itemName = "sofa chair", clientId = 2779, buy = 55 },
	{ itemName = "square table", clientId = 2784, buy = 25 },
	{ itemName = "table lamp", clientId = 2798, buy = 35 },
	{ itemName = "telescope", clientId = 2799, buy = 70 },
	{ itemName = "treasure quest", clientId = 2478, buy = 1000 },
	{ itemName = "trophy stand", clientId = 872, buy = 50 },
	{ itemName = "trough", clientId = 2792, buy = 7 },
	{ itemName = "venorean cabinet", clientId = 17974, buy = 90 },
	{ itemName = "venorean drawer", clientId = 17977, buy = 40 },
	{ itemName = "venorean wardrobe", clientId = 17975, buy = 50 },
	{ itemName = "wall mirror", clientId = 2638, buy = 40 },
	{ itemName = "water pipe", clientId = 2974, buy = 40 },
	{ itemName = "weapon rack", clientId = 6115, buy = 90 },
	{ itemName = "white tapestry", clientId = 2667, buy = 25 },
	{ itemName = "wooden chair", clientId = 2777, buy = 15 },
	{ itemName = "yellow pillow", clientId = 900, buy = 25 },
	{ itemName = "yellow tapestry", clientId = 2650, buy = 25 }
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
