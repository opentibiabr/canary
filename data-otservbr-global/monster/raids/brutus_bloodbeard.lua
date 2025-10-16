local mType = Game.createMonsterType("Brutus Bloodbeard")
local monster = {}

monster.description = "Brutus Bloodbeard"
monster.experience = 795
monster.outfit = {
	lookType = 98,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1555
monster.maxHealth = 1555
monster.race = "blood"
monster.corpse = 18197
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0,
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
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 6099, chance = 80000 }, -- brutus bloodbeards hat
	{ id = 3577, chance = 80000 }, -- meat
	{ id = 3357, chance = 80000 }, -- plate armor
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 3370, chance = 5000 }, -- knight armor
	{ id = 9185, chance = 5000 }, -- very old piece of paper
	{ id = 239, chance = 1000 }, -- great health potion
	{ id = 5926, chance = 1000 }, -- pirate backpack
	{ id = 3267, chance = 1000 }, -- dagger
	{ id = 3084, chance = 1000 }, -- protection amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -175 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -175, range = 7, shootEffect = CONST_ANI_THROWINGSTAR, target = false },
	{ name = "drunk", interval = 2000, chance = 10, length = 3, spread = 2, effect = CONST_ME_POFF, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 50,
	armor = 35,
	mitigation = 1.20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -1 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
