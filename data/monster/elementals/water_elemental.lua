local mType = Game.createMonsterType("Water Elemental")
local monster = {}

monster.description = "a water elemental"
monster.experience = 650
monster.outfit = {
	lookType = 286,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 236
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Water Elemental Cave in Port Hope, Water Elemental Dungeon, Deeper Banuta, Malada, Ramoa, \z
		Talahu, Folda (7 spawn on the 3rd floor), Water Elemental Cave in Outlaw Camp (only during the Down the \z
		Drain Mini World Change), Krailos Steppe underwater cave."
	}

monster.health = 550
monster.maxHealth = 550
monster.race = "undead"
monster.corpse = 10499
monster.speed = 230
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{text = "Splish splash", yell = false}
}

monster.loot = {
	{name = "small diamond", chance = 1000},
	{name = "small sapphire", chance = 1000},
	{name = "gold coin", chance = 50000, maxCount = 100},
	{name = "small emerald", chance = 1000, maxCount = 2},
	{name = "platinum coin", chance = 10000},
	{name = "energy ring", chance = 950},
	{name = "life ring", chance = 930},
	{id = 2667, chance = 20000},
	{name = "rainbow trout", chance = 940},
	{name = "green perch", chance = 1050},
	{name = "strong health potion", chance = 10000},
	{name = "strong mana potion", chance = 10000},
	{id = 7632, chance = 800},
	{id = 7633, chance = 800}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -160, condition = {type = CONDITION_POISON, totalDamage = 60, interval = 4000}},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_DROWNDAMAGE, minDamage = -125, maxDamage = -235, range = 7, radius = 2, effect = CONST_ME_LOSEENERGY, target = true},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -88, maxDamage = -150, range = 7, shootEffect = CONST_ANI_SMALLICE, target = false},
	-- poison
	{name ="condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -225, maxDamage = -260, radius = 5, effect = CONST_ME_POISONAREA, target = false}
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 35},
	{type = COMBAT_ENERGYDAMAGE, percent = -25},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
