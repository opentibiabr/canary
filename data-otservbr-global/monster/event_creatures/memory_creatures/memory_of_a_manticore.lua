local mType = Game.createMonsterType("Memory of a Manticore")
local monster = {}

monster.description = "a memory of a manticore"
monster.experience = 1590
monster.outfit = {
	lookType = 1189,
	lookHead = 116,
	lookBody = 97,
	lookLegs = 113,
	lookFeet = 20,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3730
monster.maxHealth = 3730
monster.race = "blood"
monster.corpse = 31390
monster.speed = 150
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
	targetDistance = 4,
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
	{ id = 25737, chance = 80000 }, -- rainbow quartz
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 16127, chance = 80000 }, -- green crystal fragment
	{ id = 37468, chance = 80000 }, -- special fx box
	{ id = 37530, chance = 80000 }, -- bottle of champagne
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 763, chance = 80000 }, -- flaming arrow
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 24962, chance = 80000 }, -- prismatic quartz
	{ id = 25759, chance = 80000 }, -- royal star
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -150, length = 8, spread = 0, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -150, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_FIREDAMAGE, minDamage = -10, maxDamage = -100, range = 4, shootEffect = CONST_ANI_BURSTARROW, target = true },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 1.20,
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
