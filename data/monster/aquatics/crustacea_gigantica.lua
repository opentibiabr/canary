local mType = Game.createMonsterType("Crustacea Gigantica")
local monster = {}

monster.description = "a crustacea gigantica"
monster.experience = 1800
monster.outfit = {
	lookType = 383,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 697
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 3,
	Locations = "Calassa, Treasure Island , Seacrest Grounds. \z
		In the Seacrest Grounds the spawns are Varying Monster Spawns in which the common creature is an Abyssal Calamary. \z
		The chance to spawn a Crustacea Gigantica seems to be around 1%-2%."
	}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "blood"
monster.corpse = 13331
monster.speed = 480
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
	{text = "Chrchrchr", yell = true},
	{text = "Klonklonk", yell = true},
	{text = "Chrrrrr", yell = true},
	{text = "Crunch crunch", yell = true}
}

monster.loot = {
	{name = "gold coin", chance = 96000, maxCount = 100},
	{name = "gold coin", chance = 56000, maxCount = 75},
	{name = "strong mana potion", chance = 8885},
	{name = "strong health potion", chance = 3880},
	{name = "giant crab pincer", chance = 5000, maxCount = 2},
	{name = "ring of healing", chance = 3000},
	{name = "great mana potion", chance = 1220},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600, effect = CONST_ME_DRAWBLOOD}
}

monster.defenses = {
	defense = 45,
	armor = 40
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 10}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
