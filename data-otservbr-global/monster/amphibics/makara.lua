local mType = Game.createMonsterType("Makara")
local monster = {}

monster.description = "a makara"
monster.experience = 5720
monster.outfit = {
	lookType = 1565,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2262
monster.Bestiary = {
	class = "Amphibic",
	race = BESTY_RACE_AMPHIBIC,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Temple of the Moon Goddess.",
}

monster.health = 5050
monster.maxHealth = 5050
monster.race = "blood"
monster.corpse = 39366
monster.speed = 175
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
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "waddle waddle", yell = false },
	{ text = "Nihahaha!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 13 }, -- platinum coin
	{ id = 3577, chance = 23000 }, -- meat
	{ id = 39401, chance = 23000 }, -- makara fin
	{ id = 39402, chance = 23000 }, -- makara tongue
	{ id = 25737, chance = 5000, maxCount = 2 }, -- rainbow quartz
	{ id = 16127, chance = 5000 }, -- green crystal fragment
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 16125, chance = 5000 }, -- cyan crystal fragment
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 3028, chance = 5000, maxCount = 3 }, -- small diamond
	{ id = 31323, chance = 260 }, -- sea horse figurine
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -145, maxDamage = -390, target = true }, -- basic_attack
	{ name = "combat", interval = 2500, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -305, maxDamage = -390, radius = 3, effect = CONST_ME_STONES, shootEffect = CONST_ANI_EARTH, target = true }, -- stone_shower_ball
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -305, maxDamage = -390, radius = 5, effect = CONST_ME_STONES, shootEffect = CONST_ANI_EARTH, target = true }, -- great_stone_shower_ball
	{ name = "combat", interval = 3500, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -360, maxDamage = -390, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = true }, -- ice_strike
	{ name = "makarawatersplash", interval = 4000, chance = 25, minDamage = -380, maxDamage = -455, target = false }, -- short_water_cone-wave
}

monster.defenses = {
	defense = 74,
	armor = 74,
	mitigation = 1.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
