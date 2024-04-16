local mType = Game.createMonsterType("White Weretiger")
local monster = {}

monster.description = "a white weretiger"
monster.experience = 5200
monster.outfit = {
	lookType = 1646,
	lookHead = 19,
	lookBody = 59,
	lookLegs = 113,
	lookFeet = 94,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 2387
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Murky Caverns",
}

monster.health = 6100
monster.maxHealth = 6100
monster.race = "blood"
monster.corpse = 43762
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	canPushCreatures = true,
	staticAttackChance = 80,
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

monster.voices = {}

monster.loot = {
	{ name = "gold coin", chance = 100000, maxCount = 100 },
	{ name = "platinum coin", chance = 100000, maxCount = 20 },
	{ name = "weretiger tooth", chance = 13400 },
	{ name = "beastslayer axe", chance = 3970 },
	{ name = "ham", chance = 5500, maxCount = 2 },
	{ name = "moonlight crystals", chance = 7000 },
	{ name = "white gem", chance = 1650 },
	{ name = "silver moon coin", chance = 2000 },
	{ name = "blue robe", chance = 1160 },
	{ name = "moon pin", chance = 660 },
	{ name = "crystal mace", chance = 500 },
	{ id = 43915, chance = 610 }, -- weretiger trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -585 },
	{ name = "white weretiger ice ring", interval = 3700, chance = 20, minDamage = -300, maxDamage = -425 },
	{ name = "energy ring", interval = 4300, chance = 40, minDamage = -300, maxDamage = -425 },
	{ name = "combat", interval = 2300, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -375, radius = 2, effect = CONST_ME_ICEAREA, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 83,
	mitigation = 2.25,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
