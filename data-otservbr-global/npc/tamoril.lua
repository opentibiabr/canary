local internalNpcName = "Tamoril"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 39
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

local talkState = {}
npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	npcHandler:setMessage(MESSAGE_GREET, "Another pesky mortal who believes his gold outweighs his nutrition value.")
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, "first dragon") then
		npcHandler:say("The First Dragon? The first of all of us? The Son of Garsharak? I'm surprised you heard about him. It is such a long time that he wandered Tibia. Yet, there are some {rumours}.", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "rumours") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:setTopic(playerId, 2)
		npcHandler:say("It is told that the First Dragon had four {descendants}, who became the ancestors of the four kinds of dragons we know in Tibia. They perhaps still have knowledge about the First Dragon's whereabouts - if one could find them.", npc, creature)
	elseif MsgContains(message, "descendants") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:setTopic(playerId, 3)
		npcHandler:say("The names of these four are Tazhadur, Kalyassa, Gelidrazah and Zorvorax. Not only were they the ancestors of all dragons after but also the primal representation of the {draconic incitements}. About whom do you want to learn more?", npc, creature)
	elseif MsgContains(message, "draconic incitements") and npcHandler:getTopic(playerId) == 3 then
		npcHandler:setTopic(playerId, 4)
		npcHandler:say({
			'Each kind of dragon has its own incitement, an important aspect that impels them and occupies their mind. For the common dragons this is the lust for power, for the dragon lords the greed for treasures. ...',
			'The frost dragons\' incitement is the thirst for knowledge und for the undead dragons it\'s the desire for life, as they regret their ancestor\'s mistake. ...',
			'These incitements are also a kind of trial that has to be undergone if one wants to {find} the First Dragon\'s four descendants.'
		}, npc, creature)
	elseif MsgContains(message, "find") then
		npcHandler:setTopic(playerId, 5)
		npcHandler:say("What do you want to do, if you know about these mighty dragons' abodes? Go there and look for a fight?", npc, creature)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 5 then
		npcHandler:setTopic(playerId, 6)
		npcHandler:say({
			' Fine! I\'ll tell you where to find our ancestors. You now may ask yourself why I should want you to go there and fight them. It\'s quite simple: I am a straight descendant of Kalyassa herself. She was not really a caring mother. ...',
			'No, she called herself an empress and behaved exactly like that. She was domineering, farouche and conceited and this finally culminated in a serious quarrel between us. ...',
			'I sought support by my aunt and my uncles but they were not a bit better than my mother was! So, feel free to go to their lairs and challenge them. I doubt you will succeed but then again that\'s not my problem. ...',
			'So, you want to know about their secret lairs?'
		}, npc, creature)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 6 then
		npcHandler:say({
			'So listen: The lairs are secluded and you can only reach them by using a magical gem teleporter. You will find a teleporter carved out of a giant emerald in the dragon lairs deep beneath the Darama desert, which will lead you to Tazhadur\'s lair. ...',
			'A ruby teleporter located in the western Dragonblaze Peaks allows you to enter the lair of Kalyassa. A teleporter carved out of sapphire is on the island Okolnir and leads you to Gelidrazah\'s lair. ...',
			'And finally an amethyst teleporter in undead-infested caverns underneath Edron allows you to enter the lair of Zorvorax.'
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
		player:setStorageValue(Storage.FirstDragon.Questline, 1)
		player:setStorageValue(Storage.FirstDragon.DragonCounter, 0)
		player:setStorageValue(Storage.FirstDragon.ChestCounter, 0)
		player:setStorageValue(Storage.FirstDragon.GelidrazahAccess, 0)
		player:setStorageValue(Storage.FirstDragon.SecretsCounter, 0)
	end
	return true
end
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "blue gem", clientId = 3041, sell = 5000 },
	{ itemName = "golden mug", clientId = 2903, sell = 250 },
	{ itemName = "green gem", clientId = 3038, sell = 5000 },
	{ itemName = "red gem", clientId = 3039, sell = 1000 },
	{ itemName = "violet gem", clientId = 3036, sell = 10000 },
	{ itemName = "white gem", clientId = 32769, sell = 12000 },
	{ itemName = "yellow gem", clientId = 3037, sell = 1000 }
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
