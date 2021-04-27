local mType = Game.createMonsterType("Gnomevil")
local monster = {}

monster.description = "Gnomevil"
monster.experience = 45000
monster.outfit = {
	lookType = 504,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "blood"
monster.corpse = 18443
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
	runHealth = 10000,
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
	{text = "No more Mr. Nicegnome!", yell = false},
	{text = "Taste the power of the dark side!", yell = false},
	{text = "I've seen the light! And it was all engulfing fire!", yell = false}
}

monster.loot = {
	{id = 18451, chance = 7030},
	{id = 18453, chance = 9120},
	{id = 18495, chance = 99150},
	{id = 18465, chance = 6690},
	{id = 18454, chance = 8400},
	{id = 18452, chance = 7120},
	{id = 18450, chance = 14100},
	{id = 18449, chance = 3710}
}

monster.attacks = {
	{name ="melee", interval = 1300, chance = 100, skill = 80, attack = 140},
	{name ="speed", interval = 2000, chance = 20, speedChange = -400, range = 7, shootEffect = CONST_ANI_WHIRLWINDAXE, target = false, duration = 2500},
	{name ="combat", interval = 2000, chance = 100, type = COMBAT_FIREDAMAGE, minDamage = -820, maxDamage = -950, range = 7, effect = CONST_ME_ENERGYAREA, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_MANADRAIN, minDamage = -230, maxDamage = -500, length = 8, spread = 3, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="combat", interval = 1000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = -350, maxDamage = -800, range = 3, effect = CONST_ME_PURPLEENERGY, target = true}
}

monster.defenses = {
	defense = 35,
	armor = 25,
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 4000, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = -20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
