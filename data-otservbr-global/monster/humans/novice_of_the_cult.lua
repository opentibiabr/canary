local mType = Game.createMonsterType("Novice of the Cult")
local monster = {}

monster.description = "a novice of the cult"
monster.experience = 100
monster.outfit = {
	lookType = 133,
	lookHead = 114,
	lookBody = 114,
	lookLegs = 76,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 255
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Liberty Bay Cult Cave, Formorgar Mines, Yalahar Magician Quarter, \z
		in the caves on top of the Hrodmir mountains.",
}

monster.health = 285
monster.maxHealth = 285
monster.race = "blood"
monster.corpse = 18186
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 40,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Chicken", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Fear us!", yell = false },
	{ text = "You will not tell anyone what you have seen!", yell = false },
	{ text = "Your curiosity will be punished!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 40 }, -- gold coin
	{ id = 11492, chance = 23000 }, -- rope belt
	{ id = 3572, chance = 5000 }, -- scarf
	{ id = 9639, chance = 1000 }, -- cultish robe
	{ id = 3097, chance = 1000 }, -- dwarven ring
	{ id = 5810, chance = 1000 }, -- pirate voodoo doll
	{ id = 3083, chance = 1000 }, -- garlic necklace
	{ id = 3074, chance = 1000 }, -- wand of vortex
	{ id = 3028, chance = 260 }, -- small diamond
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -65, condition = { type = CONDITION_POISON, totalDamage = 1, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -20, maxDamage = -80, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_MAGIC_RED, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 0.62,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 20, maxDamage = 40, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -8 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -8 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
