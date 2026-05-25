local mType = Game.createMonsterType("Marziel")
local monster = {}

monster.description = "Marziel"
monster.experience = 3000
monster.outfit = {
	lookType = 287,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 481,
	bossRace = RARITY_BANE,
}

monster.health = 1900
monster.maxHealth = 1900
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
	maxSummons = 3,
	summons = {
		{ name = "Vampire", chance = 30, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "My brides will show you how to suffer beautifully.", yell = false },
	{ text = "I smell warm blood.", yell = false },
	{ text = "Why are you disturbing me and my brides?", yell = false },
	{ text = "You shouldn't have come.", yell = false },
	{ text = "You! You had no right to read my diary!", yell = false },
	{ text = "I... want... your... blood!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 22220, minCount = 0, maxCount = 7 }, -- platinum coin
	{ id = 3031, chance = 100000, minCount = 0, maxCount = 100 }, -- gold coin
	{ id = 236, chance = 22220 }, -- strong health potion
	{ id = 3098, chance = 5560 }, -- ring of healing
	{ id = 3434, chance = 5560 }, -- vampire shield
	{ id = 7419, chance = 500 }, -- dreaded cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
}

monster.defenses = {
	defense = 35,
	armor = 38,
	mitigation = 1.04,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 43 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
