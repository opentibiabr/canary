local internalNpcName = "Richard"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 472,
	lookHead = 97,
	lookBody = 38,
	lookLegs = 41,
	lookFeet = 0,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}
npcConfig.shop = {
	{ itemName = "backpack", clientId = 2854, buy = 10, count = 1 },
	{ itemName = "bag", clientId = 2853, buy = 4, count = 1 },
	{ itemName = "bread", clientId = 3600, buy = 3, count = 1 },
	{ itemName = "carrot", clientId = 3595, buy = 1, count = 1 },
	{ itemName = "cheese", clientId = 3607, sell = 2, count = 1 },
	{ itemName = "cherry", clientId = 3590, buy = 1, count = 1 },
	{ itemName = "egg", clientId = 3606, buy = 1, count = 1 },
	{ itemName = "fishing rod", clientId = 3483, sell = 30, count = 1 },
	{ itemName = "ham", clientId = 3582, buy = 8, count = 1 },
	{ itemName = "machete", clientId = 3308, buy = 6, count = 1 },
	{ itemName = "meat", clientId = 3577, sell = 2, count = 1 },
	{ itemName = "pick", clientId = 3456, buy = 15, count = 1 },
	{ itemName = "rope", clientId = 3003, sell = 8, count = 1 },
	{ itemName = "salmon", clientId = 3579, buy = 2, count = 1 },
	{ itemName = "scroll", clientId = 2815, buy = 5, count = 1 },
	{ itemName = "shovel", clientId = 3457, sell = 2, count = 1 },
	{ itemName = "torch", clientId = 2920, buy = 2, count = 1 },
	{ itemName = "worm", clientId = 3492, buy = 1, count = 1 }
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

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "Don't forget to always have a rope with you! Buy one here, only the best quality!"},
	{text = "Don't complain to ME when you fell down a hole without a rope to get you out! You can buy one here now!"},
	{text = "Everything an adventurer needs!"},
	{text = "A rope is the adventurer's best friend!"},
	{text = "Fresh meat! Durable provisions! Ropes and shovels!"},
	{text = "Feeling like a bit of treasure-seeking? \z
		Buy a shovel or a pick and investigate likely-looking stone piles and cracks!"}
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

	if MsgContains(message, "job") then
		npcHandler:say(
			{
				"I was a carpenter, back on Main. Wanted my own little shop. Didn't sit with the old man. \z
					So I shipped to somewhere else. Terrible storm.",
				"Woke up on this island. Had to eat squirrels before the adventurers found me and took me in. End of story."
			},
		npc, creature, 10)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "rope") then
		npcHandler:say(
			{
				"Only the best quality, I assure you. A rope in need is a friend indeed! Imagine you stumble into a rat \z
					hole without a rope - heh, your bones will be gnawed clean before someone finds ya!",
				"Now, about that rope - ask me for equipment to see my wares. <winks>"
			},
		npc, creature, 10)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({'name'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Richard. Just Richard. Lost my surname with my past in that storm. <winks>"
	}
)
keywordHandler:addKeyword({'dawnport'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "This lovely island here. Once I didn't have to live off squirrels, it became quite enjoyable. \z
			Nasty things though live underground, so take care where you tread and ALWAYS have a rope with you!"
	}
)
keywordHandler:addKeyword({'rookgaard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "<shrugs> Never been, mate. Heard it's kinda cute, though."
	}
)
keywordHandler:addKeyword({'coltrayne'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You know, I really don't want to poke into someone else's private life. \z
			Suffice it to say that everyone has chapters of his life he doesn't want to mention. \z
			Judging by Coltrayne's looks, we're looking at a trilogy here."
	}
)
keywordHandler:addKeyword({'inigo'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Old Inigo was the one who found me, actually, and brought me to the outpost. \z
			I was half starved by then. He taught me how to make better traps and how to fish... I owe much to Inigo."
	}
)
keywordHandler:addKeyword({'garamond'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Can you believe how old he is? He won't say it, \z
			but I wouldn't be surprised if he had been around for loooooong time."
	}
)
keywordHandler:addKeyword({'squirrel'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Don't talk to ME about squirrels! <shudders> Had to live off them the first days, \z
			when they were the only thing to go into my self-made acorn traps. Nasty."
	}
)
keywordHandler:addKeyword({'mr morris'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Don't know what to make of him. Great researcher in all Dawnport matters, though. \z
			Always has a quest or two where he needs help, if you're looking for adventuring work."
	}
)
keywordHandler:addKeyword({'oressa'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Quiet little lady, her. Knows her way around the isle, looking for herbs and stuff \z
			but mostly spends her time in the temple, helping younglings like you choose a vocation."
	}
)
keywordHandler:addKeyword({'plunderpurse'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You know, on the day that ol' pirate decides to make off with all that gold in the bank, \z
			I'm gonna come with him. Should be much more fun landing on a strange island with some gold \z
			to spend on booze and babes! <winks>"
	}
)
keywordHandler:addKeyword({'hamish'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Tries to act tough, but he's quite a witty and decent bloke who wouldn't hurt a fly. \z
			We enjoy a good laugh together in the evenings."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Hello there, mate. Here for a {trade}? My stock's just been refilled.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares. \z
	You can also have a look at food or {equipment} only.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Have fun!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
