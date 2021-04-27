local mType = Game.createMonsterType("Souleater")
local monster = {}

monster.description = "a souleater"
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

monster.raceId = 675
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Razzachai, Northern Zao Plantations, Souleater Mountains, Deeper Banuta."
	}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "undead"
monster.corpse = 12631
monster.speed = 210
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
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
	{text = "Life is such a fickle thing!", yell = false},
	{text = "I will devour your soul.", yell = false},
	{text = "Souuuls!", yell = false},
	{text = "I will feed on you.", yell = false},
	{text = "Aaaahh", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 33400, maxCount = 100},
	{name = "gold coin", chance = 33400, maxCount = 100},
	{name = "platinum coin", chance = 49610, maxCount = 6},
	{name = "necrotic rod", chance = 980},
	{name = "wand of cosmic energy", chance = 910},
	{name = "spirit container", chance = 140},
	{id = 6300, chance = 300},
	{name = "great mana potion", chance = 8000},
	{name = "ultimate health potion", chance = 9400},
	{name = "souleater trophy", chance = 20},
	{name = "lizard essence", chance = 15250},
	{name = "ectoplasmic sushi", chance = 2000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -210},
	{name ="combat", interval = 2000, chance = 100, type = COMBAT_ICEDAMAGE, minDamage = -50, maxDamage = -100, range = 7, shootEffect = CONST_ANI_SMALLICE, target = true},
	{name ="souleater drown", interval = 2000, chance = 10, target = false},
	{name ="souleater wave", interval = 2000, chance = 10, minDamage = -100, maxDamage = -200, target = false},
	{name ="combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -30, maxDamage = -60, radius = 4, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="invisible", interval = 2000, chance = 5, effect = CONST_ME_MAGIC_BLUE},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 120, maxDamage = 125, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 70},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
