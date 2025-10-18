local mType = Game.createMonsterType("Orc Berserker")
local monster = {}

monster.description = "an orc berserker"
monster.experience = 195
monster.outfit = {
	lookType = 8,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 8
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Orc Fort, Dwacatra, Orc Peninsula, Elvenbane, Edron Orc Cave, Plains of Havoc, below Point of No Return in Outlaw Camp, Maze of Lost Souls, Cyclopolis, Desert Dungeon, Ancient Temple, Foreigner Quarter, Zao Orc Land.",
}

monster.health = 210
monster.maxHealth = 210
monster.race = "blood"
monster.corpse = 5980
monster.speed = 125
monster.manaCost = 590

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 40,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
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
	{ text = "KRAK ORRRRRRK!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 54822, maxCount = 12 }, -- Gold Coin
	{ id = 3266, chance = 6500 }, -- Battle Axe
	{ id = 3269, chance = 7331 }, -- Halberd
	{ id = 3582, chance = 10207 }, -- Ham
	{ id = 11477, chance = 10082 }, -- Orcish Gear
	{ id = 3347, chance = 4610 }, -- Hunting Spear
	{ id = 11479, chance = 4149 }, -- Orc Leather
	{ id = 10196, chance = 3190 }, -- Orc Tooth
	{ id = 3358, chance = 6574 }, -- Chain Armor
	{ id = 2914, chance = 5151 }, -- Lamp
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
}

monster.defenses = {
	defense = 15,
	armor = 12,
	mitigation = 0.30,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 290, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
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
