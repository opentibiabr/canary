local mType = Game.createMonsterType("Paiz The Pauperizer")
local monster = {}

monster.description = "Paiz The Pauperizer"
monster.experience = 6300
monster.outfit = {
	lookType = 362,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 12609
monster.speed = 280
monster.manaCost = 0
monster.maxSummons = 0

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
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "For ze emperor!", yell = false},
	{text = "You will die zhouzandz deazhz!", yell = false}
}

monster.loot = {
	{id = 12616, chance = 100000},
	{id = 12617, chance = 100000},
	{id = 12614, chance = 100000},
	{id = 12615, chance = 100000},
	{id = 2148, chance = 100000, maxCount = 99},
	{id = 5881, chance = 100000},
	{id = 2666, chance = 100000, maxCount = 5},
	{id = 2152, chance = 100000, maxCount = 10},
	{id = 5904, chance = 43000},
	{id = 7591, chance = 36960, maxCount = 3},
	{id = 2154, chance = 36960},
	{id = 8472, chance = 32610, maxCount = 3},
	{id = 7590, chance = 30430, maxCount = 3},
	{id = 2156, chance = 23910},
	{id = 11306, chance = 23910},
	{id = 2155, chance = 21740},
	{id = 11307, chance = 19570},
	{id = 11301, chance = 15220},
	{id = 2492, chance = 13040},
	{id = 8880, chance = 10870},
	{id = 12613, chance = 10870},
	{id = 2158, chance = 8700},
	{id = 12607, chance = 8700},
	{id = 2149, chance = 8700, maxCount = 8},
	{id = 13294, chance = 4350}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -240, maxDamage = -550, length = 5, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -350, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -280, maxDamage = -450, range = 4, radius = 4, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_POFF, target = true},
	{name ="soulfire", interval = 2000, chance = 10, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 11, minDamage = -20, maxDamage = -20, range = 7, shootEffect = CONST_ANI_POISON, target = false}
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 230, maxDamage = 330, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 40},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 30},
	{type = COMBAT_DEATHDAMAGE , percent = 30}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
