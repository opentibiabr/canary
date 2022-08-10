local mType = Game.createMonsterType("The Ravager")
local monster = {}

monster.description = "The Ravager"
monster.experience = 14980
monster.outfit = {
	lookType = 91,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 53500
monster.maxHealth = 53500
monster.race = "undead"
monster.corpse = 6031
monster.speed = 170
monster.manaCost = 0

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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.events = {
	"TheRavagerDeath"
}

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 16,
	summons = {
		{name = "Elder Mummy", chance = 9, interval = 2000, count = 4},
		{name = "Canopic Jar", chance = 9, interval = 2000, count = 4},
		{name = "Greater Canopic Jar", chance = 9, interval = 2000, count = 8}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 3031, chance = 95000, maxCount = 243}, -- gold coin
	{id = 238, chance = 10000, maxCount = 5}, -- great mana potion
	{id = 239, chance = 5000, maxCount = 5}, -- great health potion
	{id = 3035, chance = 37500, maxCount = 5}, -- platinum coin
	{id = 3042, chance = 15000, maxCount = 5}, -- scarab coin
	{id = 3328, chance = 5000} -- daramian waraxe
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 82, attack = 70, condition = {type = CONDITION_POISON, totalDamage = 320, interval = 4000}},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -750, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_DEATHDAMAGE, minDamage = -700, maxDamage = -880, length = 8, spread = 3, effect = CONST_ME_SMALLCLOUDS, target = false},
	{name ="combat", interval = 2000, chance = 18, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -500, length = 7, spread = 3, effect = CONST_ME_SMOKE, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 25,
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 400, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 5},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 35},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
