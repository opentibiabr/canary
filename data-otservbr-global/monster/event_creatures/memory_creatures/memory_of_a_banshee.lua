local mType = Game.createMonsterType("Memory of a Banshee")
local monster = {}

monster.description = "a memory of a banshee"
monster.experience = 1430
monster.outfit = {
	lookType = 78,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3600
monster.maxHealth = 3600
monster.race = "undead"
monster.corpse = 6019
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	runHealth = 500,
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
	{ id = 3260, chance = 80000 }, -- lyre
	{ id = 3004, chance = 80000 }, -- wedding ring
	{ id = 3299, chance = 80000 }, -- poison dagger
	{ id = 37530, chance = 80000 }, -- bottle of champagne
	{ id = 37468, chance = 80000 }, -- special fx box
	{ id = 2917, chance = 80000 }, -- candlestick
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 3568, chance = 80000 }, -- simple dress
	{ id = 3054, chance = 80000 }, -- silver amulet
	{ id = 6093, chance = 80000 }, -- crystal ring
	{ id = 237, chance = 80000 }, -- strong mana potion
	{ id = 3081, chance = 80000 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100, condition = { type = CONDITION_POISON, totalDamage = 3, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -150, radius = 4, effect = CONST_ME_SOUND_RED, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -55, maxDamage = -170, range = 1, radius = 1, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -300, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 1.10,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 120, maxDamage = 190, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
