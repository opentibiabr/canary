local mType = Game.createMonsterType("Morguthis")
local monster = {}

monster.description = "Morguthis"
monster.experience = 3000
monster.outfit = {
	lookType = 84,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 4800
monster.maxHealth = 4800
monster.race = "undead"
monster.corpse = 6025
monster.speed = 295
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 84,
	bossRace = RARITY_BANE,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 3,
	summons = {
		{ name = "Hero", chance = 100, interval = 2000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Vengeance!", yell = false },
	{ text = "You will make a fine trophy.", yell = false },
	{ text = "Come and fight me, cowards!", yell = false },
	{ text = "I am the supreme warrior!", yell = false },
	{ text = "Let me hear the music of battle.", yell = false },
	{ text = "Another one to bite the dust!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 221 }, -- gold coin
	{ id = 3237, chance = 80000 }, -- sword hilt
	{ id = 7368, chance = 80000, maxCount = 3 }, -- assassin star
	{ id = 3027, chance = 80000 }, -- black pearl
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 3318, chance = 80000 }, -- knight axe
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 3019, chance = 260 }, -- demonbone amulet
	{ id = 10290, chance = 260 }, -- mini mummy
	{ id = 3331, chance = 260 }, -- ravagers axe
	{ id = 3554, chance = 260 }, -- steel boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000, condition = { type = CONDITION_POISON, totalDamage = 65, interval = 4000 } },
	{ name = "combat", interval = 3000, chance = 7, type = COMBAT_LIFEDRAIN, minDamage = -55, maxDamage = -550, range = 1, target = false },
	{ name = "speed", interval = 1000, chance = 25, speedChange = -650, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 50000 },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -40, maxDamage = -400, radius = 3, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 3000, chance = 7, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -500, radius = 3, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 35,
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 7, speedChange = 1201, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 52 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 60 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 62 },
	{ type = COMBAT_HOLYDAMAGE, percent = -22 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
