local mType = Game.createMonsterType("Boreth")
local monster = {}

monster.description = "Boreth"
monster.experience = 1800
monster.outfit = {
	lookType = 287,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"BorethDeath",
}

monster.bosstiary = {
	bossRaceId = 479,
	bossRace = RARITY_BANE,
}

monster.health = 1400
monster.maxHealth = 1400
monster.race = "undead"
monster.corpse = 8109
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Vampire", chance = 30, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I'll water my plants with your blood!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, minCount = 0, maxCount = 100 }, -- gold coin
	{ id = 11449, chance = 86380 }, -- blood preservation
	{ id = 236, chance = 21050 }, -- strong health potion
	{ id = 3098, chance = 10990 }, -- ring of healing
	{ id = 3035, chance = 9750, minCount = 0, maxCount = 5 }, -- platinum coin
	{ id = 3027, chance = 2010 }, -- black pearl
	{ id = 3434, chance = 1080 }, -- vampire shield
	{ id = 7419, chance = 620 }, -- dreaded cleaver
	{ id = 8045, chance = 150 }, -- hibiscus dress
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -200, range = 1, effect = CONST_ME_SMALLCLOUDS, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 38,
	mitigation = 1.04,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 3000, chance = 25, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
