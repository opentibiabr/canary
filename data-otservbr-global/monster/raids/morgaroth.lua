local mType = Game.createMonsterType("Morgaroth")
local monster = {}

monster.description = "Morgaroth"
monster.experience = 15000
monster.outfit = {
	lookType = 12,
	lookHead = 2,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 229,
	bossRace = RARITY_NEMESIS,
}

monster.health = 55000
monster.maxHealth = 55000
monster.race = "fire"
monster.corpse = 6068
monster.speed = 305
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 100,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 6,
	summons = {
		{ name = "Demon", chance = 33, interval = 4000, count = 6 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I AM MORGAROTH, LORD OF THE TRIANGLE... AND YOU ARE LOST!", yell = true },
	{ text = "MY SEED IS FEAR AND MY HARVEST ARE YOUR SOULS!", yell = true },
	{ text = "ZATHROTH! LOOK AT THE DESTRUCTION I AM CAUSING IN YOUR NAME!", yell = true },
	{ text = "THE TRIANGLE OF TERROR WILL RISE!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 295 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 74 }, -- platinum coin
	{ id = 6499, chance = 80000, maxCount = 5 }, -- demonic essence
	{ id = 3033, chance = 80000, maxCount = 18 }, -- small amethyst
	{ id = 3032, chance = 80000, maxCount = 7 }, -- small emerald
	{ id = 3028, chance = 80000, maxCount = 5 }, -- small diamond
	{ id = 3026, chance = 80000, maxCount = 11 }, -- white pearl
	{ id = 3029, chance = 80000, maxCount = 9 }, -- small sapphire
	{ id = 3027, chance = 80000, maxCount = 13 }, -- black pearl
	{ id = 3034, chance = 80000, maxCount = 7 }, -- talon
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 5954, chance = 80000, maxCount = 2 }, -- demon horn
	{ id = 6528, chance = 80000, maxCount = 100 }, -- infernal bolt
	{ id = 7368, chance = 80000, maxCount = 35 }, -- assassin star
	{ id = 22746, chance = 80000 }, -- ancient amulet
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 22196, chance = 80000 }, -- crystal ball
	{ id = 3063, chance = 80000 }, -- gold ring
	{ id = 6093, chance = 80000 }, -- crystal ring
	{ id = 6299, chance = 80000 }, -- death ring
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 7431, chance = 80000 }, -- demonbone
	{ id = 3356, chance = 80000 }, -- devil helmet
	{ id = 3275, chance = 80000 }, -- double axe
	{ id = 3051, chance = 80000 }, -- energy ring
	{ id = 3320, chance = 80000 }, -- fire axe
	{ id = 3281, chance = 80000 }, -- giant sword
	{ id = 3364, chance = 80000 }, -- golden legs
	{ id = 2903, chance = 80000 }, -- golden mug
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3284, chance = 80000 }, -- ice rapier
	{ id = 3061, chance = 80000 }, -- life crystal
	{ id = 3047, chance = 80000 }, -- magic light wand
	{ id = 3265, chance = 80000 }, -- two handed sword
	{ id = 3366, chance = 80000 }, -- magic plate armor
	{ id = 826, chance = 80000 }, -- magma coat
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 3048, chance = 80000 }, -- might ring
	{ id = 3062, chance = 80000 }, -- mind stone
	{ id = 3070, chance = 80000 }, -- moonlight rod
	{ id = 3069, chance = 80000 }, -- necrotic rod
	{ id = 7421, chance = 80000 }, -- onyx flail
	{ id = 3060, chance = 80000 }, -- orb
	{ id = 3055, chance = 80000 }, -- platinum amulet
	{ id = 2848, chance = 80000 }, -- purple tome
	{ id = 2852, chance = 80000 }, -- red tome
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 3054, chance = 80000 }, -- silver amulet
	{ id = 3290, chance = 80000 }, -- silver dagger
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3049, chance = 80000 }, -- stealth ring
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 3058, chance = 80000 }, -- strange symbol
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 3554, chance = 1000 }, -- steel boots
	{ id = 8022, chance = 1000 }, -- chain bolter
	{ id = 8037, chance = 1000 }, -- dark lords cape
	{ id = 8039, chance = 1000 }, -- dragon robe
	{ id = 8053, chance = 1000 }, -- fireborn giant armor
	{ id = 3422, chance = 1000 }, -- great shield
	{ id = 8058, chance = 1000 }, -- molten plate
	{ id = 5943, chance = 1000 }, -- morgaroths heart
	{ id = 8100, chance = 1000 }, -- obsidian truncheon
	{ id = 8023, chance = 1000 }, -- royal crossbow
	{ id = 2993, chance = 1000 }, -- teddy bear
	{ id = 3309, chance = 1000 }, -- thunder hammer
	{ id = 821, chance = 80000 }, -- magma legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2250 },
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -1210, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 1800, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -580, range = 7, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -1450, length = 8, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -480, range = 7, radius = 5, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -500, range = 7, radius = 13, effect = CONST_ME_SOUND_RED, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -450, radius = 14, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -200, range = 7, radius = 3, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -400, range = 7, effect = CONST_ME_SOUND_RED, target = false, duration = 20000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -70, maxDamage = -320, radius = 3, effect = CONST_ME_HITAREA, target = true },
	{ name = "dark torturer skill reducer", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 130,
	--	mitigation = ???,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 9000, chance = 15, type = COMBAT_HEALING, minDamage = 3800, maxDamage = 4000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 4000, chance = 80, speedChange = 470, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 80 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
