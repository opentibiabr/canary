local mType = Game.createMonsterType("Arthei")
local monster = {}

monster.description = "Arthei"
monster.experience = 4000
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
	bossRaceId = 480,
	bossRace = RARITY_BANE,
}

monster.health = 4200
monster.maxHealth = 4200
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
		{ name = "Shadow of Boreth", chance = 3, interval = 2000, count = 1 },
		{ name = "Shadow of Lersatio", chance = 3, interval = 2000, count = 1 },
		{ name = "Shadow of Marziel", chance = 3, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Marziel! Lersatio! Boreth! Come join me in this fight!", yell = false },
	{ text = "Now that you're here, you'll stay forever.", yell = false },
	{ text = "You have no idea who you're messing with.", yell = false },
	{ text = "I don't regret anything.", yell = false },
	{ text = "I will revenge my brothers!", yell = false },
	{ text = "Stupid little human - I'm glad I'm past that pitiful stadium of my life.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, minCount = 0, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 9430, minCount = 0, maxCount = 5 }, -- platinum coin
	{ id = 236, chance = 19260, minCount = 0, maxCount = 1 }, -- strong health potion
	{ id = 11449, chance = 88520 }, -- blood preservation
	{ id = 3098, chance = 10250 }, -- ring of healing
	{ id = 3434, chance = 410 }, -- vampire shield
	{ id = 7419, chance = 450 }, -- dreaded cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -560 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -160, range = 1, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -120, range = 7, shootEffect = CONST_ANI_SNIPERARROW, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -800, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MAGIC_RED, target = false, duration = 30000 },
}

monster.defenses = {
	defense = 35,
	armor = 38,
	mitigation = 1.04,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 3000, chance = 25, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
