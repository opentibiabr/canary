local internalNpcName = "The Librarian"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1065,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "I really have to find this scroll. Where did I put it?" },
	{ text = "Too much dust here. I should tidy up on occasion." },
	{ text = "Someone opened the Grimoire of Flames without permission. Egregious!" },
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

	if MsgContains(message, "ring") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 5 then
			npcHandler:say({
				"To extract memories from the ring, you have to enter a trance-like state with the help of a hallucinogen. Like this you can see all memories that are stored in the ring. Ask Faloriel for a respective potion. ...",
				"Drink it while wearing the ring in the Temple of Bastesh and say: 'Sa Katesa Tarsani na'. If the legends are true you will be able to take memories with you in the form of memory shards.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fifth.Memories, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fifth.MemoriesShards, 0)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 6)
		else
			npcHandler:say("You don't need any instructions about the ring right now.", npc, creature)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, dear guest. If you are interested in paperware such as books or scrolls, ask me for a trade.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "Inkwell black", clientId = 28568, sell = 720 },
	{ itemName = "atlas", clientId = 6108, buy = 150 },
	{ itemName = "black book", clientId = 2838, buy = 20 },
	{ itemName = "blue book", clientId = 2844, sell = 40 },
	{ itemName = "book page", clientId = 28569, sell = 640 },
	{ itemName = "brown book", clientId = 2837, buy = 20 },
	{ itemName = "bunch of reed", clientId = 30975, sell = 25 },
	{ itemName = "document", clientId = 2834, buy = 20 },
	{ itemName = "gemmed book", clientId = 2842, sell = 150 },
	{ itemName = "glowing rune", clientId = 28570, sell = 350 },
	{ itemName = "green book", clientId = 2831, sell = 30 },
	{ itemName = "greeting card", clientId = 6386, buy = 40 },
	{ itemName = "grey small book", clientId = 2839, buy = 20 },
	{ itemName = "inkwell", clientId = 3509, buy = 20, sell = 15 },
	{ itemName = "orange book", clientId = 2843, sell = 60 },
	{ itemName = "parchment", clientId = 2833, buy = 15, sell = 10 },
	{ itemName = "parchment", clientId = 2835, buy = 15 },
	{ itemName = "quill", clientId = 28567, sell = 1100 },
	{ itemName = "scroll", clientId = 2815, buy = 10 },
	{ itemName = "silken bookmark", clientId = 28566, sell = 1300 },
	{ itemName = "valentine's card", clientId = 6538, buy = 40 },
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
