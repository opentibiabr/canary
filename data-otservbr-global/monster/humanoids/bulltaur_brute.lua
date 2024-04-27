local mType = Game.createMonsterType("Bulltaur Brute")
local monster = {}

monster.description = "a Bulltaur Brute"
monster.experience = 6560
monster.outfit = {
	lookType = 1717,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 4700
monster.maxHealth = 4700
monster.race = "blood"
monster.corpse = 44709
monster.speed = 170
monster.manaCost = 0

monster.raceId = 2447
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 25,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Bulltaurs Lair.",
}

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	{ text = "It's hammer time!", yell = false },
	{ text = "I'll do some downsizing!", yell = false },
	{ text = "This will be a smash hit!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 53709, maxCount = 33 },
	{ id = 44736, chance = 16095 },
	{ id = 44738, chance = 13883 },
	{ id = 9057, chance = 10239, maxCount = 3 },
	{ id = 44737, chance = 9718 },
	{ id = 21175, chance = 2950 },
	{ id = 3097, chance = 2516 },
	{ id = 3048, chance = 1432 },
	{ id = 3036, chance = 1258 },
	{ id = 3041, chance = 954 },
	{ id = 3040, chance = 824 },
	{ id = 3322, chance = 694 },
	{ id = 32769, chance = 607 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -170, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -600, range = 3, radius = 1, target = true, effect = CONST_ME_SLASH },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -500, range = 3, radius = 1, target = true, effect = CONST_ME_EXPLOSIONAREA },
}

monster.defenses = {
	defense = 100,
	armor = 78,
	mitigation = 2.22,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
