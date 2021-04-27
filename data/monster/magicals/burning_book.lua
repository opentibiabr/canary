local mType = Game.createMonsterType("Burning Book")
local monster = {}

monster.description = "a burning book"
monster.experience = 11934
monster.outfit = {
	lookType = 1061,
	lookHead = 79,
	lookBody = 113,
	lookLegs = 78,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1663
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library."
	}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "fire"
monster.corpse = 32454
monster.speed = 440
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
}

monster.loot = {
	{name = "Platinum Coin", chance = 89960, maxCount = 28},
	{name = "Book Page", chance = 3000, maxCount = 7},
	{name = "Demonic Essence", chance = 3000, maxCount = 5},
	{name = "Concentrated Demonic Blood", chance = 3000, maxCount = 3},
	{name = "Small Amethyst", chance = 2000, maxCount = 4},
	{id = 2419, chance = 3000},
	{name = "Silken Bookmark", chance = 2000, maxCount = 2},
	{name = "Magma Coat", chance = 2000},
	{name = "Guardian Shield", chance = 1500},
	{name = "Soul Orb", chance = 3000, maxCount = 4},
	{name = "Necrotic Rod", chance = 3000},
	{name = "Magma Monocle", chance = 1500},
	{id = 6300, chance = 1200},
	{name = "Stealth Ring", chance = 1800},
	{name = "Shadow Sceptre", chance = 8990}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -700},
	{name ="combat", interval = 1000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -780, range = 7, shootEffect = CONST_ANI_FLAMMINGARROW, effect = CONST_ME_HITBYFIRE, target = false},
	{name ="combat", interval = 1500, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -900, radius = 3, effect = CONST_ME_EXPLOSIONAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -850, length = 5, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -400, maxDamage = -775, radius = 3, effect = CONST_ME_HITBYFIRE, target = false}
}

monster.defenses = {
	defense = 33,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -10},
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
