local internalNpcName = "Hamish"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 133,
	lookHead = 19,
	lookBody = 95,
	lookLegs = 87,
	lookFeet = 128,
	lookAddons = 1
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "Health potions to refill your health in combat!"},
	{text = "Potions! Wand! Runes! Get them here!"},
	{text = "Pack of monsters give you trouble? Throw an area rune at them!"},
	{text = "Careful with that! That's a highly reactive potion you have there!"},
	{text = "Run out of mana or a little kablooie? Come to me to resupply!"}
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

keywordHandler:addKeyword({'name'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Hamish MacGuffin, at your disposal."
	}
)
keywordHandler:addKeyword({'job'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I craft highly efficient runes, wands and potions - always handy when you're in a fight against monsters! \z
		Ask me for a trade to browse through my stock."
	}
)
keywordHandler:addKeyword({'rookgaard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Nope. Doesn't sound familiar."
	}
)
keywordHandler:addKeyword({'coltrayne'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Never asked about his past. Seems it's a pretty gloomy one. \z
		But he's an excellent blacksmith and seems content enough with his work here."
	}
)
keywordHandler:addKeyword({'inigo'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Inigo taught me a trick or two since I joined Mr Morris' little crowd. \z
		Quite a nice old chap who's seen much of the world and knows his way around here. \z
		You should definitely ask him if you need help."
	}
)
keywordHandler:addKeyword({'garamond'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Can be quite feisty if you doubt his seniorship. \z
		<snorts> Knows a thing or two about spells, though. Useful knowledge."
	}
)
keywordHandler:addKeyword({'wentworth'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Keeran? He's a bit like Plunderpurse's shadow, isn't he? \z
		Loves numbers, but I believe underneath it all he always wanted to break out of his boring little job in the city."
	}
)
keywordHandler:addKeyword({'richard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Seems good-natured enough a guy. Nimble with his hands, be it cooking or carpentering. \z
		Seems to want to keep his mind off something, so he's always busy fixing stuff or cooking something up."
	}
)
keywordHandler:addKeyword({'mr morris'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "If it wasn't for Mr Morris, maybe none of us would be alive. Or at least, none of us would be here. \z
		He's been everywhere and gathered some adventurers around him to investigate the secrets of Dawnport."
	}
)
keywordHandler:addKeyword({'oressa'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Our druid, down in the temple. Just appeared out of the blue one day. Keeps to herself. \z
		She must have some reason to stay with us rather than roam the bigger Mainland. Well, we all have our reasons."
	}
)
keywordHandler:addKeyword({'plunderpurse'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Now there's someone who has lived life to the full! Don't know though \z
		whether I should really believe that he's a clerk now."
	}
)

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "dawnport") then
		npcHandler:say(
			{
				"Small and deceptively friendly-looking island. Well, I used to study the plants and herbs here for my potions.",
				"Nowadays, I leave that to Oressa, she has a better way with that horrible wildlife here. \z
				I prefer to distil potions in the quiet of my lab. \z
				If you need some potions, runes or other magic equipment, ask for a trade."
			},
		npc, creature, 200)
	elseif MsgContains(message, "mainland") then
		npcHandler:say(
			{
				"Dawnport is not far off from the coast of the Tibian Mainland. Lots of cities, monsters, bandits, \z
				brigands, mean folk and people of low understanding with no sense of respect towards alchemical genius. \z
				<mutters to himself>",
				"Ahem. Once you're level 8, you should be experienced enough to choose your definite vocation and leave \z
				Dawnport for Main - and Tibia definitely needs more skilled adventurers to keep those monsters in check \z
				which roam our lands!"
			},
		npc, creature, 200)
	elseif MsgContains(message, "ser tybald") then
		npcHandler:say(
			{
				"I wish I had thought of changing my name to that of a hero. Would have smoothed my way no end!",
				"Anyway, whatever he was before he joined, Tybald now fits the bill of the legendary hero. \z
				He even has a crush on lady Oressa. Cute. <chuckles>"
			},
		npc, creature, 200)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi there, fellow adventurer. \z
	What's your need? Say {trade} and we'll soon get you fixed up. Or ask me about potions, wands, or runes.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Use your runes wisely!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "blank rune", clientId = 3147, buy = 10 },
	{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
	{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
	{ itemName = "energy field rune", clientId = 3164, buy = 38 },
	{ itemName = "fire field rune", clientId = 3188, buy = 28 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
	{ itemName = "light stone shower rune", clientId = 21351, buy = 25 },
	{ itemName = "lightest missile rune", clientId = 21352, buy = 20 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
	{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
	{ itemName = "poison field rune", clientId = 3172, buy = 21 },
	{ itemName = "small health potion", clientId = 7876, buy = 20 },
	{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
	{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
	{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
	{ itemName = "wand of vortex", clientId = 3074, buy = 500 }
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
