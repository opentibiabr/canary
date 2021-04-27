local mType = Game.createMonsterType("Banshee")
local monster = {}

monster.description = "a banshee"
monster.experience = 900
monster.outfit = {
	lookType = 78,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 78
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Single one under the White Flower Temple in Thais (respawn takes about 20-25 minutes), \z
		Banshee Quest area in Ghostlands (also accesible by Isle of the Kings), Demon Quest Room, Drefia, \z
		Ancient Ruins Tomb, Desert Dungeon (unreachable), Pits of Inferno in Tafariel's Throne room, \z
		Cemetery Quarter in Yalahar, Vengoth Castle, one in Robson Isle."
	}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "undead"
monster.corpse = 6019
monster.speed = 220
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	runHealth = 500,
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
	{text = "Dance for me your dance of death!", yell = false},
	{text = "Let the music play!", yell = false},
	{text = "I will mourn your death!", yell = false},
	{text = "Are you ready to rock?", yell = false},
	{text = "Feel my gentle kiss of death.", yell = false},
	{text = "That's what I call easy listening!", yell = false},
	{text = "IIIIEEEeeeeeehhhHHHH!", yell = true}
}

monster.loot = {
	{name = "candlestick", chance = 70000},
	{name = "wedding ring", chance = 460},
	{id = 2124, chance = 60},
	{name = "silver brooch", chance = 1250},
	{name = "white pearl", chance = 1010},
	{name = "black pearl", chance = 2030},
	{name = "gold coin", chance = 30000, maxCount = 80},
	{name = "silver amulet", chance = 8700},
	{id = 2175, chance = 520},
	{name = "life crystal", chance = 70},
	{name = "stone skin amulet", chance = 820},
	{name = "ring of healing", chance = 730},
	{id = 2372, chance = 910},
	{name = "poison dagger", chance = 1350},
	{name = "red robe", chance = 150},
	{name = "blue robe", chance = 700},
	{name = "simple dress", chance = 6050},
	{name = "strong mana potion", chance = 680},
	{name = "terra mantle", chance = 340},
	{name = "petrified scream", chance = 4150},
	{name = "hair of a banshee", chance = 4810},
	{name = "sweet smelling bait", chance = 40}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100, condition = {type = CONDITION_POISON, totalDamage = 3, interval = 4000}},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -200, radius = 4, effect = CONST_ME_SOUND_RED, target = false},
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -55, maxDamage = -350, range = 1, radius = 1, effect = CONST_ME_SMALLCLOUDS, target = true},
	{name ="speed", interval = 2000, chance = 10, speedChange = -300, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000}
}

monster.defenses = {
	defense = 25,
	armor = 25,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 120, maxDamage = 190, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
