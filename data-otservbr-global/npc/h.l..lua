local internalNpcName = "H.L."
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 31,
	lookBody = 114,
	lookLegs = 19,
	lookFeet = 114,
	lookAddons = 0
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
	{ itemName = "ancient shield", clientId = 3432, sell = 49 },
	{ itemName = "axe", clientId = 3274, sell = 6 },
	{ itemName = "barbarian axe", clientId = 3317, sell = 30 },
	{ itemName = "battle axe", clientId = 3266, sell = 40 },
	{ itemName = "battle hammer", clientId = 3305, sell = 40 },
	{ itemName = "battle shield", clientId = 3413, sell = 50 },
	{ itemName = "black shield", clientId = 3429, sell = 5 },
	{ itemName = "blessed shield", clientId = 3423, sell = 650 },
	{ itemName = "bonelord shield", clientId = 3418, sell = 79 },
	{ itemName = "bow", clientId = 3350, sell = 15 },
	{ itemName = "brass armor", clientId = 3359, sell = 50 },
	{ itemName = "brass helmet", clientId = 3354, sell = 8 },
	{ itemName = "brass legs", clientId = 3372, sell = 15 },
	{ itemName = "brass shield", clientId = 3411, sell = 15 },
	{ itemName = "bright sword", clientId = 3295, sell = 280 },
	{ itemName = "broadsword", clientId = 3301, sell = 10 },
	{ itemName = "carlin sword", clientId = 3283, sell = 5 },
	{ itemName = "chain armor", clientId = 3358, sell = 30 },
	{ itemName = "chain helmet", clientId = 3352, sell = 4 },
	{ itemName = "clerical mace", clientId = 3311, sell = 30 },
	{ itemName = "club", clientId = 3270, sell = 1 },
	{ itemName = "combat knife", clientId = 3292, sell = 1 },
	{ itemName = "copper shield", clientId = 3430, sell = 10 },
	{ itemName = "crossbow", clientId = 3349, sell = 20 },
	{ itemName = "crowbar", clientId = 3304, sell = 1 },
	{ itemName = "crown armor", clientId = 3381, sell = 210 },
	{ itemName = "crown helmet", clientId = 3385, sell = 70 },
	{ itemName = "crown legs", clientId = 3382, sell = 60 },
	{ itemName = "crown shield", clientId = 3419, sell = 109 },
	{ itemName = "dagger", clientId = 3267, sell = 1 },
	{ itemName = "dark armor", clientId = 3383, sell = 130 },
	{ itemName = "dark helmet", clientId = 3384, sell = 40 },
	{ itemName = "dark shield", clientId = 3421, sell = 60 },
	{ itemName = "demon armor", clientId = 3388, sell = 195 },
	{ itemName = "demon helmet", clientId = 3387, sell = 95 },
	{ itemName = "demon legs", clientId = 3389, sell = 84 },
	{ itemName = "demon shield", clientId = 3420, sell = 130 },
	{ itemName = "devil helmet", clientId = 3356, sell = 80 },
	{ itemName = "double axe", clientId = 3275, sell = 70 },
	{ itemName = "doublet", clientId = 3379, sell = 1 },
	{ itemName = "dragon lance", clientId = 3201, sell = 90 },
	{ itemName = "dragon scale legs", clientId = 3363, sell = 180 },
	{ itemName = "dragon scale mail", clientId = 3386, sell = 280 },
	{ itemName = "dragon shield", clientId = 3416, sell = 115 },
	{ itemName = "dwarven shield", clientId = 3425, sell = 55 },
	{ itemName = "fire axe", clientId = 3320, sell = 280 },
	{ itemName = "fire sword", clientId = 3280, sell = 335 },
	{ itemName = "giant sword", clientId = 3281, sell = 100 },
	{ itemName = "golden armor", clientId = 3360, sell = 580 },
	{ itemName = "golden helmet", clientId = 3365, sell = 420 },
	{ itemName = "golden legs", clientId = 3364, sell = 120 },
	{ itemName = "golden sickle", clientId = 3306, sell = 10 },
	{ itemName = "great axe", clientId = 3303, sell = 300 },
	{ itemName = "great shield", clientId = 3422, sell = 480 },
	{ itemName = "griffin shield", clientId = 3433, sell = 59 },
	{ itemName = "guardian halberd", clientId = 3315, sell = 120 },
	{ itemName = "guardian shield", clientId = 3415, sell = 150 },
	{ itemName = "halberd", clientId = 3269, sell = 50 },
	{ itemName = "hand axe", clientId = 3268, sell = 5 },
	{ itemName = "hatchet", clientId = 3276, sell = 7 },
	{ itemName = "horned helmet", clientId = 3390, sell = 155 },
	{ itemName = "ice rapier", clientId = 3284, sell = 250 },
	{ itemName = "iron hammer", clientId = 3310, sell = 9 },
	{ itemName = "iron helmet", clientId = 3353, sell = 30 },
	{ itemName = "katana", clientId = 3300, sell = 8 },
	{ itemName = "knife", clientId = 3291, sell = 1 },
	{ itemName = "knight armor", clientId = 3370, sell = 140 },
	{ itemName = "knight axe", clientId = 3318, sell = 50 },
	{ itemName = "knight legs", clientId = 3371, sell = 130 },
	{ itemName = "leather armor", clientId = 3361, sell = 2 },
	{ itemName = "leather helmet", clientId = 3355, sell = 1 },
	{ itemName = "legion helmet", clientId = 3374, sell = 8 },
	{ itemName = "longsword", clientId = 3285, sell = 8 },
	{ itemName = "mace", clientId = 3286, sell = 8 },
	{ itemName = "machete", clientId = 3308, sell = 6 },
	{ itemName = "magic longsword", clientId = 3278, sell = 460 },
	{ itemName = "magic plate armor", clientId = 3366, sell = 720 },
	{ itemName = "magic sword", clientId = 3288, sell = 350 },
	{ itemName = "mastermind shield", clientId = 3414, sell = 550 },
	{ itemName = "morning star", clientId = 3282, sell = 50 },
	{ itemName = "naginata", clientId = 3314, sell = 80 },
	{ itemName = "noble armor", clientId = 3380, sell = 140 },
	{ itemName = "obsidian lance", clientId = 3313, sell = 50 },
	{ itemName = "orcish axe", clientId = 3316, sell = 12 },
	{ itemName = "ornamented shield", clientId = 3424, sell = 45 },
	{ itemName = "plate armor", clientId = 3357, sell = 110 },
	{ itemName = "plate shield", clientId = 3410, sell = 25 },
	{ itemName = "poison dagger", clientId = 3299, sell = 5 },
	{ itemName = "rapier", clientId = 3272, sell = 5 },
	{ itemName = "rose shield", clientId = 3427, sell = 49 },
	{ itemName = "sabre", clientId = 3273, sell = 6 },
	{ itemName = "scale armor", clientId = 3377, sell = 75 },
	{ itemName = "scimitar", clientId = 3307, sell = 10 },
	{ itemName = "serpent sword", clientId = 3297, sell = 15 },
	{ itemName = "shield of honour", clientId = 3417, sell = 520 },
	{ itemName = "short sword", clientId = 3294, sell = 3 },
	{ itemName = "sickle", clientId = 3293, sell = 1 },
	{ itemName = "silver mace", clientId = 3312, sell = 270 },
	{ itemName = "soldier helmet", clientId = 3375, sell = 16 },
	{ itemName = "spear", clientId = 3277, sell = 2 },
	{ itemName = "spike sword", clientId = 3271, sell = 25 },
	{ itemName = "staff", clientId = 3289, sell = 1 },
	{ itemName = "steel helmet", clientId = 3351, sell = 60 },
	{ itemName = "steel shield", clientId = 3409, sell = 30 },
	{ itemName = "stonecutter axe", clientId = 3319, sell = 320 },
	{ itemName = "strange helmet", clientId = 3373, sell = 55 },
	{ itemName = "studded armor", clientId = 3378, sell = 18 },
	{ itemName = "studded helmet", clientId = 3376, sell = 2 },
	{ itemName = "studded legs", clientId = 3362, sell = 15 },
	{ itemName = "studded shield", clientId = 3426, sell = 2 },
	{ itemName = "sword", clientId = 3264, sell = 7 },
	{ itemName = "throwing knife", clientId = 3298, sell = 2 },
	{ itemName = "throwing star", clientId = 3287, sell = 2 },
	{ itemName = "thunder hammer", clientId = 3309, sell = 450 },
	{ itemName = "tower shield", clientId = 3428, sell = 90 },
	{ itemName = "two handed sword", clientId = 3265, sell = 60 },
	{ itemName = "vampire shield", clientId = 3434, sell = 119 },
	{ itemName = "viking helmet", clientId = 3367, sell = 12 },
	{ itemName = "viking shield", clientId = 3431, sell = 35 },
	{ itemName = "war hammer", clientId = 3279, sell = 90 },
	{ itemName = "warlord sword", clientId = 3296, sell = 360 },
	{ itemName = "warrior helmet", clientId = 3369, sell = 75 },
	{ itemName = "winged helmet", clientId = 3368, sell = 320 },
	{ itemName = "wooden shield", clientId = 3412, sell = 1 }
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
