local mType = Game.createMonsterType("Acolyte of the Cult")
local monster = {}

monster.description = "an acolyte of the cult"
monster.experience = 300
monster.outfit = {
	lookType = 194,
	lookHead = 95,
	lookBody = 100,
	lookLegs = 100,
	lookFeet = 19,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 253
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Goroma, Deeper Cult Cave, Formorgar Mines, Magician Quarter, Forbidden Temple.",
}

monster.health = 390
monster.maxHealth = 390
monster.race = "blood"
monster.corpse = 18038
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Skeleton", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Praise the voodoo!", yell = false },
	{ text = "Power to the cult!", yell = false },
	{ text = "Feel the power of the cult!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 66000, maxCount = 40 }, -- Gold Coin
	{ id = 11492, chance = 10100 }, -- Rope Belt
	{ id = 9639, chance = 8100 }, -- Cultish Robe
	{ id = 3282, chance = 5100 }, -- Morning Star
	{ id = 3085, chance = 1100 }, -- Dragon Necklace
	{ id = 5810, chance = 1000 }, -- Pirate Voodoo Doll
	{ id = 2828, chance = 720 }, -- Book (Orange)
	{ id = 3032, chance = 500 }, -- Small Emerald
	{ id = 6088, chance = 500 }, -- Music Sheet (Second Verse)
	{ id = 3052, chance = 490 }, -- Life Ring
	{ id = 3065, chance = 220 }, -- Terra Rod
	{ id = 11455, chance = 75 }, -- Cultish Symbol
	{ id = 11652, chance = 45 }, -- Broken Key Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100, condition = { type = CONDITION_POISON, totalDamage = 2, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -60, maxDamage = -120, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "drunk", interval = 2000, chance = 5, range = 7, radius = 1, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true, duration = 3000 },
}

monster.defenses = {
	defense = 15,
	armor = 30,
	mitigation = 1.13,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 40, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
