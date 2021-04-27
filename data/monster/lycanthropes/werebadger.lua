local mType = Game.createMonsterType("Werebadger")
local monster = {}

monster.description = "a werebadger"
monster.experience = 1600
monster.outfit = {
	lookType = 729,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1144
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Grimvale: -1 floor from ground level, also seen on surface during full moon (12th-14th of every month). \z
		Also in the were-beasts cave south-west of Edron and in the Last Sanctum."
	}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 24723
monster.speed = 260
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 275,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
	{text = "SNUFFLE", yell = false}
}

monster.loot = {
	{id = 2148, chance = 97000, maxCount = 242},
	{id = 2152, chance = 18200, maxCount = 5},
	{id = 8845, chance = 2000},
	{id = 2789, chance = 2000},
	{id = 7620, chance = 2210},
	{id = 7589, chance = 1200},
	{id = 2805, chance = 1900},
	{id = 24707, chance = 950},
	{id = 24711, chance = 780},
	{id = 24742, chance = 200},
	{id = 2171, chance = 160},
	{id = 2214, chance = 430},
	{id = 8910, chance = 220},
	{id = 8922, chance = 200},
	{id = 24739, chance = 150},
	{id = 24716, chance = 200},
	{id = 24757, chance = 100}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 50, attack = 60, condition = {type = CONDITION_POISON, totalDamage = 140, interval = 4000}},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -21, maxDamage = -150, range = 7, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_CARNIPHILA, target = true},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -10, maxDamage = -100, length = 8, spread = 3, effect = CONST_ME_CARNIPHILA, target = false},
	{name ="speed", interval = 4000, chance = 20, radius = 7, effect = CONST_ME_POFF, target = true}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
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
