local mType = Game.createMonsterType("Orc Rider")
local monster = {}

monster.description = "an orc rider"
monster.experience = 110
monster.outfit = {
	lookType = 4,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 4
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Orc Fort, Orc Peninsula, near Dark Cathedral, Zao Orc Land.",
}

monster.health = 180
monster.maxHealth = 180
monster.race = "blood"
monster.corpse = 6010
monster.speed = 130
monster.manaCost = 490

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 30,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
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
	{ text = "Orc arga Huummmak!", yell = false },
	{ text = "Grrrrrrr", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 48450, maxCount = 81 }, -- Gold Coin
	{ id = 3577, chance = 24352, maxCount = 3 }, -- Meat
	{ id = 11479, chance = 10090 }, -- Orc Leather
	{ id = 3316, chance = 11597 }, -- Orcish Axe
	{ id = 10318, chance = 7889 }, -- Warwolf Fur
	{ id = 3012, chance = 11695 }, -- Wolf Tooth Chain
	{ id = 10196, chance = 1883 }, -- Orc Tooth
	{ id = 3413, chance = 1236 }, -- Battle Shield
	{ id = 3313, chance = 881 }, -- Obsidian Lance
	{ id = 3377, chance = 477 }, -- Scale Armor
	{ id = 2920, chance = 4526 }, -- Torch
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130 },
}

monster.defenses = {
	defense = 15,
	armor = 9,
	mitigation = 0.51,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 200, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
