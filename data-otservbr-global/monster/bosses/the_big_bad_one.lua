local mType = Game.createMonsterType("The Big Bad One")
local monster = {}

monster.description = "The Big Bad One"
monster.experience = 170
monster.outfit = {
	lookType = 3,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 423,
	bossRace = RARITY_NEMESIS,
}

monster.health = 300
monster.maxHealth = 300
monster.race = "blood"
monster.corpse = 6009
monster.speed = 132
monster.manaCost = 420

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 80,
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
	{ text = "Yoooohhuuuu!", yell = false },
	{ text = "Grrrrrrr", yell = false },
}

monster.loot = {
	{ name = "meat", chance = 52940, maxCount = 4 },
	{ name = "ham", chance = 35290, maxCount = 2 },
	{ name = "wolf paw", chance = 5880, maxCount = 2 },
	{ id = 7394, chance = 35290 }, -- wolf trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50 },
}

monster.defenses = {
	defense = 15,
	armor = 8,
	mitigation = 0.41,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 1, maxDamage = 15, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -40 },
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
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
