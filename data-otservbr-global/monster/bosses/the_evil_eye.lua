local mType = Game.createMonsterType("The Evil Eye")
local monster = {}

monster.description = "The Evil Eye"
monster.experience = 750
monster.outfit = {
	lookType = 210,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 210,
	bossRace = RARITY_NEMESIS,
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 6037
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 100,
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
	targetDistance = 3,
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
	maxSummons = 5,
	summons = {
		{ name = "demon skeleton", chance = 13, interval = 1000, count = 5 },
		{ name = "ghost", chance = 12, interval = 1000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Inferior creatures, bow before my power!", yell = false },
	{ text = "653768764!", yell = false },
}

monster.loot = {
	{ id = 5898, chance = 100000 }, -- bonelord eye
	{ name = "gold coin", chance = 100000, maxCount = 100 },
	{ name = "gold coin", chance = 100000, maxCount = 100 },
	{ name = "gold coin", chance = 100000, maxCount = 29 },
	{ name = "bonelord shield", chance = 13640 },
	{ name = "bonelord helmet", chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 65, attack = 24 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -60, maxDamage = -130, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_FIREDAMAGE, minDamage = -85, maxDamage = -115, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 1000, chance = 17, type = COMBAT_PHYSICALDAMAGE, minDamage = -135, maxDamage = -175, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -40, maxDamage = -120, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -110, maxDamage = -130, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = -850, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_EARTHDAMAGE, minDamage = -35, maxDamage = -85, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 1000, chance = 6, type = COMBAT_LIFEDRAIN, minDamage = -75, maxDamage = -85, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 1000, chance = 9, type = COMBAT_MANADRAIN, minDamage = -150, maxDamage = -250, length = 8, spread = 3, effect = CONST_ME_LOSEENERGY, target = false },
}

monster.defenses = {
	defense = 23,
	armor = 19,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 9, type = COMBAT_HEALING, minDamage = 1, maxDamage = 219, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
