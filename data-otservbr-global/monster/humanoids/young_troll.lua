local mType = Game.createMonsterType("Young Troll")
local monster = {}

monster.description = "a young troll"
monster.experience = 12
monster.outfit = {
	lookType = 15,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 30
monster.maxHealth = 30
monster.race = "blood"
monster.corpse = 5960
monster.speed = 58
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
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
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
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
	{ text = "Hmmm, dogs", yell = false },
	{ text = "Gruntz!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 64269, maxCount = 5 }, -- Gold Coin
	{ id = 3577, chance = 26670 }, -- Meat
	{ id = 3003, chance = 7470 }, -- Rope
	{ id = 3277, chance = 6400 }, -- Spear
	{ id = 9689, chance = 1070 }, -- Bunch of Troll Hair
	{ id = 3552, chance = 5600 }, -- Leather Boots
	{ id = 3355, chance = 5330 }, -- Leather Helmet
	{ id = 3412, chance = 4800 }, -- Wooden Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -10 },
}

monster.defenses = {
	defense = 2,
	armor = 2,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
