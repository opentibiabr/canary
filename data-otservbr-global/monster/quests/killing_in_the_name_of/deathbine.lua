local mType = Game.createMonsterType("Deathbine")
local monster = {}

monster.description = "Deathbine"
monster.experience = 340
monster.outfit = {
	lookType = 120,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 525
monster.maxHealth = 525
monster.race = "venom"
monster.corpse = 6047
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	rewardBoss = true,
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
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 10300, chance = 98982, maxCount = 5 }, -- Carniphila Seeds
	{ id = 3740, chance = 100000 }, -- Shadow Herb
	{ id = 3032, chance = 91157, maxCount = 4 }, -- Small Emerald
	{ id = 3728, chance = 78910 }, -- Dark Mushroom
	{ id = 647, chance = 72108 }, -- Seeds
	{ id = 8084, chance = 54650 }, -- Springsprout Rod
	{ id = 814, chance = 54080 }, -- Terra Amulet
	{ id = 813, chance = 41156 }, -- Terra Boots
	{ id = 5014, chance = 3744 }, -- Mandrake
	{ id = 12320, chance = 4762 }, -- Sweet Smelling Bait
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 30, attack = 100, condition = { type = CONDITION_POISON, totalDamage = 5, interval = 4000 } },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -90, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "speed", interval = 1000, chance = 34, speedChange = -850, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_HITBYPOISON, target = false, duration = 30000 },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -40, maxDamage = -130, radius = 3, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 10,
	armor = 26,
	mitigation = 0.61,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
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
