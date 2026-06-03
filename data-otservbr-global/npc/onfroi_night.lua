local internalNpcName = "Onfroi"
local npcType = Game.createNpcType("Onfroi (Night)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 0,
	lookBody = 50,
	lookLegs = 50,
	lookFeet = 50,
	lookAddons = 0,
}

npcConfig.respawnType = {
	period = RESPAWNPERIOD_NIGHT,
	underground = false,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {}

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

	if MsgContains(message, "yselda") and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide) >= 1 and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiTask) == 1 and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiKills) >= 20 then
		player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiTask, 2)
		player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust, player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust) + 1)
		npcHandler:say("You did it, excellent! Most respectable, you did great! That took a load of my mind. And you've earned my trust!", npc, creature)
	elseif MsgContains(message, "yselda") and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide) >= 1 and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiTask) < 1 then
		player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiTask, 1)
		player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiKills, 0)
		npcHandler:say({
			"You mean it, right? Where did you got that from, actually?. ...",
			"Now, I have indeed a favour to ask. If you can accomplish that, you've earned my trust surely. ...",
			"There is a crypt down below the town. It is old and seismic activity has stirred up some bad energies down there. ...",
			"I want you to venture exactly to that crypt and see if there are any powerful creatures down there. ...",
			"And if there are... please... remove them. Rest assured that I have nothing to do with the rise of any mortally-depleted entities down there ...",
			"At least not this time. You see, the locals are starting to suspect me. But I'm not much of a fighter or warlock. ...",
			"So if there is indeed something below us and you can destroy let's say 20 of it, I'd be in your debt.",
		}, npc, creature)
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Oh, a customer! Welcome to my magic shop. What can I do for you?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

local itemsTable = {
	["potions"] = {
		{ itemName = "empty potion flask", clientId = 283, sell = 5 },
		{ itemName = "empty potion flask", clientId = 284, sell = 5 },
		{ itemName = "empty potion flask", clientId = 285, sell = 5 },
		{ itemName = "great health potion", clientId = 239, buy = 225 },
		{ itemName = "great mana potion", clientId = 238, buy = 158 },
		{ itemName = "great spirit potion", clientId = 7642, buy = 254 },
		{ itemName = "health potion", clientId = 266, buy = 50 },
		{ itemName = "mana potion", clientId = 268, buy = 56 },
		{ itemName = "strong health potion", clientId = 236, buy = 115 },
		{ itemName = "strong mana potion", clientId = 237, buy = 108 },
		{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
		{ itemName = "vial", clientId = 2874, sell = 5 },
	},
	["runes"] = {
		{ itemName = "blank rune", clientId = 3147, buy = 10 },
	},
	["wands"] = {
		{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
		{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
		{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
		{ itemName = "springsprout rod", clientId = 8084, buy = 18000 },
		{ itemName = "terra rod", clientId = 3065, buy = 10000 },
		{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000 },
		{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
		{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
		{ itemName = "wand of vortex", clientId = 3074, buy = 500 },
	},
	["exercise weapons"] = {
		{ itemName = "durable exercise rod", clientId = 35283, buy = 1250000, count = 1800 },
		{ itemName = "durable exercise wand", clientId = 35284, buy = 1250000, count = 1800 },
		{ itemName = "exercise rod", clientId = 28556, buy = 347222, count = 500 },
		{ itemName = "exercise wand", clientId = 28557, buy = 347222, count = 500 },
		{ itemName = "lasting exercise rod", clientId = 35289, buy = 10000000, count = 14400 },
		{ itemName = "lasting exercise wand", clientId = 35290, buy = 10000000, count = 14400 },
	},
	["others"] = {
		{ itemName = "spellwand", clientId = 651, sell = 299 },
	},
	["shields"] = {
		{ itemName = "spellbook", clientId = 3059, buy = 150 },
	},
}

npcConfig.shop = {}
for _, categoryTable in pairs(itemsTable) do
	for _, itemTable in ipairs(categoryTable) do
		table.insert(npcConfig.shop, itemTable)
	end
end

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
