local mType = Game.createMonsterType("Lizard Snakecharmer")
local monster = {}

monster.description = "a lizard snakecharmer"
monster.experience = 210
monster.outfit = {
	lookType = 115,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 115
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Chor, Forbidden Temple.",
}

monster.health = 325
monster.maxHealth = 325
monster.race = "blood"
monster.corpse = 6041
monster.speed = 172
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 4,
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 6,
	summons = {
		{ name = "cobra", chance = 20, interval = 2000, count = 6 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I smeeeel warm blood!", yell = false },
	{ text = "Shhhhhhh", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 83090, maxCount = 55 }, -- Gold Coin
	{ id = 3998, chance = 1000 }, -- Dead Snake (Item)
	{ id = 3565, chance = 9586 }, -- Cape
	{ id = 3061, chance = 1222 }, -- Life Crystal
	{ id = 5876, chance = 1014 }, -- Lizard Leather
	{ id = 268, chance = 720 }, -- Mana Potion
	{ id = 3065, chance = 1270 }, -- Terra Rod
	{ id = 5881, chance = 1090 }, -- Lizard Scale
	{ id = 3033, chance = 586 }, -- Small Amethyst
	{ id = 3052, chance = 140 }, -- Life Ring
	{ id = 3407, chance = 90 }, -- Charmer's Tiara
	{ id = 3066, chance = 130 }, -- Snakebite Rod
	{ id = 3037, chance = 50 }, -- Yellow Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -30 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -100, maxDamage = -200, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -110, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 22,
	mitigation = 0.38,
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
