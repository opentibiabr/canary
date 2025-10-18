local mType = Game.createMonsterType("Dawnfly")
local monster = {}

monster.description = "a dawnfly"
monster.experience = 35
monster.outfit = {
	lookType = 528,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 90
monster.maxHealth = 90
monster.race = "venom"
monster.corpse = 21454
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
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
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 12 }, -- Gold Coin
	{ id = 21470, chance = 22429, maxCount = 16 }, -- Simple Arrow
	{ id = 3448, chance = 14428, maxCount = 8 }, -- Poison Arrow
	{ id = 50166, chance = 1000 }, -- Simple Jo Staff
	{ id = 3379, chance = 4754 }, -- Doublet
	{ id = 268, chance = 4166 }, -- Mana Potion
	{ id = 266, chance = 3777 }, -- Health Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 10, attack = 16, condition = { type = CONDITION_POISON, totalDamage = 8, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -4, maxDamage = -8, range = 7, shootEffect = CONST_ANI_POISONARROW, target = false },
}

monster.defenses = {
	defense = 2,
	armor = 3,
	mitigation = 0.25,
	{ name = "speed", interval = 2000, chance = 11, speedChange = 238, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
