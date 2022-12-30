local mType = Game.createMonsterType("The Hag")
local monster = {}

monster.description = "The Hag"
monster.experience = 510
monster.outfit = {
	lookType = 264,
	lookHead = 19,
	lookBody = 20,
	lookLegs = 59,
	lookFeet = 2,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 935
monster.maxHealth = 935
monster.race = "blood"
monster.corpse = 7349
monster.speed = 102
monster.manaCost = 0

monster.changeTarget = {
	interval = 0,
	chance = 0
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 5,
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
	maxSummons = 2,
	summons = {
		{name = "Ghost", chance = 26, interval = 2000, count = 1},
		{name = "Crypt Shambler", chance = 26, interval = 2000, count = 1}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "If you think I am to old to fight then you're wrong!", yell = false},
	{text = "I've forgotten more things then you have ever learned!", yell = false},
	{text = "Let me teach you a few things youngster!", yell = false},
	{text = "I'll teach you respect for the old!", yell = false}
}

monster.loot = {
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100},
	{name ="drunk", interval = 3000, chance = 35, range = 5, radius = 1, target = true, duration = 15000},
	{name ="speed", interval = 4000, chance = 55, speedChange = -400, range = 5, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 12000}
}

monster.defenses = {
	defense = 25,
	armor = 24,
	{name ="combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 95, maxDamage = 155, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 3000, chance = 50, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
