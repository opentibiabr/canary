local internalNpcName = "Rock In A Hard Place"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 13424,
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

local itemsTable = {
	["magic stuff"] = {
		{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
		{ itemName = "avalanche rune", clientId = 3161, buy = 64 },
		{ itemName = "blank rune", clientId = 3147, buy = 10 },
		{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
		{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
		{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
		{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
		{ itemName = "desintegrate rune", clientId = 3197, buy = 26 },
		{ itemName = "empty potion flask", clientId = 283, sell = 5 },
		{ itemName = "empty potion flask", clientId = 284, sell = 5 },
		{ itemName = "empty potion flask", clientId = 285, sell = 5 },
		{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
		{ itemName = "energy field rune", clientId = 3164, buy = 38 },
		{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
		{ itemName = "explosion rune", clientId = 3200, buy = 31 },
		{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
		{ itemName = "fire field rune", clientId = 3188, buy = 28 },
		{ itemName = "fire sword", clientId = 3280, sell = 1000 },
		{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
		{ itemName = "fireball rune", clientId = 3189, buy = 30 },
		{ itemName = "great fireball rune", clientId = 3191, buy = 64 },
		{ itemName = "great health potion", clientId = 239, buy = 225 },
		{ itemName = "great mana potion", clientId = 238, buy = 158 },
		{ itemName = "great spirit potion", clientId = 7642, buy = 254 },
		{ itemName = "health potion", clientId = 266, buy = 50 },
		{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
		{ itemName = "holy missile rune", clientId = 3182, buy = 16 },
		{ itemName = "icicle rune", clientId = 3158, buy = 30 },
		{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
		{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
		{ itemName = "magic wall rune", clientId = 3180, buy = 116 },
		{ itemName = "mana potion", clientId = 268, buy = 56 },
		{ itemName = "paralyze rune", clientId = 3165, buy = 700 },
		{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
		{ itemName = "poison field rune", clientId = 3172, buy = 21 },
		{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
		{ itemName = "soulfire rune", clientId = 3195, buy = 46 },
		{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
		{ itemName = "stone shower rune", clientId = 3175, buy = 41 },
		{ itemName = "strong health potion", clientId = 236, buy = 115 },
		{ itemName = "strong mana potion", clientId = 237, buy = 108 },
		{ itemName = "sudden death rune", clientId = 3155, buy = 162 },
		{ itemName = "supreme health potion", clientId = 23375, buy = 650 },
		{ itemName = "thunderstorm rune", clientId = 3202, buy = 52 },
		{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
		{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
		{ itemName = "ultimate mana potion", clientId = 23373, buy = 488 },
		{ itemName = "ultimate spirit potion", clientId = 23374, buy = 488 },
		{ itemName = "vial", clientId = 2874, sell = 5 },
		{ itemName = "wild growth rune", clientId = 3156, buy = 160 },
	},
	["local equipment"] = {
		{ itemName = "backpack", clientId = 2854, buy = 20 },
		{ itemName = "basket", clientId = 2855, buy = 6 },
		{ itemName = "bottle", clientId = 2875, buy = 3 },
		{ itemName = "bucket", clientId = 2873, buy = 4 },
		{ itemName = "calopteryx cape", clientId = 14086, sell = 15000 },
		{ itemName = "carapace shield", clientId = 14088, sell = 32000 },
		{ itemName = "candelabrum", clientId = 2911, buy = 8 },
		{ itemName = "candlestick", clientId = 2917, buy = 2 },
		{ itemName = "closed trap", clientId = 3481, buy = 280, sell = 75 },
		{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
		{ itemName = "crusher", clientId = 46627, buy = 500 },
		{ itemName = "deepling axe", clientId = 13991, sell = 40000 },
		{ itemName = "deepling squelcher", clientId = 14250, sell = 7000 },
		{ itemName = "deepling staff", clientId = 13987, sell = 4000 },
		{ itemName = "depth calcei", clientId = 13997, sell = 25000 },
		{ itemName = "depth galea", clientId = 13995, sell = 35000 },
		{ itemName = "depth lorica", clientId = 13994, sell = 30000 },
		{ itemName = "depth ocrea", clientId = 13996, sell = 16000 },
		{ itemName = "depth scutum", clientId = 13998, sell = 36000 },
		{ itemName = "fishing rod", clientId = 3483, buy = 150, sell = 40 },
		{ itemName = "grasshopper legs", clientId = 14087, sell = 15000 },
		{ itemName = "guardian axe", clientId = 14043, sell = 9000 },
		{ itemName = "hive bow", clientId = 14246, sell = 28000 },
		{ itemName = "hive scythe", clientId = 14089, sell = 17000 },
		{ itemName = "machete", clientId = 3308, buy = 35, sell = 6 },
		{ itemName = "necklace of the deep", clientId = 13990, sell = 3000 },
		{ itemName = "ornate chestplate", clientId = 13993, sell = 60000 },
		{ itemName = "ornate crossbow", clientId = 14247, sell = 12000 },
		{ itemName = "ornate legs", clientId = 13999, sell = 40000 },
		{ itemName = "ornate mace", clientId = 14001, sell = 42000 },
		{ itemName = "ornate shield", clientId = 14000, sell = 42000 },
		{ itemName = "pick", clientId = 3456, buy = 50, sell = 15 },
		{ itemName = "present", clientId = 2856, buy = 10 },
		{ itemName = "rope", clientId = 3003, buy = 50, sell = 15 },
		{ itemName = "scythe", clientId = 3453, buy = 50, sell = 10 },
		{ itemName = "shovel", clientId = 3457, buy = 50, sell = 8 },
		{ itemName = "torch", clientId = 2920, buy = 2 },
		{ itemName = "warrior's axe", clientId = 14040, sell = 11000 },
		{ itemName = "warrior's shield", clientId = 14042, sell = 9000 },
		{ itemName = "watch", clientId = 2906, buy = 20, sell = 6 },
		{ itemName = "wooden hammer", clientId = 3459, sell = 15 },
		{ itemName = "worm", clientId = 3492, buy = 1 },
	},
	["weapons"] = {
		{ itemName = "axe", clientId = 3274, buy = 20, sell = 7 },
		{ itemName = "battle axe", clientId = 3266, buy = 235, sell = 80 },
		{ itemName = "battle hammer", clientId = 3305, buy = 350, sell = 120 },
		{ itemName = "bone club", clientId = 3337, sell = 5 },
		{ itemName = "bone sword", clientId = 3338, buy = 75, sell = 20 },
		{ itemName = "carlin sword", clientId = 3283, buy = 473, sell = 118 },
		{ itemName = "club", clientId = 3270, buy = 5, sell = 1 },
		{ itemName = "crowbar", clientId = 3304, buy = 260 },
		{ itemName = "dagger", clientId = 3267, buy = 5, sell = 2 },
		{ itemName = "double axe", clientId = 3275, sell = 260 },
		{ itemName = "fire sword", clientId = 3280, sell = 1000 },
		{ itemName = "halberd", clientId = 3269, sell = 400 },
		{ itemName = "hand axe", clientId = 3268, buy = 8, sell = 4 },
		{ itemName = "hatchet", clientId = 3276, sell = 25 },
		{ itemName = "katana", clientId = 3300, sell = 35 },
		{ itemName = "longsword", clientId = 3285, buy = 160, sell = 51 },
		{ itemName = "mace", clientId = 3286, buy = 90, sell = 30 },
		{ itemName = "morning star", clientId = 3282, buy = 430, sell = 100 },
		{ itemName = "orcish axe", clientId = 3316, sell = 350 },
		{ itemName = "rapier", clientId = 3272, buy = 15, sell = 5 },
		{ itemName = "sabre", clientId = 3273, buy = 35, sell = 12 },
		{ itemName = "short sword", clientId = 3294, buy = 26, sell = 10 },
		{ itemName = "sickle", clientId = 3293, buy = 7, sell = 3 },
		{ itemName = "spike sword", clientId = 3271, buy = 8000, sell = 240 },
		{ itemName = "small axe", clientId = 3462, sell = 5 },
		{ itemName = "studded club", clientId = 3336, sell = 10 },
		{ itemName = "sword", clientId = 3264, buy = 85, sell = 25 },
		{ itemName = "throwing knife", clientId = 3298, buy = 25, sell = 2 },
		{ itemName = "two handed sword", clientId = 3265, buy = 950, sell = 450 },
		{ itemName = "war hammer", clientId = 3279, buy = 10000, sell = 470 },
	},
	["armor"] = {
		{ itemName = "battle shield", clientId = 3413, sell = 95 },
		{ itemName = "brass armor", clientId = 3359, buy = 450, sell = 150 },
		{ itemName = "brass helmet", clientId = 3354, buy = 120, sell = 30 },
		{ itemName = "brass legs", clientId = 3372, buy = 195, sell = 49 },
		{ itemName = "chain armor", clientId = 3358, buy = 200, sell = 70 },
		{ itemName = "chain helmet", clientId = 3352, buy = 52, sell = 17 },
		{ itemName = "chain legs", clientId = 3558, buy = 80, sell = 25 },
		{ itemName = "coat", clientId = 3562, buy = 8, sell = 1 },
		{ itemName = "copper shield", clientId = 3430, sell = 50 },
		{ itemName = "doublet", clientId = 3379, buy = 16, sell = 3 },
		{ itemName = "dwarven shield", clientId = 3425, buy = 500, sell = 100 },
		{ itemName = "iron helmet", clientId = 3353, buy = 390, sell = 150 },
		{ itemName = "jacket", clientId = 3561, buy = 12, sell = 1 },
		{ itemName = "leather armor", clientId = 3361, buy = 35, sell = 12 },
		{ itemName = "leather boots", clientId = 3552, buy = 10, sell = 2 },
		{ itemName = "leather helmet", clientId = 3355, buy = 12, sell = 4 },
		{ itemName = "leather legs", clientId = 3559, buy = 10, sell = 9 },
		{ itemName = "legion helmet", clientId = 3374, sell = 22 },
		{ itemName = "plate armor", clientId = 3357, buy = 1200, sell = 400 },
		{ itemName = "plate legs", clientId = 3557, sell = 115 },
		{ itemName = "plate shield", clientId = 3410, buy = 125, sell = 45 },
		{ itemName = "scale armor", clientId = 3377, buy = 260, sell = 75 },
		{ itemName = "soldier helmet", clientId = 3375, buy = 110, sell = 16 },
		{ itemName = "steel helmet", clientId = 3351, buy = 580, sell = 293 },
		{ itemName = "steel shield", clientId = 3409, buy = 240, sell = 80 },
		{ itemName = "studded armor", clientId = 3378, buy = 90, sell = 25 },
		{ itemName = "studded helmet", clientId = 3376, buy = 63, sell = 20 },
		{ itemName = "studded legs", clientId = 3362, buy = 50, sell = 15 },
		{ itemName = "studded shield", clientId = 3426, buy = 50, sell = 16 },
		{ itemName = "swampling club", clientId = 17824, sell = 40 },
		{ itemName = "viking helmet", clientId = 3367, buy = 265, sell = 66 },
		{ itemName = "viking shield", clientId = 3431, buy = 260, sell = 85 },
		{ itemName = "wooden shield", clientId = 3412, buy = 15, sell = 5 },
	},
	["ammunition"] = {
		{ itemName = "arrow", clientId = 3447, buy = 3 },
		{ itemName = "blue quiver", clientId = 35848, buy = 400 },
		{ itemName = "bolt", clientId = 3446, buy = 4 },
		{ itemName = "bow", clientId = 3350, buy = 400, sell = 100 },
		{ itemName = "crossbow", clientId = 3349, buy = 500, sell = 120 },
		{ itemName = "crystalline arrow", clientId = 15793, buy = 20 },
		{ itemName = "diamond arrow", clientId = 35901, buy = 130 },
		{ itemName = "drill bolt", clientId = 16142, buy = 12 },
		{ itemName = "earth arrow", clientId = 774, buy = 5 },
		{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
		{ itemName = "flaming arrow", clientId = 763, buy = 5 },
		{ itemName = "flash arrow", clientId = 761, buy = 5 },
		{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
		{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
		{ itemName = "power bolt", clientId = 3450, buy = 7 },
		{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
		{ itemName = "quiver", clientId = 35562, buy = 400 },
		{ itemName = "red quiver", clientId = 35849, buy = 400 },
		{ itemName = "royal spear", clientId = 7378, buy = 15 },
		{ itemName = "shiver arrow", clientId = 762, buy = 5 },
		{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
		{ itemName = "spear", clientId = 3277, buy = 9, sell = 3 },
		{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
		{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
		{ itemName = "throwing star", clientId = 3287, buy = 42 },
		{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
	},
	["post things"] = {
		{ itemName = "label", clientId = 3507, buy = 1 },
		{ itemName = "letter", clientId = 3505, buy = 8 },
		{ itemName = "parcel", clientId = 3503, buy = 15 },
	},
	["creature products"] = {
		{ itemName = "compound eye", clientId = 14083, sell = 150 },
		{ itemName = "crawler head plating", clientId = 14079, sell = 210 },
		{ itemName = "deepling breaktime snack", clientId = 14011, sell = 90 },
		{ itemName = "deepling claw", clientId = 14044, sell = 430 },
		{ itemName = "deepling guard belt buckle", clientId = 14010, sell = 230 },
		{ itemName = "deepling ridge", clientId = 14041, sell = 360 },
		{ itemName = "deepling scales", clientId = 14017, sell = 80 },
		{ itemName = "deepling warts", clientId = 14012, sell = 180 },
		{ itemName = "deeptags", clientId = 14013, sell = 290 },
		{ itemName = "dung ball", clientId = 14225, sell = 130 },
		{ itemName = "eye of a deepling", clientId = 12730, sell = 150 },
		{ itemName = "hand auger", clientId = 31334, buy = 25 },
		{ itemName = "key to the drowned library", clientId = 14009, sell = 330 },
		{ itemName = "kollos shell", clientId = 14077, sell = 420 },
		{ itemName = "net", clientId = 31489, buy = 50 },
		{ itemName = "spellsinger's seal", clientId = 14008, sell = 280 },
		{ itemName = "spidris mandible", clientId = 14082, sell = 450 },
		{ itemName = "spitter nose", clientId = 14078, sell = 340 },
		{ itemName = "swarmer antenna", clientId = 14076, sell = 130 },
		{ itemName = "waspoid claw", clientId = 14080, sell = 320 },
		{ itemName = "waspoid wing", clientId = 14081, sell = 190 },
	},
}

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

local function onTradeRequest(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	npcHandler:say("You would be surprised how many things are washed ashore here. I trade " .. GetFormattedShopCategoryNames(itemsTable) .. ".", npc, creature)
	return true
end

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Have you noticed that I'm actually the only rock on this island with a proper job? Those lazy pebbleheads! I'm proud to announce: I'm a trader" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "No, you got it all wrong! I said I'm stuck between a rock and a hard place!" })
keywordHandler:addKeyword({ "help" }, StdModule.say, { npcHandler = npcHandler, text = "I can help you buy trading stuff with you. Good for me, good for you. It's a win-win!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Have you noticed that I'm actually the only rock on this island with a proper job? Those lazy pebbleheads! I'm proud to announce: I'm a trader" })

npcHandler:setMessage(MESSAGE_GREET, "Everyone on this island has gone crazy! Except for me and you, it seems. Let's {trade} like normal people would.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Promise to come back sometime, will ya?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Hey! Don't leave me alone with all these lunatics!")

npcHandler:setCallback(CALLBACK_ON_TRADE_REQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
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
