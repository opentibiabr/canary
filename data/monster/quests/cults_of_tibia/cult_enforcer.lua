local mType = Game.createMonsterType("Cult Enforcer")
local monster = {}

monster.description = "a cult enforcer"
monster.experience = 1000
monster.outfit = {
	lookType = 134,
	lookHead = 114,
	lookBody = 19,
	lookLegs = 76,
	lookFeet = 76,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 1513
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Forbidden Temple (Carlin)."
	}

monster.health = 1150
monster.maxHealth = 1150
monster.race = "blood"
monster.corpse = 24673
monster.speed = 260
monster.manaCost = 390
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20
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
	staticAttackChance = 90,
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
	{text = "No one will stop us!", yell = false}
}

monster.loot = {
	{id = 2543, chance = 90450, maxCount = 10},
	{id = 2148, chance = 75410, maxCount = 30},
	{id = 2681, chance = 15400},
	{id = 7591, chance = 12340, maxCount = 2},
	{id = 2666, chance = 5000},
	{id = 2455, chance = 830},
	{id = 2652, chance = 760},
	{id = 2164, chance = 700, maxCount = 2},
	{id = 2120, chance = 1000},
	{id = 2661, chance = 1000},
	{id = 1949, chance = 830},
	{id = 2145, chance = 830},
	{id = 2391, chance = 130},
	{id = 2381, chance = 830},
	{id = 2515, chance = 330},
	{id = 2477, chance = 230},
	{id = 2475, chance = 200}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -360}
}

monster.defenses = {
	defense = 50,
	armor = 35,
	{name ="combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false}
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
	{type = COMBAT_HOLYDAMAGE , percent = -20},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
