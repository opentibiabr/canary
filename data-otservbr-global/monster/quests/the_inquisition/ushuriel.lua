local mType = Game.createMonsterType("Ushuriel")
local monster = {}

monster.description = "Ushuriel"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 0,
	lookBody = 57,
	lookLegs = 0,
	lookFeet = 80,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.health = 31500
monster.maxHealth = 31500
monster.race = "fire"
monster.corpse = 6068
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 415,
	bossRace = RARITY_BANE,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You can't run or hide forever!", yell = false },
	{ text = "I'm the executioner of the Seven!", yell = false },
	{ text = "The final punishment awaits you!", yell = false },
	{ text = "The judgement is guilty! The sentence is death!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 102 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 3028, chance = 80000, maxCount = 3 }, -- small diamond
	{ id = 3029, chance = 80000, maxCount = 8 }, -- small sapphire
	{ id = 3027, chance = 80000, maxCount = 14 }, -- black pearl
	{ id = 3032, chance = 80000, maxCount = 6 }, -- small emerald
	{ id = 3026, chance = 80000, maxCount = 14 }, -- white pearl
	{ id = 3033, chance = 80000, maxCount = 17 }, -- small amethyst
	{ id = 239, chance = 80000, maxCount = 2 }, -- great health potion
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 7365, chance = 80000, maxCount = 8 }, -- onyx arrow
	{ id = 3725, chance = 80000, maxCount = 30 }, -- brown mushroom
	{ id = 5954, chance = 80000, maxCount = 2 }, -- demon horn
	{ id = 7385, chance = 80000 }, -- crimson sword
	{ id = 5880, chance = 80000, maxCount = 10 }, -- iron ore
	{ id = 5925, chance = 80000, maxCount = 20 }, -- hardened bone
	{ id = 3060, chance = 80000 }, -- orb
	{ id = 3069, chance = 80000 }, -- necrotic rod
	{ id = 3066, chance = 80000 }, -- snakebite rod
	{ id = 3275, chance = 80000 }, -- double axe
	{ id = 3307, chance = 80000 }, -- scimitar
	{ id = 3062, chance = 80000 }, -- mind stone
	{ id = 3047, chance = 80000 }, -- magic light wand
	{ id = 6299, chance = 80000 }, -- death ring
	{ id = 3051, chance = 80000 }, -- energy ring
	{ id = 3049, chance = 80000 }, -- stealth ring
	{ id = 3063, chance = 80000 }, -- gold ring
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 3290, chance = 80000 }, -- silver dagger
	{ id = 3061, chance = 80000 }, -- life crystal
	{ id = 3054, chance = 80000 }, -- silver amulet
	{ id = 3084, chance = 80000 }, -- protection amulet
	{ id = 3356, chance = 80000 }, -- devil helmet
	{ id = 3373, chance = 80000 }, -- strange helmet
	{ id = 3048, chance = 80000 }, -- might ring
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 3072, chance = 80000 }, -- wand of decay
	{ id = 3070, chance = 80000 }, -- moonlight rod
	{ id = 3281, chance = 80000 }, -- giant sword
	{ id = 3079, chance = 80000 }, -- boots of haste
	{ id = 5891, chance = 80000 }, -- enchanted chicken wing
	{ id = 5668, chance = 80000 }, -- mysterious voodoo skull
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3392, chance = 80000 }, -- royal helmet
	{ id = 5741, chance = 80000 }, -- skull helmet
	{ id = 3385, chance = 80000 }, -- crown helmet
	{ id = 3369, chance = 80000 }, -- warrior helmet
	{ id = 7391, chance = 80000 }, -- thaian sword
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
	{ id = 5884, chance = 80000 }, -- spirit container
	{ id = 5885, chance = 80000 }, -- flask of warriors sweat
	{ id = 3271, chance = 80000 }, -- spike sword
	{ id = 3280, chance = 80000 }, -- fire sword
	{ id = 8896, chance = 80000 }, -- slightly rusted armor
	{ id = 7402, chance = 80000 }, -- dragon slayer
	{ id = 6103, chance = 1000 }, -- unholy book
	{ id = 7417, chance = 1000 }, -- runed sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1088 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -500, length = 10, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -760, radius = 5, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -585, length = 8, spread = 3, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_ICEDAMAGE, minDamage = 0, maxDamage = -430, radius = 6, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "drunk", interval = 3000, chance = 11, radius = 6, effect = CONST_ME_SOUND_PURPLE, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 15, minDamage = -250, maxDamage = -250, radius = 4, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 50,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 400, maxDamage = 600, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 1000, chance = 4, speedChange = 400, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
