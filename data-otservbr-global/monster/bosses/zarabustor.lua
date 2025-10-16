local mType = Game.createMonsterType("Zarabustor")
local monster = {}

monster.description = "zarabustor"
monster.experience = 8000
monster.outfit = {
	lookType = 130,
	lookHead = 0,
	lookBody = 77,
	lookLegs = 92,
	lookFeet = 97,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 5100
monster.maxHealth = 5100
monster.race = "blood"
monster.corpse = 18273
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 421,
	bossRace = RARITY_NEMESIS,
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
	targetDistance = 4,
	runHealth = 900,
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
		{ name = "Warlock", chance = 10, interval = 2000, count = 2 },
		{ name = "Green Djinn", chance = 10, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Killing is such a splendid diversion from my studies.", yell = false },
	{ text = "Time to test my newest spells!", yell = false },
	{ text = "Ah, practice time once again!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 150 }, -- gold coin
	{ id = 3029, chance = 80000, maxCount = 2 }, -- small sapphire
	{ id = 7368, chance = 80000, maxCount = 3 }, -- assassin star
	{ id = 3299, chance = 80000 }, -- poison dagger
	{ id = 3567, chance = 80000 }, -- blue robe
	{ id = 3048, chance = 80000 }, -- might ring
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3360, chance = 80000 }, -- golden armor
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 825, chance = 80000 }, -- lightning robe
	{ id = 8074, chance = 80000 }, -- spellbook of mind control
	{ id = 3006, chance = 80000 }, -- ring of the sky
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -250, range = 7, radius = 3, shootEffect = CONST_ANI_BURSTARROW, effect = CONST_ME_FIREAREA, target = true },
	{ name = "firefield", interval = 2000, chance = 10, range = 7, radius = 2, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -250, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -130, maxDamage = -350, length = 8, spread = 0, effect = CONST_ME_BIGCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -250, range = 7, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -330, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
	{ name = "warlock skill reducer", interval = 2000, chance = 5, range = 5, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 225, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 95 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
