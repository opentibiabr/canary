local mType = Game.createMonsterType("Lizard Chosen")
local monster = {}

monster.description = "a lizard chosen"
monster.experience = 2200
monster.outfit = {
	lookType = 344,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 620
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Temple of Equilibrium (Zao) Hidden stairs, Fire Dragon Dojo, Corruption Hole, Razzachai."
	}

monster.health = 3050
monster.maxHealth = 3050
monster.race = "blood"
monster.corpse = 11288
monster.speed = 272
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 50,
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
	{text = "Grzzzzzzz!", yell = false},
	{text = "Garrrblarrrrzzzz!", yell = false},
	{text = "Kzzzzzzz!", yell = false}
}

monster.loot = {
	{name = "small diamond", chance = 2550, maxCount = 5},
	{name = "gold coin", chance = 33000, maxCount = 100},
	{name = "gold coin", chance = 32000, maxCount = 100},
	{name = "gold coin", chance = 32000, maxCount = 36},
	{name = "platinum coin", chance = 2920, maxCount = 5},
	{name = "tower shield", chance = 1100},
	{name = "lizard leather", chance = 2000},
	{name = "lizard scale", chance = 980, maxCount = 3},
	{name = "great health potion", chance = 5350, maxCount = 3},
	{name = "Zaoan armor", chance = 980},
	{name = "Zaoan helmet", chance = 140},
	{name = "Zaoan shoes", chance = 810},
	{name = "Zaoan legs", chance = 940},
	{name = "spiked iron ball", chance = 9890},
	{name = "corrupted flag", chance = 3350},
	{name = "cursed shoulder spikes", chance = 5800},
	{name = "scale of corruption", chance = 2870}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -360},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -240, maxDamage = -320, length = 3, spread = 2, effect = CONST_ME_POISONAREA, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -190, maxDamage = -340, radius = 3, effect = CONST_ME_HITBYPOISON, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -90, maxDamage = -180, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 28,
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 75, maxDamage = 125, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
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
