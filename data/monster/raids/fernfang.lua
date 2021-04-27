local mType = Game.createMonsterType("Fernfang")
local monster = {}

monster.description = "Fernfang"
monster.experience = 600
monster.outfit = {
	lookType = 206,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 400
monster.maxHealth = 400
monster.race = "blood"
monster.corpse = 20566
monster.speed = 240
monster.manaCost = 0
monster.maxSummons = 3

monster.changeTarget = {
	interval = 5000,
	chance = 8
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 50,
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
	targetDistance = 4,
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

monster.summons = {
	{name = "War Wolf", chance = 13, interval = 1000}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You desacrated this place!", yell = false},
	{text = "I will cleanse this isle!", yell = false},
	{text = "Grrrrrrr", yell = false},
	{text = "Yoooohuuuu!", yell = true}
}

monster.loot = {
	{id = 10563, chance = 100000},
	{id = 2148, chance = 100000, maxCount = 95},
	{id = 2152, chance = 93000, maxCount = 3},
	{id = 2800, chance = 86000},
	{id = 12448, chance = 53000},
	{id = 2166, chance = 40000},
	{id = 12449, chance = 40000},
	{id = 2154, chance = 33000},
	{id = 2015, chance = 20000},
	{id = 7589, chance = 20000},
	{id = 2044, chance = 13000},
	{id = 2401, chance = 13000},
	{id = 5786, chance = 13000},
	{id = 2260, chance = 7000},
	{id = 2689, chance = 7000},
	{id = 2652, chance = 7000},
	{id = 2177, chance = 7000},
	{id = 2802, chance = 7000},
	{id = 2129, chance = 7000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50},
	{name ="combat", interval = 1000, chance = 13, type = COMBAT_HOLYDAMAGE, minDamage = -65, maxDamage = -180, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = false},
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -20, maxDamage = -45, range = 7, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.defenses = {
	defense = 10,
	armor = 15,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 10, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 1000, chance = 7, speedChange = 280, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000},
	{name ="outfit", interval = 1000, chance = 5, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 14000, outfitMonster = "War Wolf"}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 70},
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
