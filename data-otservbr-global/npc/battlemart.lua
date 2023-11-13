local internalNpcName = "Battlemart"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1020,
	lookHead = 57,
	lookBody = 113,
	lookLegs = 95,
	lookFeet = 113,
	lookAddons = 3,
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

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "assassin star", clientId = 7368, buy = 100 },
	{ itemName = "avalanche rune", clientId = 3161, buy = 57 },
	{ itemName = "backpack", clientId = 2854, buy = 20 },
	{ itemName = "blank rune", clientId = 3147, buy = 10 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "bow", clientId = 3350, buy = 400 },
	{ itemName = "brown mushroom", clientId = 3725, buy = 10 },
	{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
	{ itemName = "collar of blue plasma", clientId = 23542, buy = 60000 },
	{ itemName = "collar of green plasma", clientId = 23543, buy = 60000 },
	{ itemName = "collar of red plasma", clientId = 23544, buy = 60000 },
	{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
	{ itemName = "crowbar", clientId = 3304, buy = 260 },
	{ itemName = "crystalline arrow", clientId = 15793, buy = 20 },
	{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
	{ itemName = "desintegrate rune", clientId = 3197, buy = 26 },
	{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
	{ itemName = "diamond arrow", clientId = 35901, buy = 100 },
	{ itemName = "drill bolt", clientId = 16142, buy = 12 },
	{ itemName = "dwarven ring", clientId = 3097, buy = 2000 },
	{ itemName = "earth arrow", clientId = 774, buy = 5 },
	{ itemName = "enchanted spear", clientId = 7367, buy = 30 },
	{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
	{ itemName = "energy field rune", clientId = 3164, buy = 38 },
	{ itemName = "energy ring", clientId = 3051, buy = 2000 },
	{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
	{ itemName = "enhanced exercise axe", clientId = 35280, buy = 2340000 },
	{ itemName = "enhanced exercise bow", clientId = 35282, buy = 2340000 },
	{ itemName = "enhanced exercise club", clientId = 35281, buy = 2340000 },
	{ itemName = "enhanced exercise rod", clientId = 35283, buy = 2340000 },
	{ itemName = "enhanced exercise shield", clientId = 44066, buy = 2340000 },
	{ itemName = "enhanced exercise sword", clientId = 35279, buy = 2340000 },
	{ itemName = "enhanced exercise wand", clientId = 35284, buy = 2340000 },
	{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
	{ itemName = "exercise axe", clientId = 28553, buy = 1800000 },
	{ itemName = "exercise bow", clientId = 28555, buy = 1800000 },
	{ itemName = "exercise club", clientId = 28554, buy = 1800000 },
	{ itemName = "exercise rod", clientId = 28556, buy = 1800000 },
	{ itemName = "exercise sword", clientId = 28552, buy = 1800000 },
	{ itemName = "exercise wand", clientId = 28557, buy = 1800000 },
	{ itemName = "explosion rune", clientId = 3200, buy = 31 },
	{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
	{ itemName = "fire field rune", clientId = 3188, buy = 28 },
	{ itemName = "fire mushroom", clientId = 3731, buy = 300 },
	{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
	{ itemName = "fireball rune", clientId = 3189, buy = 30 },
	{ itemName = "fishing rod", clientId = 3483, buy = 150 },
	{ itemName = "flaming arrow", clientId = 763, buy = 5 },
	{ itemName = "flash arrow", clientId = 761, buy = 5 },
	{ itemName = "flask of rust remover", clientId = 9016, buy = 50 },
	{ itemName = "gill necklace", clientId = 16108, buy = 20000 },
	{ itemName = "glacier amulet", clientId = 815, buy = 15000 },
	{ itemName = "great fireball rune", clientId = 3191, buy = 57 },
	{ itemName = "great health potion", clientId = 239, buy = 225 },
	{ itemName = "great mana potion", clientId = 238, buy = 144 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 228 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
	{ itemName = "holy missile rune", clientId = 3182, buy = 16 },
	{ itemName = "hunting spear", clientId = 3347, buy = 25 },
	{ itemName = "icicle rune", clientId = 3158, buy = 30 },
	{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
	{ itemName = "leviathan's amulet", clientId = 9303, buy = 30000 },
	{ itemName = "life ring", clientId = 3052, buy = 900 },
	{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
	{ itemName = "lightning pendant", clientId = 816, buy = 15000 },
	{ itemName = "magic wall rune", clientId = 3180, buy = 116 },
	{ itemName = "magma amulet", clientId = 817, buy = 15000 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "mana shield potion", clientId = 35563, buy = 200000 },
	{ itemName = "masterful exercise axe", clientId = 35286, buy = 2700000 },
	{ itemName = "masterful exercise bow", clientId = 35288, buy = 2700000 },
	{ itemName = "masterful exercise club", clientId = 35287, buy = 2700000 },
	{ itemName = "masterful exercise rod", clientId = 35289, buy = 2700000 },
	{ itemName = "masterful exercise shield", clientId = 44067, buy = 2700000 },
	{ itemName = "masterful exercise sword", clientId = 35285, buy = 2700000 },
	{ itemName = "masterful exercise wand", clientId = 35290, buy = 2700000 },
	{ itemName = "might ring", clientId = 3048, buy = 5000 },
	{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
	{ itemName = "paralyze rune", clientId = 3165, buy = 700 },
	{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
	{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
	{ itemName = "poison field rune", clientId = 3172, buy = 21 },
	{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
	{ itemName = "power bolt", clientId = 3450, buy = 7 },
	{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
	{ itemName = "prismatic necklace", clientId = 16113, buy = 20000 },
	{ itemName = "prismatic ring", clientId = 16114, buy = 100000 },
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "red quiver", clientId = 35849, buy = 400 },
	{ itemName = "ring of blue plasma", clientId = 23529, buy = 80000 },
	{ itemName = "ring of green plasma", clientId = 23531, buy = 80000 },
	{ itemName = "ring of healing", clientId = 3098, buy = 2000 },
	{ itemName = "ring of red plasma", clientId = 23533, buy = 80000 },
	{ itemName = "royal star", clientId = 25759, buy = 110 },
	{ itemName = "sacred tree amulet", clientId = 9302, buy = 30000 },
	{ itemName = "shiver arrow", clientId = 762, buy = 5 },
	{ itemName = "shockwave amulet", clientId = 9304, buy = 30000 },
	{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
	{ itemName = "soulfire rune", clientId = 3195, buy = 46 },
	{ itemName = "spear", clientId = 3277, buy = 5 },
	{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
	{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
	{ itemName = "stealth ring", clientId = 3049, buy = 5000 },
	{ itemName = "stone shower rune", clientId = 3175, buy = 37 },
	{ itemName = "stone skin amulet", clientId = 3081, buy = 5000 },
	{ itemName = "strong health potion", clientId = 236, buy = 115 },
	{ itemName = "strong mana potion", clientId = 237, buy = 93 },
	{ itemName = "sudden death rune", clientId = 3155, buy = 135 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 625 },
	{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
	{ itemName = "terra amulet", clientId = 814, buy = 15000 },
	{ itemName = "throwing star", clientId = 3287, buy = 42 },
	{ itemName = "thunderstorm rune", clientId = 3202, buy = 47 },
	{ itemName = "time ring", clientId = 3053, buy = 2000 },
	{ itemName = "torch", clientId = 2920, buy = 2 },
	{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 438 },
	{ itemName = "ultimate spirit potion", clientId = 23374, buy = 438 },
	{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
	{ itemName = "wild growth rune", clientId = 3156, buy = 160 },
	{ itemName = "worm", clientId = 3492, buy = 1 },
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
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
