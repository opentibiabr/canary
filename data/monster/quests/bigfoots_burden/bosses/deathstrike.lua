local mType = Game.createMonsterType("Deathstrike")
local monster = {}

monster.description = "Deathstrike"
monster.experience = 40000
monster.outfit = {
	lookType = 500,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 200000
monster.maxHealth = 200000
monster.race = "blood"
monster.corpse = 18384
monster.speed = 470
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	staticAttackChance = 50,
	targetDistance = 1,
	runHealth = 2000,
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
	{text = "Deeestructiooon!", yell = false},
	{text = "Maaahhhrrr!", yell = false},
	{text = "I am carnage incarnate!", yell = false},
	{text = "I've seen the light! And it was all engulfing fire!", yell = false},
	{text = "Taaake... this!", yell = false}
}

monster.loot = {
	{id = 18465, chance = 8430},
	{id = 18452, chance = 6570},
	{id = 18450, chance = 10480},
	{id = 18430, chance = 100000},
	{id = 18453, chance = 12380},
	{id = 18451, chance = 7430},
	{id = 18454, chance = 11430}
}

monster.attacks = {
	{name ="melee", interval = 1300, chance = 100, skill = 80, attack = 120},
	{name ="speed", interval = 2000, chance = 20, speedChange = -400, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, target = false, duration = 2500},
	{name ="combat", interval = 2000, chance = 100, type = COMBAT_FIREDAMAGE, minDamage = -820, maxDamage = -950, range = 7, effect = CONST_ME_FIREAREA, target = false},
	{name ="combat", interval = 1000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -800, range = 3, effect = CONST_ME_PURPLEENERGY, target = true}
}

monster.defenses = {
	defense = 35,
	armor = 25,
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 5500, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 40},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 40},
	{type = COMBAT_HOLYDAMAGE , percent = 20},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
