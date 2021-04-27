local mType = Game.createMonsterType("Draptor")
local monster = {}

monster.description = "a draptor"
monster.experience = 2400
monster.outfit = {
	lookType = 382,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 695
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 5,
	FirstUnlock = 2,
	SecondUnlock = 3,
	CharmsPoints = 50,
	Stars = 3,
	Occurrence = 3,
	Locations = "Zao, north east of Dragonblaze Peaks during raid. There are up to 10 draptors per raid, \z
		while 6 of them may also appear in mission 8 of Wrath of the Emperor Quest."
	}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "blood"
monster.corpse = 13316
monster.speed = 680
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 350,
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
	{text = "EEHEEHEEHEEH", yell = false},
	{text = "SCREEEEECH", yell = false},
	{text = "GRRR", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 33750, maxCount = 90},
	{name = "gold coin", chance = 33750, maxCount = 60},
	{name = "strong health potion", chance = 3150},
	{name = "strong mana potion", chance = 4150},
	{name = "dragon robe", chance = 950},
	{name = "draptor scales", chance = 6650}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150},
	{name ="combat", interval = 3000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -130, maxDamage = -310, radius = 3, effect = CONST_ME_YELLOWENERGY, target = false},
	{name ="combat", interval = 3000, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -300, range = 7, shootEffect = CONST_ANI_ENERGY, target = false},
	{name ="combat", interval = 2500, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -250, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false}
}

monster.defenses = {
	defense = 37,
	armor = 23,
	{name ="combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 57, maxDamage = 93, effect = CONST_ME_MAGIC_BLUE, target = false},
	{name ="speed", interval = 2000, chance = 12, speedChange = 457, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -10},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = -10},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
