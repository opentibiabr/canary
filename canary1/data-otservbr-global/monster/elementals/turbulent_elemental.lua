local mType = Game.createMonsterType("Turbulent Elemental")
local monster = {}

monster.description = "a turbulent elemental"
monster.experience = 19360
monster.outfit = {
	lookType = 1314,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1940
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Ebb and Flow.",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "blood"
monster.corpse = 33905
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	{ name = "crystal coin", chance = 74880 },
	{ name = "gold ingot", chance = 22270 },
	{ name = "ultimate health potion", chance = 17300, maxCount = 4 },
	{ name = "sacred tree amulet", chance = 6160 },
	{ name = "blue gem", chance = 4980 },
	{ name = "springsprout rod", chance = 4270 },
	{ name = "northwind rod", chance = 3320 },
	{ name = "violet gem", chance = 3080 },
	{ name = "glacier amulet", chance = 2840 },
	{ name = "glacier robe", chance = 1900 },
	{ name = "fur armor", chance = 1420 },
	{ name = "wood cape", chance = 950 },
	{ name = "crystalline armor", chance = 710 },
	{ name = "rubber cap", chance = 710 },
	{ name = "stone skin amulet", chance = 470 },
	{ id = 34109, chance = 20 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -900, maxDamage = -1350, range = 7, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1000, range = 7, shootEffect = CONST_ANI_HUNTINGSPEAR, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 4000, chance = 24, type = COMBAT_ICEDAMAGE, minDamage = -950, maxDamage = -1260, radius = 4, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_ICEDAMAGE, minDamage = -950, maxDamage = -1260, radius = 4, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -950, maxDamage = -1100, length = 5, radius = 2, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "soulwars fear", interval = 2000, chance = 1, target = true },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	mitigation = 2.72,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
