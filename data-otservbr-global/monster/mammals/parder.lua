local mType = Game.createMonsterType("Parder")
local monster = {}

monster.description = "a parder"
monster.experience = 1100
monster.outfit = {
	lookType = 1533,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2256
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "In almost all grass areas in Tibia, also found in Rookgaard and Dawnport.",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 39204
monster.speed = 115
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
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
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
	{ text = "Grrroaaar!", yell = false },
	{ text = "FCHHH!", yell = true },
}

monster.loot = {
	{ name = "Gold Coin", chance = 100000, minCount = 1, maxCount = 285 },
	{ name = "Ham", chance = 24670 },
	{ name = "Parder Fur", chance = 19070 },
	{ name = "Parder Tooth", chance = 14320, minCount = 1, maxCount = 2 },
	{ name = "Red Crystal Fragment", chance = 14030 },
	{ name = "Strong Health Potion", chance = 7560, minCount = 1, maxCount = 3 },
	{ name = "Barbarian Axe", chance = 4540 },
	{ id = 7385, chance = 1510 }, -- Crimson Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -275 },
	{ name = "combat", interval = 2500, chance = 47, type = COMBAT_PHYSICALDAMAGE, minDamage = -126, maxDamage = -262, effect = CONST_ME_BIG_SCRATCH, target = true, range = 1 },
	{ name = "combat", interval = 2850, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -260, maxDamage = -300, length = 5, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 90,
	armor = 33,
	mitigation = 1.15,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
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
