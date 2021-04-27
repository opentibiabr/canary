local mType = Game.createMonsterType("Knowledge Elemental")
local monster = {}

monster.description = "a knowledge elemental"
monster.experience = 10603
monster.outfit = {
	lookType = 1065,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1670
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Secret Library."
	}

monster.health = 10500
monster.maxHealth = 10500
monster.race = "undead"
monster.corpse = 33349
monster.speed = 460
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	staticAttackChance = 90,
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
	{name = "Platinum Coin", chance = 100000, maxCount = 9},
	{name = "Book Page", chance = 10000, maxCount = 6},
	{name = "Small Amethyst", chance = 10000, maxCount = 8},
	{name = "Glowing Rune", chance = 10000, maxCount = 3},
	{name = "Quill", chance = 10000, maxCount = 3},
	{name = "Silken Bookmark", chance = 10000, maxCount = 3},
	{name = "Flash Arrow", chance = 10000, maxCount = 6},
	{name = "Throwing Star", chance = 10000, maxCount = 10},
	{name = "Crystal Sword", chance = 10000},
	{name = "Energy Ring", chance = 10000},
	{name = "Guardian Shield", chance = 10000},
	{name = "Mana Potion", chance = 10000, maxCount = 10},
	{name = "Ultimate Mana Potion", chance = 10000, maxCount = 8},
	{name = "Ultimate Health Potion", chance = 10000, maxCount = 8},
	{name = "Wand of Cosmic Energy", chance = 300}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -400},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -200, maxDamage = -680, radius = 3, effect = CONST_ME_HOLYDAMAGE, target = true},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -680, range = 7, shootEffect = CONST_ANI_ENERGY, target = false}
}

monster.defenses = {
	defense = 33,
	armor = 76,
	{name ="combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = 100, maxDamage = 300, radius = 3, effect = CONST_ME_BLOCKHIT, target = false},
	{name ="combat", interval = 200, chance = 55, type = COMBAT_PHYSICALDAMAGE, minDamage = 100, maxDamage = 300, radius = 3, effect = CONST_ME_ENERGYHIT, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 10},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 10},
	{type = COMBAT_HOLYDAMAGE , percent = 50},
	{type = COMBAT_DEATHDAMAGE , percent = -10}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
