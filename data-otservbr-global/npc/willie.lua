local internalNpcName = "Willie"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 153,
	lookHead = 77,
	lookBody = 63,
	lookLegs = 58,
	lookFeet = 115,
	lookAddons = 1
}

npcConfig.flags = {
	floorchange = false
}
npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, sell = 1, count = 1 },
	{ itemName = "cheese", clientId = 3607, sell = 2, count = 1 },
	{ itemName = "cherry", clientId = 3590, sell = 1, count = 1 },
	{ itemName = "egg", clientId = 3606, sell = 1, count = 1 },
	{ itemName = "ham", clientId = 3582, sell = 4, count = 1 },
	{ itemName = "meat", clientId = 3577, sell = 2, count = 1 },
	{ itemName = "salmon", clientId = 3579, sell = 2, count = 1 }
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
	{ text = "Ah, what the heck.Make sure you know what you want before you bug me." },
	{ text = "Buying and selling food!" },
	{ text = "Make sure you know what you want before you bug me." },
	{ text = "You, over there! Stop sniffing around my farm! Either trade with me or leave!" }
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


-- Basic keywords
keywordHandler:addKeyword({"offer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Haven't they taught you anything at school? Ask for a {trade} if you want to trade."
	}
)
keywordHandler:addAliasKeyword({"sell"})
keywordHandler:addAliasKeyword({"buy"})
keywordHandler:addAliasKeyword({"food"})

keywordHandler:addKeyword({"information"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Help yourself. Or ask the other {citizens}, I don't have time for that."
	}
)
keywordHandler:addAliasKeyword({"help"})
keywordHandler:addAliasKeyword({"hint"})

keywordHandler:addKeyword({"how", "are", "you"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Fine enough."
	}
)
keywordHandler:addKeyword({"name"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Willie."
	}
)
keywordHandler:addKeyword({"job"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a farmer and a cook."
	}
)
keywordHandler:addKeyword({"cook"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I try out old and new {recipes}. You can sell all {food} to me."
	}
)
keywordHandler:addKeyword({"recipe"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'd love to try a banana pie but I lack the {bananas}. If you get me one, I'll reward you."
	}
)
keywordHandler:addKeyword({"citizen"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Which one?"
	}
)
keywordHandler:addKeyword({"rookgaard"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "This island would be wonderful if there weren't a constant flood of newcomers."
	}
)
keywordHandler:addKeyword({"tibia"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "If I were you, I'd stay here."
	}
)
keywordHandler:addKeyword({"spell"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I know how to spell."
	}
)
keywordHandler:addKeyword({"magic"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a magician in the kitchen."
	}
)
keywordHandler:addKeyword({"weapon"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm not in the weapon business, so stop disturbing me."
	}
)
keywordHandler:addKeyword({"king"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm glad that we don't see many officials here."
	}
)
keywordHandler:addKeyword({"god"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a farmer, not a preacher."
	}
)
keywordHandler:addKeyword({"sewer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "What about them? Do you live there?"
	}
)
keywordHandler:addKeyword({"dungeon"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I've got no time for your dungeon nonsense."
	}
)
keywordHandler:addKeyword({"rat"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "My cousin {Billy} cooks rat stew. Yuck! Can you imagine that?"
	}
)
keywordHandler:addKeyword({"monster"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Are you afraid of monsters? I bet even the sight of a {rat} would let your knees tremble. Hahaha."
	}
)
keywordHandler:addKeyword({"time"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Do I look like a clock?"
	}
)
keywordHandler:addKeyword({"god"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a farmer, not a preacher."
	}
)

-- Names
keywordHandler:addKeyword({"al", "dee"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Can't stand him."
	}
)
keywordHandler:addKeyword({"amber"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Quite a babe."
	}
)
keywordHandler:addKeyword({"billy"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Don't ever mention his name again! He can't even {cook}!"
	}
)
keywordHandler:addKeyword({"cipfried"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Our little monkey."
	}
)
keywordHandler:addKeyword({"dallheim"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Uhm, fine guy I think."
	}
)
keywordHandler:addKeyword({"dixi"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Boring little girl."
	}
)
keywordHandler:addKeyword({"hyacinth"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Overrated."
	}
)
keywordHandler:addKeyword({"lee'delle"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "She thinks she owns this island with her underpriced offers."
	}
)
keywordHandler:addKeyword({"lily"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I don't like hippie girls."
	}
)
keywordHandler:addKeyword({"loui"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Leave me alone with that guy."
	}
)
keywordHandler:addKeyword({"norma"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "About time we got a bar here."
	}
)
keywordHandler:addKeyword({"obi"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "This old guy has only money on his mind."
	}
)
keywordHandler:addKeyword({"oracle"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Hopefully it gets you off this island soon so you can stop bugging me."
	}
)
keywordHandler:addKeyword({"paulie"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Uptight and correct in any situation."
	}
)
keywordHandler:addKeyword({"santiago"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "If he wants to sacrifice all his free time for beginners, fine with me. Then they don't disturb me."
	}
)
keywordHandler:addKeyword({"seymour"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "This joke of a man thinks he is sooo important."
	}
)
keywordHandler:addKeyword({"tom"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Decent guy."
	}
)
keywordHandler:addKeyword({"willie"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Yeah, so?"
	}
)
keywordHandler:addKeyword({"zerbrus"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Overrated."
	}
)
keywordHandler:addKeyword({"zirella"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Too old to be interesting for me."
	}
)

-- Studded Shield Quest
local bananaKeyword = keywordHandler:addKeyword({"banana"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Have you found a banana for me?"
	}
)
bananaKeyword:addChildKeyword({"yes"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A banana! Great. Here, take this shield, I don't need it anyway.",
		reset = true
	},
		function(player)
			return player:getItemCount(3587) > 0
		end,
		function(player)
			player:removeItem(3587, 1)
			player:addItem(3426, 1)
		end
)
bananaKeyword:addChildKeyword({"yes"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Are you trying to mess with me?!",
		reset = true
	}
)
bananaKeyword:addChildKeyword({""}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Too bad.",
		reset = true
	}
)

npcHandler:setMessage(MESSAGE_WALKAWAY, "Yeah go away!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, bye |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Ya take a good look.")
npcHandler:setMessage(MESSAGE_GREET, "Hiho |PLAYERNAME|. I hope you're here to {trade}.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
