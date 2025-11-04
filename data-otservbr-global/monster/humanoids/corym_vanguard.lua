local mType = Game.createMonsterType("Corym Vanguard")
local monster = {}

monster.description = "a corym vanguard"
monster.experience = 490
monster.outfit = {
	lookType = 534,
	lookHead = 0,
	lookBody = 19,
	lookLegs = 121,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 918
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Venore Corym Cave, Tiquanda Corym Cave, Corym Black Market, \z
		Carlin Corym Cave/Dwarf Mines Diggers Depths Mine, Upper Spike.",
}

monster.health = 700
monster.maxHealth = 700
monster.race = "blood"
monster.corpse = 17454
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 50,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{ text = "Gimme! Gimme!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99984, maxCount = 90 }, -- Gold Coin
	{ id = 3607, chance = 17718 }, -- Cheese
	{ id = 17809, chance = 9860 }, -- Bola
	{ id = 17817, chance = 14374 }, -- Cheese Cutter
	{ id = 17819, chance = 10570 }, -- Earflap
	{ id = 17820, chance = 15298 }, -- Soft Cheese
	{ id = 17821, chance = 14678 }, -- Rat Cheese
	{ id = 17810, chance = 3608 }, -- Spike Shield
	{ id = 17812, chance = 3677 }, -- Ratana
	{ id = 17813, chance = 3515 }, -- Life Preserver
	{ id = 17818, chance = 3109 }, -- Cheesy Figurine
	{ id = 17846, chance = 1557 }, -- Leather Harness
	{ id = 17859, chance = 2812 }, -- Spiky Club
	{ id = 17825, chance = 15 }, -- Rat God Doll
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -140 },
	{ name = "corym vanguard wave", interval = 2000, chance = 10, minDamage = -50, maxDamage = -100, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -40, maxDamage = -70, radius = 4, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 29,
	mitigation = 0.99,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 30, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
