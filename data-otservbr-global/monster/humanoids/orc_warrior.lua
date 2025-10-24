local mType = Game.createMonsterType("Orc Warrior")
local monster = {}

monster.description = "an orc warrior"
monster.experience = 50
monster.outfit = {
	lookType = 7,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 7
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Ancient Temple in Thais, Orc Fort, below Point of No Return in Outlaw Camp and inside a \z
		mountain north of it, Orc Peninsula, Folda, Edron Orc cave, Maze of Lost Souls, Elvenbane Castle, \z
		Foreigner Quarter, Zao Orc Land.",
}

monster.health = 125
monster.maxHealth = 125
monster.race = "blood"
monster.corpse = 5979
monster.speed = 95
monster.manaCost = 360

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 11,
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
	{ text = "Alk!", yell = false },
	{ text = "Trak grrrr brik.", yell = false },
	{ text = "Grow truk grrrr.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 64836, maxCount = 15 }, -- Gold Coin
	{ id = 11453, chance = 9866 }, -- Broken Helmet
	{ id = 3358, chance = 7623 }, -- Chain Armor
	{ id = 3577, chance = 15237 }, -- Meat
	{ id = 11479, chance = 4022 }, -- Orc Leather
	{ id = 3430, chance = 594 }, -- Copper Shield
	{ id = 23986, chance = 1211 }, -- Heavy Old Tome
	{ id = 10196, chance = 910 }, -- Orc Tooth
	{ id = 11480, chance = 941 }, -- Skull Belt
	{ id = 3299, chance = 133 }, -- Poison Dagger
	{ id = 50194, chance = 480 }, -- Light Bandana
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -60 },
}

monster.defenses = {
	defense = 15,
	armor = 8,
	mitigation = 0.36,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
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
