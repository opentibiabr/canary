local mType = Game.createMonsterType("Dwarf Miner")
local monster = {}

monster.description = "a dwarf miner"
monster.experience = 60
monster.outfit = {
	lookType = 160,
	lookHead = 77,
	lookBody = 101,
	lookLegs = 97,
	lookFeet = 115,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 120
monster.maxHealth = 120
monster.race = "blood"
monster.corpse = 6007
monster.speed = 170
monster.manaCost = 420
monster.maxSummons = 0

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
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 80,
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
	{text = "Work, work!", yell = false},
	{text = "Intruders in the mines!", yell = false},
	{text = "Mine, all mine!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 33333, maxCount = 10},
	{name = "dwarven ring", chance = 793},
	{name = "axe", chance = 14285},
	{name = "studded armor", chance = 6666},
	{id = 2553, chance = 11111},
	{name = "leather legs", chance = 9090},
	{name = "meat", chance = 3846},
	{name = "iron ore", chance = 793}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -26}
}

monster.defenses = {
	defense = 10,
	armor = 7
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
