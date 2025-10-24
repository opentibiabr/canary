local mType = Game.createMonsterType("The Voice of Ruin")
local monster = {}

monster.description = "The Voice of Ruin"
monster.experience = 3500
monster.outfit = {
	lookType = 344,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 636,
	bossRace = RARITY_NEMESIS,
}

monster.health = 5500
monster.maxHealth = 5500
monster.race = "blood"
monster.corpse = 10371
monster.speed = 230
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 40,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 50,
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
	{ id = 3031, chance = 100000, maxCount = 95 }, -- Gold Coin
	{ id = 3035, chance = 33330, maxCount = 5 }, -- Platinum Coin
	{ id = 10408, chance = 44440 }, -- Spiked Iron Ball
	{ id = 10410, chance = 17393 }, -- Cursed Shoulder Spikes
	{ id = 10409, chance = 47829 }, -- Corrupted Flag
	{ id = 9058, chance = 20000 }, -- Gold Ingot
	{ id = 11673, chance = 5560 }, -- Scale of Corruption
	{ id = 10386, chance = 8699 }, -- Zaoan Shoes
	{ id = 10385, chance = 1000 }, -- Zaoan Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 80, attack = 100 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -440, maxDamage = -820, length = 3, spread = 2, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -290, maxDamage = -540, radius = 3, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -190, maxDamage = -480, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 1.86,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 475, maxDamage = 625, effect = CONST_ME_MAGIC_GREEN, target = false },
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
