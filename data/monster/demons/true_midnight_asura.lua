local mType = Game.createMonsterType("True Midnight Asura")
local monster = {}

monster.description = "a true midnight asura"
monster.experience = 7313
monster.outfit = {
	lookType = 1068,
	lookHead = 72,
	lookBody = 95,
	lookLegs = 72,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1621
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Asura Palace."
	}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 33360
monster.speed = 340
monster.manaCost = 0
monster.maxSummons = 0

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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
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
}

monster.loot = {
	{id = 2148, chance = 97000, maxCount = 242},
	{id = 2152, chance = 18200, maxCount = 6},
	{id = 7368, chance = 2000, maxCount = 2},
	{id = 2144, chance = 2000},
	{id = 6558, chance = 2000},
	{id = 6500, chance = 2210},
	{id = 2145, chance = 800, maxCount = 3},
	{id = 2149, chance = 900, maxCount = 3},
	{id = 2147, chance = 650, maxCount = 3},
	{id = 2146, chance = 580, maxCount = 3},
	{id = 9970, chance = 580, maxCount = 3},
	{id = 7591, chance = 700},
	{id = 2143, chance = 660},
	{id = 7404, chance = 430},
	{id = 2158, chance = 3420},
	{id = 2656, chance = 3400},
	{id = 9971, chance = 400},
	{id = 24630, chance = 600},
	{id = 2186, chance = 630},
	{id = 2185, chance = 690},
	{id = 24637, chance = 480},
	{id = 24631, chance = 500},
	{id = 8889, chance = 400},
	{id = 2134, chance = 600},
	{id = 2170, chance = 600},
	{id = 5944, chance = 600},
	{id = 8902, chance = 400},
	{id = 3967, chance = 400},
	{id = 8910, chance = 400},
	{id = 2154, chance = 400}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -70, range = 7, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 100, maxDamage = 400, length = 8, spread = 3, effect = CONST_ME_PURPLEENERGY, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = 100, maxDamage = 400, length = 8, spread = 3, effect = CONST_ME_BLACKSMOKE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = -100, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000},
	{name ="drunk", interval = 2000, chance = 10, range = 3, radius = 4, effect = CONST_ME_STUN, target = true, duration = 4000}
}

monster.defenses = {
	defense = 55,
	armor = 75,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000},
	{name ="invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = -15},
	{type = COMBAT_FIREDAMAGE, percent = 20},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
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
