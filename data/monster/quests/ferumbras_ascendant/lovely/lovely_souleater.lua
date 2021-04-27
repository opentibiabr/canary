local mType = Game.createMonsterType("Lovely Souleater")
local monster = {}

monster.description = "a lovely souleater"
monster.experience = 1300
monster.outfit = {
	lookType = 355,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "undead"
monster.corpse = 12631
monster.speed = 210
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Life is such a fickle thing!", yell = false},
	{text = "I will devour your soul.", yell = false},
	{text = "Souuuls!", yell = false},
	{text = "I will feed on you.", yell = false},
	{text = "Aaaahh", yell = false}
}

monster.loot = {
	{id = 12637, chance = 1990},
	{id = 12635, chance = 20},
	{id = 2148, chance = 88060, maxCount = 200},
	{id = 12636, chance = 15060},
	{id = 7590, chance = 7960},
	{id = 8473, chance = 9400},
	{id = 2152, chance = 49610, maxCount = 6},
	{id = 2189, chance = 910},
	{id = 2185, chance = 980},
	{id = 6300, chance = 330},
	{id = 5884, chance = 140}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 60, attack = 60},
	{name ="souleater drown", interval = 2000, chance = 9, target = false},
	{name ="combat", interval = 2000, chance = 8, type = COMBAT_ICEDAMAGE, minDamage = -50, maxDamage = -100, radius = 1, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_LIFEDRAIN, minDamage = -10, maxDamage = -60, radius = 4, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="souleater wave", interval = 2000, chance = 12, minDamage = -100, maxDamage = -210, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 25,
	{name ="invisible", interval = 2000, chance = 12, effect = CONST_ME_POFF},
	{name ="combat", interval = 2000, chance = 16, type = COMBAT_HEALING, minDamage = 130, maxDamage = 205, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
