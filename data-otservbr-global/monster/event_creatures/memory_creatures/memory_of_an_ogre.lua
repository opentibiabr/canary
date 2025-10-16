local mType = Game.createMonsterType("Memory of an Ogre")
local monster = {}

monster.description = "a memory of an ogre"
monster.experience = 1680
monster.outfit = {
	lookType = 857,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3570
monster.maxHealth = 3570
monster.race = "blood"
monster.corpse = 22143
monster.speed = 102
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
	{ id = 3026, chance = 80000 }, -- white pearl
	{ id = 3598, chance = 80000 }, -- cookie
	{ id = 236, chance = 80000 }, -- strong health potion
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 22194, chance = 80000 }, -- opal
	{ id = 3577, chance = 80000 }, -- meat
	{ id = 1781, chance = 80000 }, -- small stone
	{ id = 37468, chance = 80000 }, -- special fx box
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 22193, chance = 80000 }, -- onyx chip
	{ id = 3465, chance = 80000 }, -- pot
	{ id = 3050, chance = 80000 }, -- power ring
	{ id = 3093, chance = 80000 }, -- club ring
	{ id = 37530, chance = 80000 }, -- bottle of champagne
	{ id = 8907, chance = 80000 }, -- rusted helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110, condition = { type = CONDITION_FIRE, totalDamage = 6, interval = 9000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -100, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_TELEPORT, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	mitigation = 1.30,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false },
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
