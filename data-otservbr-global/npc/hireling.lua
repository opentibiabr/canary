function createHirelingType(HirelingName)
	local npcType = Game.createNpcType(HirelingName)

	-- If it's a Hireling with a name like an npc, example "Hireling Canary", we'll remove the name "Hireling" and keep only the npc name for the look description
	if string.match(HirelingName, "^Hireling%s%w+") then
		HirelingName = string.sub(HirelingName, 10)
	end

	local npcConfig = {}
	local enableBankSystem = {}

	npcConfig.name = HirelingName
	npcConfig.description = HirelingName

	npcConfig.health = 100
	npcConfig.maxHealth = npcConfig.health
	npcConfig.walkInterval = 0
	npcConfig.walkRadius = 2

	npcConfig.outfit = {
		lookType = 136,
		lookHead = 97,
		lookBody = 34,
		lookLegs = 3,
		lookFeet = 116,
		lookAddons = 0,
	}

	npcConfig.flags = {
		floorchange = false,
	}

	local itemsTable = {
		["various"] = {
			{ itemName = "blue footboard", clientId = 32482, buy = 40 },
			{ itemName = "blue headboard", clientId = 32473, buy = 40 },
			{ itemName = "cot footboard", clientId = 32486, buy = 40 },
			{ itemName = "cot headboard", clientId = 32477, buy = 40 },
			{ itemName = "green footboard", clientId = 32483, buy = 40 },
			{ itemName = "green headboard", clientId = 32474, buy = 40 },
			{ itemName = "hammock foot section", clientId = 32487, buy = 40 },
			{ itemName = "hammock head section", clientId = 32478, buy = 40 },
			{ itemName = "red footboard", clientId = 32484, buy = 40 },
			{ itemName = "red headboard", clientId = 32475, buy = 40 },
			{ itemName = "simple footboard", clientId = 32488, buy = 40 },
			{ itemName = "simple headboard", clientId = 32479, buy = 40 },
			{ itemName = "straw mat foot section", clientId = 32489, buy = 40 },
			{ itemName = "straw mat head section", clientId = 32480, buy = 40 },
			{ itemName = "yellow footboard", clientId = 32485, buy = 40 },
			{ itemName = "yellow headboard", clientId = 32476, buy = 40 },
			{ itemName = "amphora", clientId = 2893, buy = 4 },
			{ itemName = "armor rack kit", clientId = 6114, buy = 90 },
			{ itemName = "bamboo drawer kit", clientId = 2795, buy = 20 },
			{ itemName = "bamboo table kit", clientId = 2788, buy = 25 },
			{ itemName = "barrel kit", clientId = 2793, buy = 12 },
			{ itemName = "big table kit", clientId = 2785, buy = 30 },
			{ itemName = "birdcage kit", clientId = 2796, buy = 50 },
			{ itemName = "blue pillow", clientId = 2394, buy = 25 },
			{ itemName = "blue tapestry", clientId = 2659, buy = 25 },
			{ itemName = "bookcase kit", clientId = 6372, buy = 70 },
			{ itemName = "box", clientId = 2469, buy = 10 },
			{ itemName = "chest", clientId = 2472, buy = 10 },
			{ itemName = "chest of drawers", clientId = 2789, buy = 18 },
			{ itemName = "chimney kit", clientId = 7864, buy = 200 },
			{ itemName = "coal basin kit", clientId = 2806, buy = 25 },
			{ itemName = "cookie", clientId = 3598, buy = 2 },
			{ itemName = "crate", clientId = 2471, buy = 10 },
			{ itemName = "cuckoo clock", clientId = 2664, buy = 40 },
			{ itemName = "dresser kit", clientId = 2790, buy = 25 },
			{ itemName = "goldfish bowl", clientId = 5928, buy = 50 },
			{ itemName = "fireworks rocket", clientId = 6576, buy = 100 },
			{ itemName = "flower bowl", clientId = 2983, buy = 6 },
			{ itemName = "globe", clientId = 2797, buy = 50 },
			{ itemName = "goblin statue kit", clientId = 2804, buy = 50 },
			{ itemName = "god flowers", clientId = 2981, buy = 5 },
			{ itemName = "green balloons", clientId = 6577, buy = 500 },
			{ itemName = "green cushioned chair kit", clientId = 2776, buy = 40 },
			{ itemName = "green pillow", clientId = 2396, buy = 25 },
			{ itemName = "green tapestry", clientId = 2647, buy = 25 },
			{ itemName = "harp kit", clientId = 2808, buy = 50 },
			{ itemName = "heart pillow", clientId = 2393, buy = 30 },
			{ itemName = "honey flower", clientId = 2984, buy = 5 },
			{ itemName = "indoor plant kit", clientId = 2811, buy = 8 },
			{ itemName = "ivory chair kit", clientId = 2781, buy = 25 },
			{ itemName = "knight statue kit", clientId = 2802, buy = 50 },
			{ itemName = "large amphora kit", clientId = 2805, buy = 50 },
			{ itemName = "large trunk", clientId = 2794, buy = 10 },
			{ itemName = "locker kit", clientId = 2791, buy = 30 },
			{ itemName = "minotaur statue kit", clientId = 2803, buy = 50 },
			{ itemName = "orange tapestry", clientId = 2653, buy = 25 },
			{ itemName = "oven kit", clientId = 6371, buy = 80 },
			{ itemName = "party hat", clientId = 6578, buy = 800 },
			{ itemName = "party trumpet", clientId = 6572, buy = 500 },
			{ itemName = "pendulum clock kit", clientId = 2801, buy = 75 },
			{ itemName = "piano kit", clientId = 2807, buy = 200 },
			{ itemName = "potted flower", clientId = 2985, buy = 5 },
			{ itemName = "present", clientId = 2856, buy = 10 },
			{ itemName = "purple tapestry", clientId = 2644, buy = 25 },
			{ itemName = "red balloons", clientId = 6575, buy = 500 },
			{ itemName = "red cushioned chair kit", clientId = 2775, buy = 40 },
			{ itemName = "red pillow", clientId = 2395, buy = 25 },
			{ itemName = "red tapestry", clientId = 2656, buy = 25 },
			{ itemName = "rocking horse", clientId = 2800, buy = 30 },
			{ itemName = "round blue pillow", clientId = 2398, buy = 25 },
			{ itemName = "round purple pillow", clientId = 2400, buy = 25 },
			{ itemName = "round red pillow", clientId = 2399, buy = 25 },
			{ itemName = "round turquoise pillow", clientId = 2401, buy = 25 },
			{ itemName = "small blue pillow", clientId = 2389, buy = 20 },
			{ itemName = "small green pillow", clientId = 2387, buy = 20 },
			{ itemName = "small ice statue", clientId = 7447, buy = 50 },
			{ itemName = "small ice statue", clientId = 7448, buy = 50 },
			{ itemName = "small orange pillow", clientId = 2390, buy = 20 },
			{ itemName = "small purple pillow", clientId = 2386, buy = 20 },
			{ itemName = "small red pillow", clientId = 2388, buy = 20 },
			{ itemName = "small round table", clientId = 2783, buy = 25 },
			{ itemName = "small table kit", clientId = 2782, buy = 20 },
			{ itemName = "small trunk", clientId = 2426, buy = 20 },
			{ itemName = "small turquoise pillow", clientId = 2391, buy = 20 },
			{ itemName = "small white pillow", clientId = 2392, buy = 20 },
			{ itemName = "sofa chair kit", clientId = 2779, buy = 55 },
			{ itemName = "square table kit", clientId = 2784, buy = 25 },
			{ itemName = "stone table kit", clientId = 2786, buy = 30 },
			{ itemName = "table lamp kit", clientId = 2798, buy = 35 },
			{ itemName = "telescope kit", clientId = 2799, buy = 70 },
			{ itemName = "thick trunk", clientId = 2352, buy = 20 },
			{ itemName = "treasure chest", clientId = 2478, buy = 1000 },
			{ itemName = "trophy stand", clientId = 872, buy = 50 },
			{ itemName = "trough kit", clientId = 2792, buy = 7 },
			{ itemName = "tusk chair kit", clientId = 2780, buy = 25 },
			{ itemName = "tusk table kit", clientId = 2787, buy = 25 },
			{ itemName = "vase", clientId = 2876, buy = 3 },
			{ itemName = "venorean cabinet", clientId = 17974, buy = 90 },
			{ itemName = "venorean drawer", clientId = 17977, buy = 40 },
			{ itemName = "venorean wardrobe", clientId = 17975, buy = 50 },
			{ itemName = "wall mirror", clientId = 2638, buy = 40 },
			{ itemName = "wall mirror", clientId = 2635, buy = 40 },
			{ itemName = "wall mirror", clientId = 2632, buy = 40 },
			{ itemName = "water pipe", clientId = 2980, buy = 40 },
			{ itemName = "weapon rack kit", clientId = 6115, buy = 90 },
			{ itemName = "white tapestry", clientId = 2667, buy = 25 },
			{ itemName = "wooden chair kit", clientId = 2777, buy = 15 },
			{ itemName = "yellow pillow", clientId = 900, buy = 25 },
			{ itemName = "yellow tapestry", clientId = 2650, buy = 25 },
			{ itemName = "exercise axe", clientId = 28553, buy = 262500, subType = 500 },
			{ itemName = "exercise bow", clientId = 28555, buy = 262500, subType = 500 },
			{ itemName = "exercise club", clientId = 28554, buy = 262500, subType = 500 },
			{ itemName = "exercise rod", clientId = 28556, buy = 262500, subType = 500 },
			{ itemName = "exercise sword", clientId = 28552, buy = 262500, subType = 500 },
			{ itemName = "exercise wand", clientId = 28557, buy = 262500, subType = 500 },
			{ itemName = "durable exercise axe", clientId = 35280, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise bow", clientId = 35282, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise club", clientId = 35281, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise rod", clientId = 35283, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise sword", clientId = 35279, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise wand", clientId = 35284, buy = 945000, subType = 1800 },
		},
		["exercise weapons"] = {
			{ itemName = "exercise axe", clientId = 28553, buy = 262500, subType = 500 },
			{ itemName = "exercise bow", clientId = 28555, buy = 262500, subType = 500 },
			{ itemName = "exercise club", clientId = 28554, buy = 262500, subType = 500 },
			{ itemName = "exercise rod", clientId = 28556, buy = 262500, subType = 500 },
			{ itemName = "exercise sword", clientId = 28552, buy = 262500, subType = 500 },
			{ itemName = "exercise wand", clientId = 28557, buy = 262500, subType = 500 },
			{ itemName = "durable exercise axe", clientId = 35280, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise bow", clientId = 35282, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise club", clientId = 35281, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise rod", clientId = 35283, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise sword", clientId = 35279, buy = 945000, subType = 1800 },
			{ itemName = "durable exercise wand", clientId = 35284, buy = 945000, subType = 1800 },
			{ itemName = "lasting exercise axe", clientId = 35286, buy = 7560000, subType = 14400 },
			{ itemName = "lasting exercise bow", clientId = 35288, buy = 7560000, subType = 14400 },
			{ itemName = "lasting exercise club", clientId = 35287, buy = 7560000, subType = 14400 },
			{ itemName = "lasting exercise rod", clientId = 35289, buy = 7560000, subType = 14400 },
			{ itemName = "lasting exercise sword", clientId = 35285, buy = 7560000, subType = 14400 },
			{ itemName = "lasting exercise wand", clientId = 35290, buy = 7560000, subType = 14400 },
		},
		["equipment"] = {
			{ itemName = "axe", clientId = 3274, buy = 20, sell = 7 },
			{ itemName = "battle axe", clientId = 3266, buy = 235, sell = 80 },
			{ itemName = "battle hammer", clientId = 3305, buy = 350, sell = 120 },
			{ itemName = "bone sword", clientId = 3338, buy = 75, sell = 20 },
			{ itemName = "brass armor", clientId = 3359, buy = 450, sell = 150 },
			{ itemName = "brass helmet", clientId = 3354, buy = 120, sell = 30 },
			{ itemName = "brass legs", clientId = 3372, buy = 195, sell = 49 },
			{ itemName = "brass shield", clientId = 3411, buy = 65, sell = 25 },
			{ itemName = "carlin sword", clientId = 3283, buy = 473, sell = 118 },
			{ itemName = "chain armor", clientId = 3358, buy = 200, sell = 70 },
			{ itemName = "chain helmet", clientId = 3352, buy = 52, sell = 17 },
			{ itemName = "chain legs", clientId = 3558, buy = 80, sell = 25 },
			{ itemName = "club", clientId = 3270, buy = 5, sell = 1 },
			{ itemName = "coat", clientId = 3562, buy = 8, sell = 1 },
			{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
			{ itemName = "dagger", clientId = 3267, buy = 5, sell = 2 },
			{ itemName = "doublet", clientId = 3379, buy = 16, sell = 3 },
			{ itemName = "dwarven shield", clientId = 3425, buy = 500, sell = 100 },
			{ itemName = "hand axe", clientId = 3268, buy = 8, sell = 4 },
			{ itemName = "iron helmet", clientId = 3353, buy = 390, sell = 150 },
			{ itemName = "jacket", clientId = 3561, buy = 12, sell = 1 },
			{ itemName = "leather armor", clientId = 3361, buy = 35, sell = 12 },
			{ itemName = "leather boots", clientId = 3552, buy = 10, sell = 2 },
			{ itemName = "leather helmet", clientId = 3355, buy = 12, sell = 4 },
			{ itemName = "leather legs", clientId = 3559, buy = 10, sell = 9 },
			{ itemName = "longsword", clientId = 3285, buy = 160, sell = 51 },
			{ itemName = "mace", clientId = 3286, buy = 90, sell = 30 },
			{ itemName = "morning star", clientId = 3282, buy = 430, sell = 100 },
			{ itemName = "plate armor", clientId = 3357, buy = 1200, sell = 400 },
			{ itemName = "plate shield", clientId = 3410, buy = 125, sell = 45 },
			{ itemName = "rapier", clientId = 3272, buy = 15, sell = 5 },
			{ itemName = "sabre", clientId = 3273, buy = 35, sell = 12 },
			{ itemName = "scale armor", clientId = 3377, buy = 260, sell = 75 },
			{ itemName = "short sword", clientId = 3294, buy = 26, sell = 10 },
			{ itemName = "sickle", clientId = 3293, buy = 7, sell = 3 },
			{ itemName = "soldier helmet", clientId = 3375, buy = 110, sell = 16 },
			{ itemName = "spike sword", clientId = 3271, buy = 8000, sell = 240 },
			{ itemName = "steel helmet", clientId = 3351, buy = 580, sell = 293 },
			{ itemName = "steel shield", clientId = 3409, buy = 240, sell = 80 },
			{ itemName = "studded armor", clientId = 3378, buy = 90, sell = 25 },
			{ itemName = "studded helmet", clientId = 3376, buy = 63, sell = 20 },
			{ itemName = "studded legs", clientId = 3362, buy = 50, sell = 15 },
			{ itemName = "studded shield", clientId = 3426, buy = 50, sell = 16 },
			{ itemName = "sword", clientId = 3264, buy = 85, sell = 25 },
			{ itemName = "throwing knife", clientId = 3298, buy = 25, sell = 2 },
			{ itemName = "two handed sword", clientId = 3265, buy = 950, sell = 450 },
			{ itemName = "viking helmet", clientId = 3367, buy = 265, sell = 66 },
			{ itemName = "viking shield", clientId = 3431, buy = 260, sell = 85 },
			{ itemName = "war hammer", clientId = 3279, buy = 10000, sell = 470 },
			{ itemName = "wooden shield", clientId = 3412, buy = 15, sell = 5 },
		},
		["distance"] = {
			{ itemName = "arrow", clientId = 3447, buy = 2 },
			{ itemName = "bolt", clientId = 3446, buy = 4 },
			{ itemName = "bow", clientId = 3350, buy = 400, sell = 100 },
			{ itemName = "crossbow", clientId = 3349, buy = 500, sell = 120 },
			{ itemName = "crystalline arrow", clientId = 15793, buy = 450 },
			{ itemName = "drill bolt", clientId = 16142, buy = 12 },
			{ itemName = "diamond arrow", clientId = 35901, buy = 130 },
			{ itemName = "earth arrow", clientId = 774, buy = 5 },
			{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
			{ itemName = "flaming arrow", clientId = 763, buy = 5 },
			{ itemName = "flash arrow", clientId = 761, buy = 5 },
			{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
			{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
			{ itemName = "power bolt", clientId = 3450, buy = 7 },
			{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
			{ itemName = "quiver", clientId = 35562, buy = 400 },
			{ itemName = "royal spear", clientId = 7378, buy = 15 },
			{ itemName = "shiver arrow", clientId = 762, buy = 5 },
			{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
			{ itemName = "spear", clientId = 3277, buy = 9, sell = 3 },
			{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
			{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
			{ itemName = "throwing star", clientId = 3287, buy = 42 },
			{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
		},
		["rods"] = {
			{ itemName = "exercise rod", clientId = 28556, buy = 236250, subType = 500 },
			{ itemName = "hailstorm rod", clientId = 3067, buy = 15000 },
			{ itemName = "moonlight rod", clientId = 3070, buy = 1000 },
			{ itemName = "necrotic rod", clientId = 3069, buy = 5000 },
			{ itemName = "northwind rod", clientId = 8083, buy = 7500 },
			{ itemName = "snakebite rod", clientId = 3066, buy = 500 },
			{ itemName = "springsprout rod", clientId = 8084, buy = 18000 },
			{ itemName = "terra rod", clientId = 3065, buy = 10000 },
			{ itemName = "underworld rod", clientId = 8082, buy = 22000 },
		},
		["wands"] = {
			{ itemName = "exercise wand", clientId = 28557, buy = 236250, subType = 500 },
			{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000 },
			{ itemName = "wand of decay", clientId = 3072, buy = 5000 },
			{ itemName = "wand of draconia", clientId = 8093, buy = 7500 },
			{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000 },
			{ itemName = "wand of inferno", clientId = 3071, buy = 15000 },
			{ itemName = "wand of starstorm", clientId = 8092, buy = 18000 },
			{ itemName = "wand of voodoo", clientId = 8094, buy = 22000 },
			{ itemName = "wand of vortex", clientId = 3074, buy = 500 },
		},
		["potions"] = {
			{ itemName = "great health potion", clientId = 239, buy = 225 },
			{ itemName = "great mana potion", clientId = 238, buy = 158 },
			{ itemName = "great spirit potion", clientId = 7642, buy = 254 },
			{ itemName = "health potion", clientId = 266, buy = 50 },
			{ itemName = "mana potion", clientId = 268, buy = 56 },
			{ itemName = "strong health potion", clientId = 236, buy = 115 },
			{ itemName = "strong mana potion", clientId = 237, buy = 108 },
			{ itemName = "supreme health potion", clientId = 23375, buy = 650 },
			{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
			{ itemName = "ultimate mana potion", clientId = 23373, buy = 488 },
			{ itemName = "ultimate spirit potion", clientId = 23374, buy = 488 },
			{ itemName = "empty potion flask", clientId = 283, sell = 5 },
			{ itemName = "empty potion flask", clientId = 284, sell = 5 },
			{ itemName = "empty potion flask", clientId = 285, sell = 5 },
			{ itemName = "vial", clientId = 2874, sell = 5 },
		},
		["runes"] = {
			{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
			{ itemName = "avalanche rune", clientId = 3161, buy = 64 },
			{ itemName = "blank rune", clientId = 3147, buy = 10 },
			{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
			{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
			{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
			{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
			{ itemName = "disintegrate rune", clientId = 3197, buy = 26 },
			{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
			{ itemName = "energy field rune", clientId = 3164, buy = 38 },
			{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
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
			{ itemName = "paralyse rune", clientId = 3165, buy = 700 },
			{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
			{ itemName = "poison field rune", clientId = 3172, buy = 21 },
			{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
			{ itemName = "soulfire rune", clientId = 3195, buy = 46 },
			{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
			{ itemName = "stone shower rune", clientId = 3175, buy = 41 },
			{ itemName = "sudden death rune", clientId = 3155, buy = 162 },
			{ itemName = "thunderstorm rune", clientId = 3202, buy = 52 },
			{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
			{ itemName = "wild growth rune", clientId = 3156, buy = 160 },
		},
		["supplies"] = {
			{ itemName = "brown mushroom", clientId = 3725, buy = 10 },
			{ itemName = "ham", clientId = 3582, buy = 10 },
			{ itemName = "meat", clientId = 3577, buy = 5 },
			{ itemName = "shapeshifter ring", clientId = 907, buy = 5500, subType = 15 },
		},
		["tools"] = {
			{ itemName = "basket", clientId = 2855, buy = 6 },
			{ itemName = "bottle", clientId = 2875, buy = 3 },
			{ itemName = "bucket", clientId = 2873, buy = 4 },
			{ itemName = "candelabrum", clientId = 2911, buy = 8 },
			{ itemName = "candlestick", clientId = 2917, buy = 2 },
			{ itemName = "closed trap", clientId = 3481, buy = 280, sell = 75 },
			{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
			{ itemName = "fishing rod", clientId = 3483, buy = 150, sell = 40 },
			{ itemName = "machete", clientId = 3308, buy = 35, sell = 6 },
			{ itemName = "pick", clientId = 3456, buy = 50, sell = 15 },
			{ itemName = "rope", clientId = 3003, buy = 50, sell = 15 },
			{ itemName = "scythe", clientId = 3453, buy = 50, sell = 10 },
			{ itemName = "shovel", clientId = 3457, buy = 50, sell = 8 },
			{ itemName = "spellwand", clientId = 651, sell = 299 },
			{ itemName = "torch", clientId = 2920, buy = 2 },
			{ itemName = "watch", clientId = 2906, buy = 20, sell = 6 },
			{ itemName = "worm", clientId = 3492, buy = 1 },
			{ itemName = "spellwand", clientId = 651, sell = 299 },
		},
		["postal"] = {
			{ itemName = "label", clientId = 3507, buy = 1 },
			{ itemName = "letter", clientId = 3505, buy = 8 },
			{ itemName = "parcel", clientId = 3503, buy = 15 },
		},
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

	local keywordHandler = KeywordHandler:new()
	local npcHandler = NpcHandler:new(keywordHandler)
	local hireling = nil
	local count = {} -- for banking
	local transfer = {} -- for banking

	npcType.onAppear = function(npc, creature)
		npcHandler:onAppear(npc, creature)

		if not hireling then
			local position = creature:getPosition()

			hireling = getHirelingByPosition(position)
			if not hireling then
				return
			end
			hireling:setCreature(creature)
		end
	end

	npcType.onDisappear = function(npc, creature)
		enableBankSystem[creature:getId()] = nil
		npcHandler:onDisappear(npc, creature)
	end

	npcType.onSay = function(npc, creature, type, message)
		npcHandler:onSay(npc, creature, type, message)
	end

	npcType.onCloseChannel = function(npc, creature)
		enableBankSystem[creature:getId()] = nil
		npcHandler:onCloseChannel(npc, creature)
	end

	npcType.onThink = function(npc, interval)
		npcHandler:onThink(npc, interval)
	end

	local TOPIC = {
		NONE = 1000,
		LAMP = 1001,
		SERVICES = 1100,
		BANK = 1200,
		FOOD = 1300,
		GOODS = 1400,
	}

	local TOPIC_FOOD = {
		SKILL_CHOOSE = 1301,
		SKILL_SURPRISE = 1302,
	}

	local GREETINGS = {
		BANK = "Alright! What can I do for you and your bank business, |PLAYERNAME|?",
		FOOD = [[Hmm, yes! A variety of fine food awaits! However, a small expense of 15000 gold is expected to make these delicious masterpieces happen.
	For 90000 gold I will also serve you a specific dish. Just tell me what it shall be: a {specific} meal or a little {surprise}.]],
		STASH = "Of course, here is your stash! Well-maintained and neatly sorted for your convenience!",
	}

	local function getHirelingSkills()
		local skills = {}
		if hireling:hasSkill(HIRELING_SKILLS.BANKER[2]) then
			table.insert(skills, HIRELING_SKILLS.BANKER[1])
		end
		if hireling:hasSkill(HIRELING_SKILLS.COOKING[2]) then
			table.insert(skills, HIRELING_SKILLS.COOKING[1])
		end
		if hireling:hasSkill(HIRELING_SKILLS.STEWARD[2]) then
			table.insert(skills, HIRELING_SKILLS.STEWARD[1])
		end
		-- ignoring trader skills as it shows the same message about {goods}
		return skills
	end

	local function getHirelingServiceString(creature)
		local skills = getHirelingSkills()
		local str = "Do you want to see my {goods}"

		for i = 1, #skills do
			if i == #skills then
				str = str .. " or "
			else
				str = str .. ", "
			end

			if skills[i] == HIRELING_SKILLS.BANKER[1] then
				str = str .. "to access your {bank} account" -- TODO: this setence is not official
			elseif skills[i] == HIRELING_SKILLS.COOKING[1] then
				str = str .. "to order {food}"
			elseif skills[i] == HIRELING_SKILLS.STEWARD[1] then
				str = str .. "to open your {stash}"
			end
		end
		str = str .. "?"

		local player = Player(creature)

		if player:getGuid() == hireling:getOwnerId() then
			str = str .. " If you want, I can go back to my {lamp} or maybe change my {outfit}."
		end
		return str
	end

	local function sendSkillNotLearned(npc, creature, skillName)
		local message = "Sorry, but I do not have mastery in this skill yet."
		if skillName then
			message = string.format("I'm not a %s and would not know how to help you with that, sorry. I can start a %s apprenticeship if you buy it for me in the store!", skillName, skillName)
		end

		npcHandler:say(message, npc, creature)
	end
	-- ----------------------[[ END STEWARD FUNCTIONS ]] ------------------------------
	--[[
	############################################################################
	############################################################################
	############################################################################
	]]
	-- ========================[[ COOKER FUNCTIONS ]] ========================== --

	local function getDeliveredMessageByFoodId(food_id) -- remove the hardcoded food ids
		local message = ""
		if food_id == 29408 then
			message = "Oh yes, a tasty roasted wings to make you even tougher and skilled with the defensive arts."
		elseif food_id == 29409 then
			message = "Divine! Carrot is a well known nourishment that makes the eyes see even more sharply."
		elseif food_id == 29410 then
			message = "Magnifique! A tiger meat that has been marinated for several hours in magic spices."
		elseif food_id == 29411 then
			message = "Aaah, the beauty of the simple dishes! A delicate salad made of selected ingredients, capable of bring joy to the hearts of bravest warriors and their weapons."
		elseif food_id == 29412 then
			message = "Oh yes, very spicy chilly combined with delicious minced carniphila meat and a side dish of fine salad!"
		elseif food_id == 29413 then
			message = "Aaah, the northern cuisine! A catch of fresh salmon right from the coast Svargrond is the base of this extraordinary fish dish."
		elseif food_id == 29414 then
			message = "A traditional and classy meal. A beefy casserole which smells far better than it sounds!"
		elseif food_id == 29415 then
			message = "A tasty chunk of juicy beef with an aromatic sauce and parsley potatoes, mmh!"
		elseif food_id == 29416 then
			message = "Oooh, well... that one didn't quite turn out as it was supposed to be, I'm sorry."
		end

		return message
	end

	local function deliverFood(npc, creature, food_id, cost)
		local playerId = creature:getId()
		local player = Player(creature)
		local itType = ItemType(food_id)
		local inbox = player:getStoreInbox()
		local inboxItems = inbox:getItems()
		if player:getFreeCapacity() < itType:getWeight(1) then
			npcHandler:say("Sorry, but you don't have enough capacity.", npc, creature)
		elseif not inbox or #inboxItems >= inbox:getMaxCapacity() then
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			npcHandler:say("Sorry, you don't have enough room on your inbox.", npc, creature)
		elseif not player:removeMoneyBank(cost) then
			npcHandler:say("Sorry, you don't have enough money.", npc, creature)
		else
			local message = getDeliveredMessageByFoodId(food_id)
			npcHandler:say(message, npc, creature)
			inbox:addItem(food_id, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
		end
		npcHandler:setTopic(playerId, TOPIC.SERVICES)
	end

	local function cookFood(npc, creature, specificRequest)
		local playerId = creature:getId()
		if specificRequest then
			npcHandler:say("Very well. You may choose one of the following: {chilli con carniphila}, {svargrond salmon filet}, {carrion casserole}, {consecrated beef}, {roasted wyvern wings}, {carrot pie}, {tropical marinated tiger}, or {delicatessen salad}.", npc, creature)
			npcHandler:setTopic(playerId, TOPIC_FOOD.SKILL_CHOOSE)
		else
			npcHandler:say("Alright, let me astonish you. Shall I?", npc, creature)
			deliverFood(npc, creature, HIRELING_FOODS_IDS[math.random(#HIRELING_FOODS_IDS)], 15000)
		end
	end

	local function handleFoodActions(npc, creature, message)
		local playerId = creature:getId()

		if npcHandler:getTopic(playerId) == TOPIC.FOOD then
			if MsgContains(message, "specific") then
				npcHandler:setTopic(playerId, TOPIC_FOOD.SPECIFIC)
				npcHandler:say("Which specific meal would you like? Choices are: {chilli con carniphila}, {svargrond salmon filet}, {carrion casserole}, {consecrated beef}, {roasted wyvern wings}, {carrot pie}, {tropical marinated tiger}, or {delicatessen salad}.", npc, creature)
			elseif MsgContains(message, "surprise") then
				local random = math.random(6)
				if random == 6 then
					npcHandler:setTopic(playerId, TOPIC_FOOD.SKILL_CHOOSE)
					npcHandler:say("Yay! I have the ingredients to make a skill boost dish. Would you rather like to boost your {magic}, {melee}, {shielding}, or {distance} skill?", npc, creature)
				else
					deliverFood(npc, creature, HIRELING_FOODS_IDS[random], 15000)
				end
			elseif MsgContains(message, "yes") then
				deliverFood(npc, creature, HIRELING_FOODS_IDS[math.random(#HIRELING_FOODS_IDS)], 15000)
			elseif MsgContains(message, "no") then
				npcHandler:setTopic(playerId, TOPIC.SERVICES)
				npcHandler:say("Alright then, ask me for other {services}, if you want.", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == TOPIC_FOOD.SKILL_CHOOSE then
			if MsgContains(message, "magic") then
				deliverFood(npc, creature, HIRELING_FOODS_BOOST.MAGIC, 15000)
			elseif MsgContains(message, "melee") then
				deliverFood(npc, creature, HIRELING_FOODS_BOOST.MELEE, 15000)
			elseif MsgContains(message, "shielding") then
				deliverFood(npc, creature, HIRELING_FOODS_BOOST.SHIELDING, 15000)
			elseif MsgContains(message, "distance") then
				deliverFood(npc, creature, HIRELING_FOODS_BOOST.DISTANCE, 15000)
			else
				npcHandler:say("Sorry, but you must choose a valid skill class. Would you like to boost your {magic}, {melee}, {shielding}, or {distance} skill?", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == TOPIC_FOOD.SPECIFIC then
			local specificFoodOptions = {
				["chilli con carniphila"] = 29412,
				["svargrond salmon filet"] = 29413,
				["carrion casserole"] = 29414,
				["consecrated beef"] = 29415,
				["roasted wyvern wings"] = 29408,
				["carrot pie"] = 29409,
				["tropical marinated tiger"] = 29410,
				["delicatessen salad"] = 29411,
			}

			if specificFoodOptions[message:lower()] then
				deliverFood(npc, creature, specificFoodOptions[message:lower()], 90000)
			else
				npcHandler:say("I'm sorry, but that's not a valid food option. Please choose from: {chilli con carniphila}, {svargrond salmon filet}, {carrion casserole}, {consecrated beef}, {roasted wyvern wings}, {carrot pie}, {tropical marinated tiger}, or {delicatessen salad}.", npc, creature)
			end
		end
	end

	-- ======================[[ END COOKER FUNCTIONS ]] ======================== --
	local function creatureSayCallback(npc, creature, type, message)
		local player = Player(creature)
		local playerId = player:getId()

		if not npcHandler:checkInteraction(npc, creature) then
			return false
		end

		if not hireling:canTalkTo(player) then
			return false
		end

		-- roleplay
		if MsgContains(message, "sword of fury") then
			npcHandler:say("In my youth I dreamt to wield it! Now I wield the broom of... brooming. I guess that's the next best thing!", npc, creature)
		elseif MsgContains(message, "rookgaard") then
			npcHandler:say("What an uncivilised place without any culture.", npc, creature)
		elseif MsgContains(message, "excalibug") then
			-- end roleplay
			npcHandler:say("I'll keep an eye open for it when cleaning up the things you brought home!", npc, creature)
		elseif MsgContains(message, "service") then
			npcHandler:setTopic(playerId, TOPIC.SERVICES)
			local servicesMsg = getHirelingServiceString(creature)
			npcHandler:say(servicesMsg, npc, creature)
		elseif npcHandler:getTopic(playerId) == TOPIC.SERVICES then
			if MsgContains(message, "bank") then
				local bankerSkillName = HIRELING_SKILLS.BANKER[2]
				if hireling:hasSkill(bankerSkillName) then
					npcHandler:setTopic(playerId, TOPIC.BANK)
					count[playerId], transfer[playerId] = nil, nil
					npcHandler:say(GREETINGS.BANK, npc, creature)
				else
					sendSkillNotLearned(npc, creature, bankerSkillName)
				end
			elseif MsgContains(message, "food") then
				local bankerSkillName = HIRELING_SKILLS.COOKING[2]
				if hireling:hasSkill(bankerSkillName) then
					npcHandler:setTopic(playerId, TOPIC.FOOD)
					npcHandler:say(GREETINGS.FOOD, npc, creature)
				else
					sendSkillNotLearned(npc, creature, bankerSkillName)
				end
			elseif MsgContains(message, "stash") then
				local bankerSkillName = HIRELING_SKILLS.STEWARD[2]
				if hireling:hasSkill(bankerSkillName) then
					npcHandler:say(GREETINGS.STASH, npc, creature)
					player:setSpecialContainersAvailable(true)
					player:openStash(true)
					player:sendTextMessage(MESSAGE_FAILURE, "Your supply stash contains " .. player:getStashCount() .. " item" .. (player:getStashCount() > 1 and "s." or "."))
				else
					sendSkillNotLearned(npc, creature, bankerSkillName)
				end
			elseif MsgContains(message, "goods") then
				local string
				if not hireling:hasSkill(HIRELING_SKILLS.TRADER[2]) then
					string = "While I'm not a trader, I still have a collection of {various} items to sell if you like!"
				else
					string = "I sell a selection of {various} items, {exercise weapons}, {equipment}, " .. "{distance} weapons, {wands} and {rods}, {potions}, {runes}, " .. "{supplies}, {tools} and {postal} goods. Just ask!"
				end
				npcHandler:setTopic(playerId, TOPIC.GOODS)
				npcHandler:say(string, npc, creature)
			elseif MsgContains(message, "lamp") then
				npcHandler:setTopic(playerId, TOPIC.LAMP)
				if player:getGuid() ~= hireling:getOwnerId() then
					return false
				end

				npcHandler:say("Are you sure you want me to go back to my lamp?", npc, creature)
			elseif MsgContains(message, "outfit") then
				if player:getGuid() ~= hireling:getOwnerId() then
					return false
				end

				hireling:requestOutfitChange()
				npcHandler:say("As you wish!", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == TOPIC.LAMP then
			if MsgContains(message, "yes") then
				hireling:returnToLamp(player:getGuid())
			else
				npcHandler:setTopic(playerId, TOPIC.SERVICES)
				npcHandler:say("Alright then, I will be here.", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == TOPIC.BANK then
			enableBankSystem[playerId] = true
		elseif npcHandler:getTopic(playerId) == TOPIC.FOOD or npcHandler:getTopic(playerId) == TOPIC_FOOD.SKILL_CHOOSE or npcHandler:getTopic(playerId) == TOPIC_FOOD.SPECIFIC then
			handleFoodActions(npc, creature, message)
		elseif npcHandler:getTopic(playerId) == TOPIC.GOODS then
			-- Ensures players cannot access other shop categories
			if not hireling:hasSkill(HIRELING_SKILLS.TRADER[2]) then
				if not MsgContains(message, "various") then
					local text = "While I'm not a trader, I still have a collection of {various} items to sell if you like!"
					npcHandler:say(text, npc, creature)
					return
				end

				npcHandler:say("Here are the items for the category various.", npc, creature)
				npc:openShopWindowTable(player, itemsTable["various"])
				return
			end

			local categoryTable = itemsTable[message:lower()]
			if categoryTable then
				local remainingCategories = npc:getRemainingShopCategories(message:lower(), itemsTable)
				npcHandler:say("Of course, just browse through my wares. You can also look at " .. remainingCategories .. ".", npc, player)
				npc:openShopWindowTable(player, categoryTable)
			end
		end
		if enableBankSystem[playerId] then
			-- Parse bank
			npc:parseBank(message, npc, creature, npcHandler)
			-- Parse guild bank
			npc:parseGuildBank(message, npc, creature, playerId, npcHandler)
			-- Normal messages
			npc:parseBankMessages(message, npc, creature, npcHandler)
		end
		return true
	end

	npcHandler:setMessage(MESSAGE_GREET, "It is good to see you. I'm always at your {service}.")
	npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, |PLAYERNAME|, I'll be here if you need me again.")
	npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back soon!")

	npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
	npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

	-- npcType registering the npcConfig table
	npcType:register(npcConfig)
end

createHirelingType("Hireling")
