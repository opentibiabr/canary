local mType = Game.createMonsterType("Brain Squid")
local monster = {}

monster.description = "a brain squid"
monster.experience = 17672
monster.outfit = {
	lookType = 1059,
	lookHead = 97,
	lookBody = 18,
	lookLegs = 61,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1653
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
monster.race = "undead"
monster.corpse = 33329
monster.speed = 430
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
	{name = "Violet Crystal Shard", chance = 900, maxCount = 4},
	{name = "Platinum Coin", chance = 100000, maxCount = 12},
	{name = "Glowing Rune", chance = 900, maxCount = 4},
	{name = "Instable Proto Matter", chance = 1200, maxCount = 4},
	{name = "Energy Ball", chance = 1200, maxCount = 4},
	{name = "Energy Bar", chance = 1200, maxCount = 4},
	{name = "Energy Drink", chance = 1200, maxCount = 4},
	{name = "Odd Organ", chance = 1200, maxCount = 4},
	{name = "Frozen Lightning", chance = 1200, maxCount = 4},
	{id = 33315, chance = 1200, maxCount = 3},
	{name = "Small Ruby", chance = 1200, maxCount = 4},
	{name = "Violet Gem", chance = 1200, maxCount = 4},
	{name = "Blue Crystal Splinter", chance = 1200, maxCount = 4},
	{name = "Cyan Crystal Fragment", chance = 1200, maxCount = 4},
	{name = "Ultimate Mana Potion", chance = 1200, maxCount = 4},
	{name = "Piece of Dead Brain", chance = 1200, maxCount = 4},
	{name = "Wand of Defiance", chance = 800},
	{name = "Lightning Headband", chance = 950},
	{name = "Lightning Pendant", chance = 850},
	{name = "Might Ring", chance = 1300},
	{name = "Slime Heart", chance = 1200, maxCount = 4},
	{id = 26200, chance = 560},
	{id = 26198, chance = 560},-- collar of blue plasma
	{id = 26199, chance = 560},
	{id = 26189, chance = 560},
	{id = 26185, chance = 560},
	{id = 26187, chance = 560}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -470, range = 7, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -505, radius = 3, effect = CONST_ME_ENERGYAREA, target = false}
}

monster.defenses = {
	defense = 40,
	armor = 82
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 90},
	{type = COMBAT_EARTHDAMAGE, percent = 30},
	{type = COMBAT_FIREDAMAGE, percent = 50},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = 70},
	{type = COMBAT_DEATHDAMAGE , percent = 50}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
