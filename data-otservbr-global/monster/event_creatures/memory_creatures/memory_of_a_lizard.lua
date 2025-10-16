local mType = Game.createMonsterType("Memory of a Lizard")
local monster = {}

monster.description = "a memory of a lizard"
monster.experience = 1450
monster.outfit = {
	lookType = 337,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3520
monster.maxHealth = 3520
monster.race = "blood"
monster.corpse = 10355
monster.speed = 119
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
	canPushCreatures = false,
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
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 236, chance = 80000 }, -- strong health potion
	{ id = 10387, chance = 80000 }, -- zaoan legs
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 37468, chance = 80000 }, -- special fx box
	{ id = 3428, chance = 80000 }, -- tower shield
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 10328, chance = 80000 }, -- bunch of ripe rice
	{ id = 10386, chance = 80000 }, -- zaoan shoes
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	mitigation = 1.30,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 25, maxDamage = 75, effect = CONST_ME_MAGIC_GREEN, target = false },
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
