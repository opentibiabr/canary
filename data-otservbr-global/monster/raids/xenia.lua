local mType = Game.createMonsterType("Xenia")
local monster = {}

monster.description = "Xenia"
monster.experience = 255
monster.outfit = {
	lookType = 137,
	lookHead = 95,
	lookBody = 116,
	lookLegs = 39,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 428,
	bossRace = RARITY_NEMESIS,
}

monster.health = 200
monster.maxHealth = 200
monster.race = "blood"
monster.corpse = 18261
monster.speed = 88
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
	runHealth = 10,
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
	{ text = "Yeeyeeyeee!", yell = false },
	{ text = "Fight me if you dare!", yell = false },
	{ text = "I challenge you!", yell = false },
}

monster.loot = {
	{ id = 3114, chance = 100000, maxCount = 2 }, -- skull
	{ name = "gold coin", chance = 66666, maxCount = 34 },
	{ name = "sabre", chance = 33000 },
	{ name = "studded shield", chance = 33000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50 },
	{ name = "drunk", interval = 2000, chance = 10, length = 3, spread = 2, effect = CONST_ME_SOUND_RED, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 0.71,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
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
