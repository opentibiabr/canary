local mType = Game.createMonsterType("Cult Enforcer")
local monster = {}

monster.description = "a cult enforcer"
monster.experience = 1000
monster.outfit = {
	lookType = 134,
	lookHead = 95,
	lookBody = 19,
	lookLegs = 57,
	lookFeet = 76,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"CarlinVortexDeath",
}

monster.raceId = 1513
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

monster.health = 1150
monster.maxHealth = 1150
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
	{ text = "No one will stop us!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 70 }, -- Gold Coin
	{ id = 3577, chance = 11140 }, -- Meat
	{ id = 239, chance = 6440 }, -- Great Health Potion
	{ id = 9639, chance = 4960 }, -- Cultish Robe
	{ id = 3028, chance = 2970 }, -- Small Diamond
	{ id = 3033, chance = 2319 }, -- Small Amethyst
	{ id = 3032, chance = 2660 }, -- Small Emerald
	{ id = 3269, chance = 2890 }, -- Halberd
	{ id = 3572, chance = 530 }, -- Scarf
	{ id = 3279, chance = 750 }, -- War Hammer
	{ id = 3048, chance = 510 }, -- Might Ring
	{ id = 3415, chance = 390 }, -- Guardian Shield
	{ id = 3371, chance = 180 }, -- Knight Legs
	{ id = 3369, chance = 260 }, -- Warrior Helmet
	{ id = 2995, chance = 40 }, -- Piggy Bank
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -360 },
}

monster.defenses = {
	defense = 50,
	armor = 30,
	mitigation = 1.24,
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
