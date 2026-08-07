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
	{ id = 3031, chance = 100000, maxCount = 121 }, -- Gold Coin
	{ id = 3577, chance = 31000 }, -- Meat
	{ id = 236, chance = 29000 }, -- Strong Health Potion
	{ id = 3598, chance = 12400, maxCount = 5 }, -- Cookie
	{ id = 3030, chance = 9000, maxCount = 2 }, -- Small Ruby
	{ id = 3026, chance = 7900 }, -- White Pearl
	{ id = 1781, chance = 7900, maxCount = 5 }, -- Small Stone
	{ id = 3050, chance = 5600 }, -- Power Ring
	{ id = 22194, chance = 4500, maxCount = 2 }, -- Opal
	{ id = 3093, chance = 4500 }, -- Club Ring
	{ id = 22193, chance = 3400, maxCount = 2 }, -- Onyx Chip
	{ id = 37468, chance = 720 }, -- Special Fx Box
	{ id = 3465, chance = 1080 }, -- Pot
	{ id = 37531, chance = 2170 }, -- Candy Floss (Large)
	{ id = 37530, chance = 1080 }, -- Bottle of Champagne
	{ id = 8907, chance = 360 }, -- Rusted Helmet
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
