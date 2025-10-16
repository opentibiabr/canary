local mType = Game.createMonsterType("Corym Skirmisher")
local monster = {}

monster.description = "a corym skirmisher"
monster.experience = 260
monster.outfit = {
	lookType = 533,
	lookHead = 0,
	lookBody = 76,
	lookLegs = 83,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 917
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

monster.health = 450
monster.maxHealth = 450
monster.race = "blood"
monster.corpse = 17446
monster.speed = 100
monster.manaCost = 695

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
	{ text = "Squeak! Squeak!", yell = false },
	{ text = "<sniff> <sniff> <sniff>", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 45 }, -- gold coin
	{ id = 3607, chance = 23000 }, -- cheese
	{ id = 17821, chance = 23000 }, -- rat cheese
	{ id = 17820, chance = 23000 }, -- soft cheese
	{ id = 17817, chance = 23000 }, -- cheese cutter
	{ id = 17819, chance = 23000 }, -- earflap
	{ id = 17809, chance = 23000 }, -- bola
	{ id = 17813, chance = 5000 }, -- life preserver
	{ id = 17812, chance = 5000 }, -- ratana
	{ id = 17818, chance = 1000 }, -- cheesy figurine
	{ id = 17810, chance = 1000 }, -- spike shield
	{ id = 17846, chance = 1000 }, -- leather harness
	{ id = 17825, chance = 260 }, -- rat god doll
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -90, range = 7, shootEffect = CONST_ANI_WHIRLWINDCLUB, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 25,
	mitigation = 0.96,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
