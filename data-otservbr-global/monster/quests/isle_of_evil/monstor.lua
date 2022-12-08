local mType = Game.createMonsterType("Monstor")
local monster = {}

monster.description = "Monstor"
monster.experience = 575
monster.outfit = {
	lookType = 244,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 960
monster.maxHealth = 960
monster.race = "blood"
monster.corpse = 6335
monster.speed = 175
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

monster.light = {
	level = 0,
	color = 0
}

monster.summon = {
	maxSummons = 3,
	summons = {
		{name = "Acid Blob", chance = 40, interval = 4000, count = 3}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "NO ARMY ME STOPPING! GRARR!", yell = false},
	{text = "ME DESTROY CITY! GROAR!", yell = false},
	{text = "WHARR! MUST ... KIDNAP WOMEN!", yell = false}
}

monster.loot = {
	{id = 9381, chance = 1000}, -- helmet of ultimate terror
	{id = 9386, chance = 1000}, -- farmer's avenger
	{id = 9380, chance = 1000}, -- shield of care
	{id = 9396, chance = 1000} -- incredible mumpiz slayer
}

monster.attacks = {
	{name ="melee", interval = 1200, chance = 100, minDamage = 0, maxDamage = -167},
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_LIFEDRAIN, minDamage = -66, maxDamage = -85, length = 6, spread = 3, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 90, maxDamage = 200, effect = CONST_ME_HITBYFIRE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = -7},
	{type = COMBAT_EARTHDAMAGE, percent = 30},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = -3},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
