local mType = Game.createMonsterType("Cult Believer")
local monster = {}

monster.description = "a cult believer"
monster.experience = 850
monster.outfit = {
	lookType = 132,
	lookHead = 98,
	lookBody = 96,
	lookLegs = 39,
	lookFeet = 38,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"CarlinVortexDeath",
}

monster.raceId = 1512
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Forbidden Temple (Carlin).",
}

monster.health = 975
monster.maxHealth = 975
monster.race = "blood"
monster.corpse = 22017
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
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
	{ text = "Death to the unbelievers!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 70 }, -- Gold Coin
	{ id = 3577, chance = 13120, maxCount = 2 }, -- Meat
	{ id = 239, chance = 6100 }, -- Great Health Potion
	{ id = 3028, chance = 2530 }, -- Small Diamond
	{ id = 3032, chance = 2410 }, -- Small Emerald
	{ id = 3033, chance = 2480 }, -- Small Amethyst
	{ id = 9639, chance = 4380 }, -- Cultish Robe
	{ id = 3572, chance = 1000 }, -- Scarf
	{ id = 2995, chance = 70 }, -- Piggy Bank
	{ id = 3048, chance = 180 }, -- Might Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -250 },
}

monster.defenses = {
	defense = 50,
	armor = 30,
	mitigation = 1.18,
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
