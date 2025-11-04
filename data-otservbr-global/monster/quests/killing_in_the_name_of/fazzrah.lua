local mType = Game.createMonsterType("Fazzrah")
local monster = {}

monster.description = "Fazzrah"
monster.experience = 2600
monster.outfit = {
	lookType = 343,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 2955
monster.maxHealth = 2955
monster.race = "blood"
monster.corpse = 10367
monster.speed = 145
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
	{ id = 3031, chance = 100000, maxCount = 292 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 5876, chance = 100000 }, -- Lizard Leather
	{ id = 5881, chance = 100000 }, -- Lizard Scale
	{ id = 236, chance = 100000 }, -- Strong Health Potion
	{ id = 10413, chance = 100000 }, -- Zaogun Flag
	{ id = 10414, chance = 100000 }, -- Zaogun Shoulderplates
	{ id = 239, chance = 70370, maxCount = 3 }, -- Great Health Potion
	{ id = 3032, chance = 77780, maxCount = 5 }, -- Small Emerald
	{ id = 10289, chance = 35190 }, -- Red Lantern
	{ id = 10386, chance = 70370 }, -- Zaoan Shoes
	{ id = 10384, chance = 11110 }, -- Zaoan Armor
	{ id = 10387, chance = 11110 }, -- Zaoan Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -320 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -220, maxDamage = -270, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 168, maxDamage = 296, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 55 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
