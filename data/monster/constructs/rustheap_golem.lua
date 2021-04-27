local mType = Game.createMonsterType("Rustheap Golem")
local monster = {}

monster.description = "a rustheap golem"
monster.experience = 2100
monster.outfit = {
	lookType = 603,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1041
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Workshop Quarter, Glooth Factory, Underground Glooth Factory, \z
		Oramond Dungeon (depending on Magistrate votes), Jaccus Maxxens Dungeon."
	}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "venom"
monster.corpse = 23355
monster.speed = 250
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
	{text = "*clatter*", yell = false},
	{text = "*krrk*", yell = false},
	{text = "*frzzp*", yell = false}
}

monster.loot = {
	{id = 8309, chance = 1950},
	{id = 9930, chance = 5860},
	{id = 23567, chance = 14980},
	{id = 2148, chance = 100000, maxCount = 290},
	{id = 5880, chance = 330},
	{id = 24124, chance = 1950},
	{id = 2152, chance = 58310, maxCount = 3},
	{id = 2143, chance = 1300},
	{id = 2144, chance = 1630},
	{id = 7588, chance = 10100, maxCount = 2},
	{id = 7589, chance = 7170, maxCount = 2},
	{id = 2391, chance = 3580},
	{id = 7452, chance = 330},
	{id = 23542, chance = 330},
	{id = 23541, chance = 2930},
	{id = 9810, chance = 5860},
	{id = 9813, chance = 4230}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 118, attack = 50},
	{name ="rustheap golem electrify", interval = 2000, chance = 11, range = 7, target = false},
	{name ="frazzlemaw paralyze", interval = 2000, chance = 10, target = false},
	{name ="rustheap golem wave", interval = 2000, chance = 9, minDamage = -100, maxDamage = -210, target = false}
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{name ="speed", interval = 2000, chance = 11, speedChange = 428, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 6000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = -5},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 70},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
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
