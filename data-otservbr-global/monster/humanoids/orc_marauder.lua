local mType = Game.createMonsterType("Orc Marauder")
local monster = {}

monster.description = "an orc marauder"
monster.experience = 205
monster.outfit = {
	lookType = 342,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 614
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Zao Orc Land.",
}

monster.health = 235
monster.maxHealth = 235
monster.race = "blood"
monster.corpse = 10334
monster.speed = 195
monster.manaCost = 490

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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "Grrrrrr", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 55270, maxCount = 90 }, -- Gold Coin
	{ id = 3577, chance = 23784 }, -- Meat
	{ id = 10407, chance = 9350 }, -- Shaggy Tail
	{ id = 3350, chance = 5373 }, -- Bow
	{ id = 11451, chance = 5050 }, -- Broken Crossbow
	{ id = 11479, chance = 3930 }, -- Orc Leather
	{ id = 10196, chance = 4323 }, -- Orc Tooth
	{ id = 3313, chance = 1036 }, -- Obsidian Lance
	{ id = 3316, chance = 6539 }, -- Orcish Axe
	{ id = 3349, chance = 1117 }, -- Crossbow
	{ id = 8029, chance = 60 }, -- Silkweaver Bow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, shootEffect = CONST_ANI_ONYXARROW, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 16,
	mitigation = 0.83,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 350, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
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
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
