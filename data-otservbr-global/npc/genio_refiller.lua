local internalNpcName = "Refiller Particular"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 100,
	lookBody = 100,
	lookLegs = 119,
	lookFeet = 115,
	lookAddons = 2
}

npcConfig.flags = {
	floorchange = false
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
	{ itemName = "brown mushroom", clientId = 3725, buy = 5 },
	{ itemName = "avalanche rune", clientId = 3161, buy = 57 },
	{ itemName = "blank rune", clientId = 3147, buy = 10 },
	{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
	{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
	{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
	{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
	{ itemName = "empty potion flask", clientId = 283, sell = 5 },
	{ itemName = "empty potion flask", clientId = 284, sell = 5 },
	{ itemName = "empty potion flask", clientId = 285, sell = 5 },
	{ itemName = "energy field rune", clientId = 3164, buy = 38 },
	{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
	{ itemName = "explosion rune", clientId = 3200, buy = 31 },
	{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
	{ itemName = "fire field rune", clientId = 3188, buy = 28 },
	{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
	{ itemName = "great fireball rune", clientId = 3191, buy = 57 },
	{ itemName = "great health potion", clientId = 239, buy = 225 },
	{ itemName = "great mana potion", clientId = 238, buy = 144 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 228 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
	{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
	{ itemName = "lasting exercise rod", clientId = 35289, buy = 7560000, count = 14400 },
	{ itemName = "lasting exercise wand", clientId = 35290, buy = 7560000, count = 14400 },
	{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "poison field rune", clientId = 3172, buy = 21 },
	{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
	{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
	{ itemName = "strong health potion", clientId = 236, buy = 115 },
	{ itemName = "strong mana potion", clientId = 237, buy = 93 },
	{ itemName = "sudden death rune", clientId = 3155, buy = 135 },
	{ itemName = "terra rod", clientId = 3065, buy = 10000 },
	{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "vial", clientId = 2874, sell = 5 },
	{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "basket", clientId = 2855, buy = 6 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "crystalline arrow", clientId = 15793, buy = 20 },
	{ itemName = "desintegrate rune", clientId = 3197, buy = 26 },
	{ itemName = "diamond arrow", clientId = 35901, buy = 100 },
	{ itemName = "drill bolt", clientId = 16142, buy = 12 },
	{ itemName = "earth arrow", clientId = 774, buy = 5 },
	{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
	{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
	{ itemName = "fireball rune", clientId = 3189, buy = 30 },
	{ itemName = "fishing rod", clientId = 3483, buy = 150, sell = 40 },
	{ itemName = "flaming arrow", clientId = 763, buy = 5 },
	{ itemName = "flash arrow", clientId = 761, buy = 5 },
	{ itemName = "hand auger", clientId = 31334, buy = 25 },
	{ itemName = "holy missile rune", clientId = 3182, buy = 16 },
	{ itemName = "icicle rune", clientId = 3158, buy = 30 },
	{ itemName = "machete", clientId = 3308, buy = 35, sell = 6 },
	{ itemName = "magic wall rune", clientId = 3180, buy = 116 },
	{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
	{ itemName = "paralyze rune", clientId = 3165, buy = 700 },
	{ itemName = "pick", clientId = 3456, buy = 50, sell = 15 },
	{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
	{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
	{ itemName = "power bolt", clientId = 3450, buy = 7 },
	{ itemName = "present", clientId = 2856, buy = 10 },
	{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
	{ itemName = "rope", clientId = 3003, buy = 50, sell = 15 },
	{ itemName = "royal spear", clientId = 7378, buy = 15 },
	{ itemName = "scythe", clientId = 3453, buy = 50, sell = 10 },
	{ itemName = "shiver arrow", clientId = 762, buy = 5 },
	{ itemName = "shovel", clientId = 3457, buy = 50, sell = 8 },
	{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
	{ itemName = "soulfire rune", clientId = 3195, buy = 46 },
	{ itemName = "spear", clientId = 3277, buy = 9, sell = 3 },
	{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
	{ itemName = "stone shower rune", clientId = 3175, buy = 37 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 625 },
	{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
	{ itemName = "throwing star", clientId = 3287, buy = 42 },
	{ itemName = "thunderstorm rune", clientId = 3202, buy = 47 },
	{ itemName = "torch", clientId = 2920, buy = 2 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 438 },
	{ itemName = "ultimate spirit potion", clientId = 23374, buy = 438 },
	{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
	{ itemName = "wild growth rune", clientId = 3156, buy = 160 },
	{ itemName = "enchanted spear", clientId = 7367, buy = 25 },
	{ itemName = "flask of rust remover", clientId = 9016, buy = 400 },
	{ itemName = "assassin star", clientId = 7368, buy = 100 },
	{ itemName = "burst arrow", clientId = 3449, buy = 12 },
	{ itemName = "infernal bolt", clientId = 6528, buy = 300000 },
	{ itemName = "small stone", clientId = 1781, buy = 100 },
	{ itemName = "spear", clientId = 3277, buy = 9 },
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
