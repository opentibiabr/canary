local mType = Game.createMonsterType("Troll-Trained Salamander")
local monster = {}

monster.description = "a troll-trained salamander"
monster.experience = 23
monster.outfit = {
	lookType = 529,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 70
monster.maxHealth = 70
monster.race = "blood"
monster.corpse = 17427
monster.speed = 56
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
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
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
	{ id = 3031, chance = 100000, maxCount = 11 }, -- Gold Coin
	{ id = 17457, chance = 28427, maxCount = 5 }, -- Insectoid Eggs
	{ id = 21470, chance = 17594, maxCount = 5 }, -- Simple Arrow
	{ id = 3577, chance = 10167 }, -- Meat
	{ id = 3352, chance = 5983 }, -- Chain Helmet
	{ id = 3274, chance = 5117 }, -- Axe
	{ id = 3337, chance = 4281 }, -- Bone Club
	{ id = 3294, chance = 4550 }, -- Short Sword
	{ id = 3376, chance = 3376 }, -- Studded Helmet
	{ id = 3448, chance = 3063, maxCount = 2 }, -- Poison Arrow
	{ id = 3457, chance = 4773 }, -- Shovel
	{ id = 266, chance = 1416 }, -- Health Potion
	{ id = 17457, chance = 14980 }, -- Insectoid Eggs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 10, attack = 11, condition = { type = CONDITION_POISON, totalDamage = 5, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_EARTHDAMAGE, minDamage = -4, maxDamage = -6, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_HITBYPOISON, target = true },
}

monster.defenses = {
	defense = 0,
	armor = 1,
	mitigation = 0.15,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
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
