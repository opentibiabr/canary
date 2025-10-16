local mType = Game.createMonsterType("Orshabaal")
local monster = {}

monster.description = "Orshabaal"
monster.experience = 10000
monster.outfit = {
	lookType = 201,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 201,
	bossRace = RARITY_NEMESIS,
}

monster.health = 22500
monster.maxHealth = 22500
monster.race = "fire"
monster.corpse = 5995
monster.speed = 270
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 2500,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "demon", chance = 10, interval = 1000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "PRAISED BE MY MASTERS, THE RUTHLESS SEVEN!", yell = true },
	{ text = "YOU ARE DOOMED!", yell = true },
	{ text = "ORSHABAAL IS BACK!", yell = true },
	{ text = "Be prepared for the day my masters will come for you!", yell = false },
	{ text = "SOULS FOR ORSHABAAL!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 280 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 71 }, -- platinum coin
	{ id = 3033, chance = 80000, maxCount = 19 }, -- small amethyst
	{ id = 3027, chance = 80000, maxCount = 13 }, -- black pearl
	{ id = 3032, chance = 80000, maxCount = 9 }, -- small emerald
	{ id = 3029, chance = 80000, maxCount = 9 }, -- small sapphire
	{ id = 3034, chance = 80000, maxCount = 5 }, -- talon
	{ id = 6499, chance = 80000, maxCount = 5 }, -- demonic essence
	{ id = 5954, chance = 80000, maxCount = 2 }, -- demon horn
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 3028, chance = 80000, maxCount = 2 }, -- small diamond
	{ id = 3026, chance = 80000, maxCount = 15 }, -- white pearl
	{ id = 7368, chance = 80000, maxCount = 42 }, -- assassin star
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 3084, chance = 80000 }, -- protection amulet
	{ id = 3006, chance = 80000 }, -- ring of the sky
	{ id = 6299, chance = 80000 }, -- death ring
	{ id = 3051, chance = 80000 }, -- energy ring
	{ id = 3048, chance = 80000 }, -- might ring
	{ id = 3049, chance = 80000 }, -- stealth ring
	{ id = 3063, chance = 80000 }, -- gold ring
	{ id = 6093, chance = 80000 }, -- crystal ring
	{ id = 2993, chance = 80000 }, -- teddy bear
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 2903, chance = 80000 }, -- golden mug
	{ id = 2848, chance = 80000 }, -- purple tome
	{ id = 3060, chance = 80000 }, -- orb
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 3047, chance = 80000 }, -- magic light wand
	{ id = 3061, chance = 80000 }, -- life crystal
	{ id = 3008, chance = 80000 }, -- crystal necklace
	{ id = 3058, chance = 80000 }, -- strange symbol
	{ id = 3062, chance = 80000 }, -- mind stone
	{ id = 5808, chance = 80000 }, -- orshabaals brain
	{ id = 3284, chance = 80000 }, -- ice rapier
	{ id = 3265, chance = 80000 }, -- two handed sword
	{ id = 3281, chance = 80000 }, -- giant sword
	{ id = 3290, chance = 80000 }, -- silver dagger
	{ id = 3275, chance = 80000 }, -- double axe
	{ id = 3320, chance = 80000 }, -- fire axe
	{ id = 3306, chance = 80000 }, -- golden sickle
	{ id = 3309, chance = 80000 }, -- thunder hammer
	{ id = 3322, chance = 80000 }, -- dragon hammer
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3072, chance = 80000 }, -- wand of decay
	{ id = 3069, chance = 80000 }, -- necrotic rod
	{ id = 3066, chance = 80000 }, -- snakebite rod
	{ id = 3356, chance = 80000 }, -- devil helmet
	{ id = 3366, chance = 80000 }, -- magic plate armor
	{ id = 3364, chance = 80000 }, -- golden legs
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 3055, chance = 80000 }, -- platinum amulet
	{ id = 3054, chance = 80000 }, -- silver amulet
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 22196, chance = 80000 }, -- crystal ball
	{ id = 9179, chance = 80000 }, -- voodoo doll
	{ id = 8062, chance = 80000 }, -- robe of the underworld
	{ id = 22746, chance = 80000 }, -- ancient amulet
	{ id = 7365, chance = 80000 }, -- onyx arrow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1990 },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_MANADRAIN, minDamage = -300, maxDamage = -600, range = 7, target = false },
	{ name = "combat", interval = 1000, chance = 6, type = COMBAT_MANADRAIN, minDamage = -150, maxDamage = -350, radius = 5, effect = CONST_ME_POISONAREA, target = false },
	{ name = "effect", interval = 1000, chance = 6, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 1000, chance = 34, type = COMBAT_FIREDAMAGE, minDamage = -310, maxDamage = -600, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "firefield", interval = 1000, chance = 10, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -850, length = 8, spread = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 111,
	armor = 90,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 9, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 17, type = COMBAT_HEALING, minDamage = 600, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 5, speedChange = 1901, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = -1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
