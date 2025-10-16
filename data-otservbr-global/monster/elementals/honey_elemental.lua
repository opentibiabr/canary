local mType = Game.createMonsterType("Honey Elemental")
local monster = {}

monster.description = "a honey elemental"
monster.experience = 2400
monster.outfit = {
	lookType = 1733,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2551
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Chocolate Mines",
}

monster.health = 2560
monster.maxHealth = 2560
monster.race = "undead"
monster.corpse = 48112
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "*Squelch*", yell = false },
	{ text = "**Slurp**", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 236, chance = 23000 }, -- strong health potion
	{ id = 3028, chance = 5000 }, -- small diamond
	{ id = 3032, chance = 5000, maxCount = 2 }, -- small emerald
	{ id = 5902, chance = 5000 }, -- honeycomb
	{ id = 3048, chance = 5000 }, -- might ring
	{ id = 48253, chance = 5000 }, -- beijinho
	{ id = 814, chance = 1000 }, -- terra amulet
	{ id = 818, chance = 1000 }, -- magma boots
	{ id = 821, chance = 1000 }, -- magma legs
	{ id = 48250, chance = 1000, maxCount = 6 }, -- dark chocolate coin
	{ id = 3280, chance = 260 }, -- fire sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -260 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -125, maxDamage = -235, radius = 4, effect = CONST_ME_YELLOW_RINGS, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 34,
	mitigation = 1.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
