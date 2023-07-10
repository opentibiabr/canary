local internalNpcName = "Eddy"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 22,
	lookBody = 63,
	lookLegs = 19,
	lookFeet = 95,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Have you moved to a new home? I\'m the specialist for equipping it.'}
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

keywordHandler:addKeyword({'furniture'}, StdModule.say, {npcHandler = npcHandler, text = "I have {beds}, {chairs}, {containers}, {decoration}, {flowers}, {instruments}, {pillows}, {pottery}, {statues}, {tapestries} and {tables}. Which of those would you like to see?"})

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! Do you need some equipment for your house?")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Have a look. Most furniture comes in handy kits. Just use them in your house to assemble the furniture. Do you want to see only a certain {type} of furniture?")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "amphora", clientId = 2893, buy = 4 },
	{ itemName = "armor rack kit", clientId = 6114, buy = 90 },
	{ itemName = "barrel kit", clientId = 2793, buy = 12 },
	{ itemName = "big table kit", clientId = 2785, buy = 30 },
	{ itemName = "birdcage kit", clientId = 2796, buy = 50 },
	{ itemName = "blue bed kit", clientId = 834, buy = 80 },
	{ itemName = "blue pillow", clientId = 2394, buy = 25 },
	{ itemName = "blue tapestry", clientId = 2659, buy = 25 },
	{ itemName = "bookcase kit", clientId = 6372, buy = 70 },
	{ itemName = "box", clientId = 2469, buy = 10 },
	{ itemName = "canopy bed kit", clientId = 17972, buy = 200 },
	{ itemName = "chest", clientId = 2472, buy = 10 },
	{ itemName = "chimney kit", clientId = 7864, buy = 200 },
	{ itemName = "coal basin kit", clientId = 2806, buy = 25 },
	{ itemName = "crate", clientId = 2471, buy = 10 },
	{ itemName = "cuckoo clock", clientId = 2664, buy = 40 },
	{ itemName = "drawer kit", clientId = 2789, buy = 18 },
	{ itemName = "dresser kit", clientId = 2790, buy = 25 },
	{ itemName = "empty goldfish bowl", clientId = 5928, buy = 50 },
	{ itemName = "flower bowl", clientId = 2983, buy = 6 },
	{ itemName = "globe kit", clientId = 2800, buy = 50 },
	{ itemName = "goblin statue kit", clientId = 2804, buy = 50 },
	{ itemName = "god flowers", clientId = 2981, buy = 5 },
	{ itemName = "green bed kit", clientId = 831, buy = 80 },
	{ itemName = "green cushioned chair kit", clientId = 2776, buy = 40 },
	{ itemName = "green pillow", clientId = 2396, buy = 25 },
	{ itemName = "green tapestry", clientId = 2647, buy = 25 },
	{ itemName = "harp kit", clientId = 2808, buy = 50 },
	{ itemName = "heart pillow", clientId = 2393, buy = 30 },
	{ itemName = "honey flower", clientId = 2984, buy = 5 },
	{ itemName = "indoor plant kit", clientId = 2811, buy = 8 },
	{ itemName = "knight statue kit", clientId = 2802, buy = 50 },
	{ itemName = "large amphora kit", clientId = 2805, buy = 50 },
	{ itemName = "locker kit", clientId = 2791, buy = 30 },
	{ itemName = "minotaur statue kit", clientId = 2803, buy = 50 },
	{ itemName = "orange tapestry", clientId = 2653, buy = 25 },
	{ itemName = "oven kit", clientId = 6371, buy = 80 },
	{ itemName = "pendulum clock kit", clientId = 2801, buy = 75 },
	{ itemName = "piano kit", clientId = 2807, buy = 200 },
	{ itemName = "picture", clientId = 2639, buy = 50 },
	{ itemName = "picture", clientId = 2640, buy = 50 },
	{ itemName = "picture", clientId = 2641, buy = 50 },
	{ itemName = "potted flower", clientId = 2985, buy = 5 },
	{ itemName = "purple tapestry", clientId = 2644, buy = 25 },
	{ itemName = "red bed kit", clientId = 833, buy = 80 },
	{ itemName = "red cushioned chair kit", clientId = 2775, buy = 40 },
	{ itemName = "red pillow", clientId = 2395, buy = 25 },
	{ itemName = "red tapestry", clientId = 2656, buy = 25 },
	{ itemName = "rocking chair kit", clientId = 2778, buy = 25 },
	{ itemName = "rocking horse kit", clientId = 2800, buy = 30 },
	{ itemName = "round blue pillow", clientId = 2398, buy = 25 },
	{ itemName = "round purple pillow", clientId = 2400, buy = 25 },
	{ itemName = "round red pillow", clientId = 2399, buy = 25 },
	{ itemName = "round table kit", clientId = 2783, buy = 25 },
	{ itemName = "round turquoise pillow", clientId = 2401, buy = 25 },
	{ itemName = "small blue pillow", clientId = 2389, buy = 20 },
	{ itemName = "small green pillow", clientId = 2387, buy = 20 },
	{ itemName = "small orange pillow", clientId = 2390, buy = 20 },
	{ itemName = "small purple pillow", clientId = 2386, buy = 20 },
	{ itemName = "small red pillow", clientId = 2388, buy = 20 },
	{ itemName = "small table kit", clientId = 2782, buy = 20 },
	{ itemName = "small turquoise pillow", clientId = 2391, buy = 20 },
	{ itemName = "small white pillow", clientId = 2392, buy = 20 },
	{ itemName = "sofa chair kit", clientId = 2779, buy = 55 },
	{ itemName = "square table kit", clientId = 2784, buy = 25 },
	{ itemName = "table lamp kit", clientId = 2798, buy = 35 },
	{ itemName = "telescope kit", clientId = 2799, buy = 70 },
	{ itemName = "treasure chest", clientId = 2478, buy = 1000 },
	{ itemName = "trophy stand", clientId = 872, buy = 50 },
	{ itemName = "trough kit", clientId = 2792, buy = 7 },
	{ itemName = "trunk kit", clientId = 2794, buy = 10 },
	{ itemName = "vase", clientId = 2876, buy = 3 },
	{ itemName = "wall mirror", clientId = 2638, buy = 40 },
	{ itemName = "water pipe", clientId = 2980, buy = 40 },
	{ itemName = "weapon rack kit", clientId = 6115, buy = 90 },
	{ itemName = "white tapestry", clientId = 2667, buy = 25 },
	{ itemName = "wooden chair kit", clientId = 2777, buy = 15 },
	{ itemName = "yellow bed kit", clientId = 832, buy = 80 },
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
