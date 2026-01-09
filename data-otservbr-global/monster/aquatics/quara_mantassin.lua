local mType = Game.createMonsterType("Quara Mantassin")
local monster = {}

monster.description = "a quara mantassin"
monster.experience = 600
monster.outfit = {
	lookType = 72,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 241
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Calassa, Frozen Trench, Yalahar (Sunken Quarter).",
}

monster.health = 800
monster.maxHealth = 800
monster.race = "blood"
monster.corpse = 6064
monster.speed = 295
monster.manaCost = 480

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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 40,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Shrrrr", yell = false },
	{ text = "Zuerk Pachak!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 78220, maxCount = 130 }, -- Gold Coin
	{ id = 11489, chance = 11665 }, -- Mantassin Tail
	{ id = 3269, chance = 4355 }, -- Halberd
	{ id = 3581, chance = 4857, maxCount = 5 }, -- Shrimp
	{ id = 3565, chance = 6325 }, -- Cape
	{ id = 5895, chance = 711 }, -- Fish Fin
	{ id = 3029, chance = 537 }, -- Small Sapphire
	{ id = 3049, chance = 670 }, -- Stealth Ring
	{ id = 3265, chance = 6897 }, -- Two Handed Sword
	{ id = 3373, chance = 105 }, -- Strange Helmet
	{ id = 3567, chance = 193 }, -- Blue Robe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -138, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 15,
	armor = 16,
	mitigation = 0.70,
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 400, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
