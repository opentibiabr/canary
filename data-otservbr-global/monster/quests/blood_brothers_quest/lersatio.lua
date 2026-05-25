local mType = Game.createMonsterType("Lersatio")
local monster = {}

monster.description = "Lersatio"
monster.experience = 2500
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
	bossRaceId = 482,
	bossRace = RARITY_BANE,
}

monster.health = 1645
monster.maxHealth = 1645
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
	{ text = "The monsters in the mirrors will come eat your dreams.", yell = false },
	{ text = "Your pitiful life has come to an end.", yell = false },
	{ text = "One day I will see my pretty face in a mirror again.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, minCount = 1, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 9740, minCount = 0, maxCount = 5 }, -- platinum coin
	{ id = 11449, chance = 89580 }, -- blood preservation
	{ id = 236, chance = 23660 }, -- strong health potion
	{ id = 3098, chance = 11000 }, -- ring of healing
	{ id = 3027, chance = 1850 }, -- black pearl
	{ id = 3434, chance = 580 }, -- vampire shield
	{ id = 7419, chance = 490 }, -- dreaded cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -300, range = 7, shootEffect = CONST_ANI_SNIPERARROW, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -120, range = 1, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -190, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 38,
	mitigation = 1.04,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 100, maxDamage = 235, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 3000, chance = 25, effect = CONST_ME_MAGIC_BLUE },
	{ name = "outfit", interval = 2000, chance = 18, target = true, duration = 5000, outfitMonster = "bat" },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 40 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
