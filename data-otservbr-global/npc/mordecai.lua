local internalNpcName = "Mordecai"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 38,
	lookBody = 132,
	lookLegs = 117,
	lookFeet = 3,
	lookAddons = 1,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Come in, young mages! Purchase the latest in runes and wands!" },
	{ text = "Perhaps I need to bake them hotter? Or was it longer?" },
	{ text = "Offering all sorts of magic equipment!" },
	{ text = "Now where did Alaistar put the wood for the new wands?" },
	{ text = "Hmmm.. Maybe those crushed gems caused the strange side effect?" },
	{ text = "Wands and rods, the true magician's weapons of choice!" },
}

local itemsTable = {
	["runes"] = {
		{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
		{ itemName = "avalanche rune", clientId = 3161, buy = 64 },
		{ itemName = "blank rune", clientId = 3147, buy = 10 },
		{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
		{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
		{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
		{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
		{ itemName = "desintegrate rune", clientId = 3197, buy = 26 },
		{ itemName = "energy field rune", clientId = 3164, buy = 38 },
		{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
		{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
		{ itemName = "explosion rune", clientId = 3200, buy = 31 },
		{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
		{ itemName = "fire field rune", clientId = 3188, buy = 28 },
		{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
		{ itemName = "fireball rune", clientId = 3189, buy = 30 },
		{ itemName = "great fireball rune", clientId = 3191, buy = 64 },
		{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
		{ itemName = "holy missile rune", clientId = 3182, buy = 16 },
		{ itemName = "icicle rune", clientId = 3158, buy = 30 },
		{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
		{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
		{ itemName = "magic wall rune", clientId = 3180, buy = 116 },
		{ itemName = "paralyze rune", clientId = 3165, buy = 700 },
		{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
		{ itemName = "poison field rune", clientId = 3172, buy = 21 },
		{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
		{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
		{ itemName = "stone shower rune", clientId = 3175, buy = 41 },
		{ itemName = "sudden death rune", clientId = 3155, buy = 162 },
		{ itemName = "thunderstorm rune", clientId = 3202, buy = 52 },
		{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
		{ itemName = "wild growth rune", clientId = 3156, buy = 160 },
	},
	["wands"] = {
		{ itemName = "hailstorm rod", clientId = 3067, buy = 15000 },
		{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
		{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
		{ itemName = "northwind rod", clientId = 8083, buy = 7500 },
		{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
		{ itemName = "springsprout rod", clientId = 8084, buy = 18000 },
		{ itemName = "terra rod", clientId = 3065, buy = 10000 },
		{ itemName = "underworld rod", clientId = 8082, buy = 22000 },
		{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000 },
		{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
		{ itemName = "wand of draconia", clientId = 8093, buy = 7500 },
		{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
		{ itemName = "wand of inferno", clientId = 3071, buy = 15000 },
		{ itemName = "wand of starstorm", clientId = 8092, buy = 18000 },
		{ itemName = "wand of voodoo", clientId = 8094, buy = 22000 },
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
}

npcConfig.shop = {}
for _, categoryTable in pairs(itemsTable) do
	for _, itemTable in ipairs(categoryTable) do
		table.insert(npcConfig.shop, itemTable)
	end
end

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

	local categoryTable = itemsTable[message:lower()]

	if categoryTable then
		local remainingCategories = npc:getRemainingShopCategories(message:lower(), itemsTable)
		npcHandler:say("Of course, just browse through my wares. You can also look at " .. remainingCategories .. ".", npc, player)
		npc:openShopWindowTable(player, categoryTable)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Welcome to the magic emporium, child. Ask me for a trade if you need {runes}, {wands}, or spellbooks.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care, child.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Ah, the impetuosity of youth.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Choose wisely! Or maybe you want to look only at " .. GetFormattedShopCategoryNames(itemsTable) .. ".")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

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
