local mType = Game.createMonsterType("Troll Marauder")
local monster = {}

monster.description = "a troll marauder"
monster.experience = 40
monster.outfit = {
	lookType = 281,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 70
monster.maxHealth = 70
monster.race = "blood"
monster.corpse = 7926
monster.speed = 120
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 15,
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
}

monster.loot = {
	{id = 23839, chance = 5190, maxCount = 3},
	{id = 10606, chance = 2600},
	{id = 2148, chance = 100000, maxCount = 8},
	{id = 2643, chance = 5190},
	{id = 2666, chance = 24680},
	{id = 2170, chance = 1300},
	{id = 2389, chance = 25970},
	{id = 2448, chance = 10390},
	{id = 2484, chance = 9090},
	{id = 12471, chance = 5190},
	{id = 2512, chance = 11690}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 10, attack = 25}
}

monster.defenses = {
	defense = 4,
	armor = 6
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
