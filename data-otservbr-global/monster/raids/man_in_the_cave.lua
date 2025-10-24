local mType = Game.createMonsterType("Man in the Cave")
local monster = {}

monster.description = "man in the cave"
monster.experience = 777
monster.outfit = {
	lookType = 128,
	lookHead = 77,
	lookBody = 59,
	lookLegs = 20,
	lookFeet = 76,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 338,
	bossRace = RARITY_NEMESIS,
}

monster.health = 485
monster.maxHealth = 485
monster.race = "blood"
monster.corpse = 18165
monster.speed = 105
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
	runHealth = 50,
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

monster.summon = {
	maxSummons = 5,
	summons = {
		{ name = "Monk", chance = 20, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "THE MONKS ARE MINE!", yell = true },
	{ text = "I will rope you up! All of you!", yell = false },
	{ text = "Have you seen my old pal Frack?", yell = false },
	{ text = "A MIC to rule them all!", yell = false },
	{ text = "Let me put my rope around your neck!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 25000, maxCount = 40 }, -- Gold Coin
	{ id = 3003, chance = 100000, maxCount = 3 }, -- Rope
	{ id = 5913, chance = 31250 }, -- Brown Piece of Cloth
	{ id = 7386, chance = 34380 }, -- Mercenary Sword
	{ id = 7458, chance = 18750 }, -- Fur Cap
	{ id = 7290, chance = 9380 }, -- Shard
	{ id = 3602, chance = 3130 }, -- Brown Bread
	{ id = 7463, chance = 1000 }, -- Mammoth Fur Cape
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -62 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -95, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 1.00,
	{ name = "speed", interval = 2000, chance = 12, speedChange = 250, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 10, maxDamage = 50, effect = CONST_ME_MAGIC_BLUE, target = false },
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
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
