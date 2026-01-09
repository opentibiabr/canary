local mType = Game.createMonsterType("Swamp Troll")
local monster = {}

monster.description = "a swamp troll"
monster.experience = 25
monster.outfit = {
	lookType = 76,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 76
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Port Hope Swamp Trolls, Venore Swamp Troll Cave, all around north area of Port Hope, \z
		small spawn north-west of Venore and in cave south-east of Thais, also one in Foreigner Quarter.",
}

monster.health = 55
monster.maxHealth = 55
monster.race = "venom"
monster.corpse = 6018
monster.speed = 64
monster.manaCost = 320

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
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
	{ text = "Me strong! Me ate spinach!", yell = false },
	{ text = "Groar!", yell = false },
	{ text = "Grrrr", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 48777, maxCount = 5 }, -- Gold Coin
	{ id = 3578, chance = 60939 }, -- Fish
	{ id = 3552, chance = 9672 }, -- Leather Boots
	{ id = 3120, chance = 10110 }, -- Mouldy Cheese
	{ id = 3277, chance = 13366 }, -- Spear
	{ id = 2920, chance = 15136 }, -- Torch
	{ id = 9686, chance = 2876 }, -- Swamp Grass
	{ id = 5901, chance = 1870 }, -- Wood
	{ id = 12517, chance = 2456 }, -- Medicine Pouch
	{ id = 3741, chance = 927 }, -- Troll Green
	{ id = 3483, chance = 143 }, -- Fishing Rod
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -13, condition = { type = CONDITION_POISON, totalDamage = 1, interval = 4000 } },
}

monster.defenses = {
	defense = 15,
	armor = 6,
	mitigation = 0.25,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
