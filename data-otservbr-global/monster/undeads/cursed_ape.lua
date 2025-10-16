local mType = Game.createMonsterType("Cursed Ape")
local monster = {}

monster.description = "a cursed ape"
monster.experience = 1860
monster.outfit = {
	lookType = 1592,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2347
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Iksupan",
}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 42073
monster.speed = 108
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 3587, chance = 80000 }, -- banana
	{ id = 3033, chance = 23000 }, -- small amethyst
	{ id = 11471, chance = 23000 }, -- kongras shoulderpad
	{ id = 3084, chance = 5000 }, -- protection amulet
	{ id = 3357, chance = 5000 }, -- plate armor
	{ id = 5883, chance = 1000 }, -- ape fur
	{ id = 266, chance = 1000 }, -- health potion
	{ id = 3050, chance = 1000 }, -- power ring
	{ id = 3081, chance = 1000 }, -- stone skin amulet
	{ id = 3093, chance = 260 }, -- club ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -498 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -210, maxDamage = -225, radius = 2, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 38,
	mitigation = 1.37,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
