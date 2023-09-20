local mType = Game.createMonsterType("Capricious Phantom")
local monster = {}

monster.description = "a capricious phantom"
monster.experience = 19360
monster.outfit = {
	lookType = 1298,
	lookHead = 81,
	lookBody = 114,
	lookLegs = 85,
	lookFeet = 83,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1932
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Ebb and Flow.",
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "undead"
monster.corpse = 34121
monster.speed = 240
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
	targetDistance = 4,
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
	{ text = "I hope you can't swim.", yell = false },
	{ text = "Troubled Water. Troubled you!", yell = false },
	{ text = "You should shiver!", yell = false },
	{ text = "You will leak blood.", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 77650 },
	{ name = "great spirit potion", chance = 61410, maxCount = 5 },
	{ name = "blue gem", chance = 9410 },
	{ name = "gold ingot", chance = 9410 },
	{ name = "capricious heart", chance = 7530 },
	{ name = "violet gem", chance = 4710 },
	{ name = "capricious robe", chance = 2350 },
	{ id = 23529, chance = 1880 }, -- ring of blue plasma
	{ name = "fur armor", chance = 1650 },
	{ name = "wood cape", chance = 1410 },
	{ id = 23542, chance = 1180 }, -- collar of blue plasma
	{ name = "glacial rod", chance = 940 },
	{ name = "ornate crossbow", chance = 940 },
	{ id = 34109, chance = 20 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -850, maxDamage = -1200, range = 7, radius = 3, shootEffect = CONST_ANI_POISONARROW, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -1050, length = 6, spread = 4, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -850, maxDamage = -900, radius = 3, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -850, maxDamage = -1100, range = 7, radius = 4, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "ice chain", interval = 2000, chance = 15, minDamage = -1100, maxDamage = -1300, range = 7 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
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
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
