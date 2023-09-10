local mType = Game.createMonsterType("Sabretooth")
local monster = {}

monster.description = "a sabretooth"
monster.experience = 11931
monster.outfit = {
	lookType = 1549,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2267
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Sparkling Pools",
}

monster.health = 17300
monster.maxHealth = 17300
monster.race = "blood"
monster.corpse = 39287
monster.speed = 225
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "Sabretooth Fur", chance = 23640 },
	{ name = "Crystal Coin", chance = 23350, minCount = 1, maxCount = 2 },
	{ name = "Elven Amulet", chance = 5010 },
	{ name = "Wand of Inferno", chance = 4720 },
	{ name = "Dragon Necklace", chance = 3850 },
	{ name = "Magma Coat", chance = 3820 },
	{ name = "Sacred Tree Amulet", chance = 2730 },
	{ name = "Fire Sword", chance = 2650 },
	{ name = "Wand of Dragonbreath", chance = 2330 },
	{ name = "Metal Spats", chance = 2260 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100 },
	{ name = "sabretooth wave", interval = 5000, chance = 35, minDamage = -600, maxDamage = -1000 },
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -800, maxDamage = -1500, range = 1, effect = CONST_ME_BIG_SCRATCH, target = true },
	{ name = "combat", interval = 2700, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -1350, range = 1, target = true },
}

monster.defenses = {
	defense = 110,
	armor = 63,
	mitigation = 1.62,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
