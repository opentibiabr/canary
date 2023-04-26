local mType = Game.createMonsterType("Shrieking Cry-Stal")
local monster = {}

monster.description = "a Shrieking Cry-Stal"
monster.experience = 13560
monster.outfit = {
	lookType = 1560,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0
}

monster.raceId = 2278
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 5000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 1,
	Locations = "Crystal Enigma."
}

monster.health = 20650
monster.maxHealth = 20650
monster.race = "blood"
monster.corpse = 39331
monster.speed = 207
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "La-la-la..AAAHHHH!!!", yell = false},
	{text = "SCREEECH...", yell = false},
}

monster.loot = {
	{name = "Crystal Coin", chance = 23440, minCount = 1, maxCount = 2},
	{name = "Great Spirit Potion", chance = 20760},
	{name = "Cry-Stal", chance = 12560, minCount = 1, maxCount = 2},
	{name = "Small Diamond", chance = 6020, minCount = 1, maxCount = 3},
	{name = "Rusted Armor", chance = 5580},
	{name = "Green Crystal Fragment", chance = 4290},
	{name = "Terra Boots", chance = 4290},
	{name = "Protection Amulet", chance = 2270},
	{name = "Violet Gem", chance = 1250},
	{name = "Gold Ring", chance = 600},
	{name = "Green Gem", chance = 420},
	{name = "Ring of the Sky", chance = 210},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 300, maxDamage = -801},
	{name ="combat", interval = 1000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -800, length = 7, spread = 0, effect = CONST_ME_PINK_ENERGY_SPARK, target = false},
	{name ="combat", interval = 3000, chance = 45, type = COMBAT_PHYSICALDAMAGE, minDamage = -1037, maxDamage = -1050, length = 6, spread = 1, effect = CONST_ME_SOUND_PURPLE, target = false},
}

monster.defenses = {
	defense = 110,
	armor = 120,
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = 10},
	{type = COMBAT_EARTHDAMAGE, percent = -5},
	{type = COMBAT_FIREDAMAGE, percent = 5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 5},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)