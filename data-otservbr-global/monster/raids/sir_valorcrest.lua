local mType = Game.createMonsterType("Sir Valorcrest")
local monster = {}

monster.description = "Sir Valorcrest"
monster.experience = 1800
monster.outfit = {
	lookType = 287,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "undead"
monster.corpse = 8109
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 10
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{name = "Vampire", chance = 30, interval = 2000, count = 4}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I challenge you!", yell = false},
	{text = "A battle makes the blood so hot and sweet.", yell = false}
}

monster.loot = {
	{id = 7427, chance = 250}, -- chaos mace
	{id = 8192, chance = 100000}, -- vampire lord token
	{id = 236, chance = 1500}, -- strong health potion
	{id = 3091, chance = 1400}, -- sword ring
	{id = 3114, chance = 15000}, -- skull
	{id = 8192, chance = 100000}, -- vampire lord token
	{id = 3035, chance = 50000, maxCount = 5}, -- platinum coin
	{id = 3031, chance = 100000, maxCount = 93}, -- gold coin
	{id = 3434, chance = 6300} -- vampire shield
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 70, attack = 95},
	{name ="combat", interval = 1000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -190, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true}
}

monster.defenses = {
	defense = 35,
	armor = 38,
	{name ="combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 100, maxDamage = 235, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 3000, chance = 25, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -15},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
