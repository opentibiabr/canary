local mType = Game.createMonsterType("Neferi the Spy")
local monster = {}

monster.description = "Neferi the Spy"
monster.experience = 19650
monster.outfit = {
	lookType = 149,
	lookHead = 95,
	lookBody = 121,
	lookLegs = 94,
	lookFeet = 1,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "blood"
monster.corpse = 36982
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "crystal coin", chance = 4366, maxCount = 1},
	{name = "terra rod", chance = 2276},
	{name = "dagger", chance = 1791},
	{name = "ultimate health potion", chance = 1119, maxCount = 4},
	{name = "gold ingot", chance = 1045, maxCount = 1},
	{name = "great spirit potion", chance = 784, maxCount = 2},
	{name = "fire sword", chance = 746},
	{name = "terra boots", chance = 522},
	{name = "hailstorm rod", chance = 485},
	{name = "lightning headband", chance = 410},
	{name = "terra hood", chance = 373},
	{name = "knight axe", chance = 336},
	{name = "lightning legs", chance = 336},
	{id = 23533, chance = 299}, -- ring of red plasma
	{name = "spellbook of warding", chance = 261},
	{name = "glacier shoes", chance = 224},
	{name = "knight armor", chance = 224},
	{name = "eye-embroidered veil", chance = 187},
	{name = "violet crystal shard", chance = 187},
	{name = "glacier mask", chance = 149},
	{name = "sea horse figurine", chance = 149},
	{id = 3049, chance = 149}, -- stealth ring
	{name = "violet gem", chance = 149},
	{name = "golden mask", chance = 75},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -350},
	{name ="combat", interval = 2000, chance = 60, type = COMBAT_EARTHDAMAGE, minDamage = -700, maxDamage = -1100, radius = 3, effect = CONST_ME_SMALLPLANTS, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -650, maxDamage = -800, range = 5, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)