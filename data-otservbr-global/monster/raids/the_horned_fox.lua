local mType = Game.createMonsterType("The Horned Fox")
local monster = {}

monster.description = "the Horned Fox"
monster.experience = 4400
monster.outfit = {
	lookType = 202,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 7990
monster.maxHealth = 7990
monster.race = "blood"
monster.corpse = 5983
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 20,
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
	maxSummons = 5,
	summons = {
		{ name = "Minotaur Hunter", chance = 15, interval = 1000, count = 2 },
		{ name = "Minotaur Amazon", chance = 15, interval = 1000, count = 1 },
		{ name = "Worm Princess", chance = 15, interval = 1000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will never get me!", yell = false },
	{ text = "I'll be back!", yell = false },
	{ text = "Catch me, if you can!", yell = false },
	{ text = "Help me, Gang!", yell = false },
}

monster.loot = {
	{ id = 5804, chance = 100000 }, -- nose ring
	{ id = 3031, chance = 96000, maxCount = 99 }, -- gold coin
	{ id = 3035, chance = 38890, maxCount = 3 }, -- platinum coin
	{ id = 5878, chance = 100000 }, -- minotaur leather
	{ id = 11472, chance = 92590, maxCount = 2 }, -- minotaur horn
	{ id = 11482, chance = 85000 }, -- piece of warrior armor
	{ id = 3450, chance = 48000, maxCount = 14 }, -- power bolt
	{ id = 3577, chance = 18000, maxCount = 3 }, -- meat
	{ id = 3049, chance = 10000 }, -- stealth ring
	{ id = 3483, chance = 7410 }, -- fishing rod
	{ id = 236, chance = 7410 }, -- strong health potion
	{ id = 7401, chance = 900 }, -- minotaur trophy,
	{ id = 21174, chance = 12000 }, -- mino lance
	{ id = 21175, chance = 6000 }, -- mino shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -525 },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -20, range = 7, shootEffect = CONST_ANI_BOLT, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 1000, chance = 40, minDamage = -10, maxDamage = -200, range = 10, shootEffect = CONST_ANI_POISON, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 30,
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 80, maxDamage = 100, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "invisible", interval = 1000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -1 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
