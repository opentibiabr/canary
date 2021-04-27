local mType = Game.createMonsterType("Scar Tribe Shaman")
local monster = {}

monster.description = "an scar tribe shaman"
monster.experience = 85
monster.outfit = {
	lookType = 6,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 115
monster.maxHealth = 115
monster.race = "blood"
monster.corpse = 5978
monster.speed = 156
monster.manaCost = 0
monster.maxSummons = 4

monster.changeTarget = {
	interval = 2000,
	chance = 50
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.summons = {
	{name = "Snake", chance = 25, interval = 2000, max = 4}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 12408, chance = 3700},
	{id = 2686, chance = 11110, maxCount = 2},
	{id = 2148, chance = 100000, maxCount = 17},
	{id = 11113, chance = 11110},
	{id = 12434, chance = 3700},
	{id = 2389, chance = 55560},
	{id = 2484, chance = 3700},
	{id = 2468, chance = 11110}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 10, attack = 10},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -10, maxDamage = -25, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_FIREDAMAGE, minDamage = -5, maxDamage = -30, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true}
}

monster.defenses = {
	defense = 11,
	armor = 4,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 25, maxDamage = 35, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
