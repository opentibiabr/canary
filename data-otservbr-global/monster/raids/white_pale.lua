local mType = Game.createMonsterType("White Pale")
local monster = {}

monster.description = "White Pale"
monster.experience = 390
monster.outfit = {
	lookType = 564,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 965,
	bossRace = RARITY_NEMESIS,
}

monster.health = 500
monster.maxHealth = 500
monster.race = "blood"
monster.corpse = 18978
monster.speed = 85
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 19083, chance = 200 }, -- silver raid token
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3031, chance = 70000, maxCount = 100 }, -- gold coin
	{ id = 19359, chance = 500 }, -- horn
	{ id = 19358, chance = 500 }, -- albino plate
	{ id = 3052, chance = 1000 }, -- life ring
	{ id = 3028, chance = 7000 }, -- small diamond
	{ id = 3577, chance = 70000, maxCount = 4 }, -- meat
	{ id = 9692, chance = 70000 }, -- lump of dirt
	{ id = 3327, chance = 70000 }, -- daramian mace
	{ id = 10275, chance = 70000 }, -- carrion worm fang
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 45, attack = 40 },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -110, radius = 5, effect = CONST_ME_SMALLPLANTS, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 12, minDamage = -200, maxDamage = -300, radius = 3, effect = CONST_ME_HITAREA, target = false },
	{ name = "white pale paralyze", interval = 2000, chance = 11, target = false },
}

monster.defenses = {
	defense = 11,
	armor = 8,
	mitigation = 0.87,
	{ name = "white pale summon", interval = 2000, chance = 12, target = false },
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
