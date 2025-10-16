local mType = Game.createMonsterType("Memory of a Dwarf")
local monster = {}

monster.description = "a memory of a dwarf"
monster.experience = 1460
monster.outfit = {
	lookType = 70,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3730
monster.maxHealth = 3730
monster.race = "blood"
monster.corpse = 6013
monster.speed = 103
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 20,
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
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 3305, chance = 80000 }, -- battle hammer
	{ id = 3723, chance = 80000 }, -- white mushroom
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 829, chance = 80000 }, -- glacier mask
	{ id = 3413, chance = 80000 }, -- battle shield
	{ id = 3092, chance = 80000 }, -- axe ring
	{ id = 266, chance = 80000 }, -- health potion
	{ id = 3377, chance = 80000 }, -- scale armor
	{ id = 3351, chance = 80000 }, -- steel helmet
	{ id = 3275, chance = 80000 }, -- double axe
	{ id = 818, chance = 80000 }, -- magma boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -140 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 1.10,
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
