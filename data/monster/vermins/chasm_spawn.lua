local mType = Game.createMonsterType("Chasm Spawn")
local monster = {}

monster.description = "a chasm spawn"
monster.experience = 3500
monster.outfit = {
	lookType = 1037,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1546
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Warzone 4."
	}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 30798
monster.speed = 115
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
	{text = "tzzzz tzzzz tzzzz!", yell = false},
	{text = "sloap sloap sloap!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 10000, maxCount = 78},
	{name = "Wood Mushroom", chance = 27200, maxCount = 5},
	{name = "Chasm Spawn Head", chance = 33390},
	{name = "Chasm Spawn Abdomen", chance = 24710},
	{name = "Chasm Spawn Tail", chance = 64890},
	{name = "Small Enchanted Emerald", chance = 11040, maxCount = 3},
	{name = "Small Enchanted Amethyst", chance = 8170, maxCount = 3},
	{name = "Brown Mushroom", chance = 19680, maxCount = 5},
	{name = "Orange Mushroom", chance = 15140},
	{name = "Blue Crystal Shard", chance = 7850},
	{name = "Green Crystal Shard", chance = 7850},
	{name = "Violet Crystal Shard", chance = 4690},
	{name = "Mushroom Backpack", chance = 610},
	{name = "Suspicious Device", chance = 520}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -5, maxDamage = -16, range = 7, shootEffect = CONST_ANI_POISON, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -60, range = 7, shootEffect = CONST_ANI_DEATH, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -70, maxDamage = -160, range = 3, length = 3, spread = 3, effect = CONST_ME_MORTAREA, target = false},
	{name ="explosion", interval = 2000, chance = 15, minDamage = -50, maxDamage = -170, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -40, maxDamage = -60, range = 7, target = false},
	{name ="stone shower", interval = 2000, chance = 10, minDamage = -70, maxDamage = -140, range = 7, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -70, maxDamage = -140, length = 3, spread = 3, effect = CONST_ME_PLANTATTACK, target = false}
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
