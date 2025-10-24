local mType = Game.createMonsterType("Orc")
local monster = {}

monster.description = "an orc"
monster.experience = 25
monster.outfit = {
	lookType = 5,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 5
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Ulderek's Rock, Edron Orc Cave, Ancient Temple, Ice Islands, Venore Orc Cave, \z
		Rookgaard Orc Fortress, Rookgaard main cave, Fibula Dungeon, Elvenbane, Foreigner Quarter, Zao Orc Land.",
}

monster.health = 70
monster.maxHealth = 70
monster.race = "blood"
monster.corpse = 5966
monster.speed = 75
monster.manaCost = 300

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
	runHealth = 15,
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
	{ text = "Grow truk grrrrr.", yell = false },
	{ text = "Prek tars, dekklep zurk.", yell = false },
	{ text = "Grak brrretz!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 84852, maxCount = 14 }, -- Gold Coin
	{ id = 3274, chance = 7832 }, -- Axe
	{ id = 3577, chance = 12876 }, -- Meat
	{ id = 3273, chance = 6122 }, -- Sabre
	{ id = 3378, chance = 11459 }, -- Studded Armor
	{ id = 3426, chance = 9733 }, -- Studded Shield
	{ id = 3376, chance = 8504 }, -- Studded Helmet
	{ id = 23986, chance = 821 }, -- Heavy Old Tome
	{ id = 11479, chance = 493 }, -- Orc Leather
	{ id = 10196, chance = 115 }, -- Orc Tooth
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -35 },
}

monster.defenses = {
	defense = 10,
	armor = 4,
	mitigation = 0.20,
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
