local mType = Game.createMonsterType("Ghoul")
local monster = {}

monster.description = "a ghoul"
monster.experience = 85
monster.outfit = {
	lookType = 18,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 18
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Ancient Temple in the Skeleton area, way to Mintwallin, Old Mintwallin Quest, \z
		Alatar Lake, Magician Tower, Mount Sternum Undead Cave, Ghostlands, Hellgate, \z
		Maze of Lost Souls, below Point of No Return in Outlaw Camp, Plains of Havoc in Necromant House, \z
		Drefia and Drefia's underground caves, Edron ghoul hill, Venore Amazon Camp underground, \z
		Venore Swamp Troll cave, Ghostship between Venore and Darashia, Triangle Tower, Dark Cathedral, \z
		Ankrahmun tombs, Isle of the Kings, Treasure Island, Nargor Undead Cave, Helheim, Lion's Rock, \z
		The Witches' Cliff (only accessible during a quest) and a cave northeast of Ab'Dendriel. \z
		Also found behind a wall in both Rookgaard and Paradox Tower, although they cannot be reached."
	}

monster.health = 100
monster.maxHealth = 100
monster.race = "blood"
monster.corpse = 5976
monster.speed = 144
monster.manaCost = 450
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
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
}

monster.loot = {
	{id = 2050, chance = 5000},
	{name = "gold coin", chance = 68000, maxCount = 30},
	{name = "life ring", chance = 180},
	{id = 2229, chance = 240},
	{name = "viking helmet", chance = 990},
	{name = "scale armor", chance = 1000},
	{name = "worm", chance = 9600, maxCount = 2},
	{name = "brown piece of cloth", chance = 1000},
	{name = "rotten piece of cloth", chance = 14470},
	{name = "ghoul snack", chance = 5130},
	{name = "pile of grave earth", chance = 950},
	{id = 26654, chance = 1000}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -70},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -15, maxDamage = -27, range = 1, radius = 1, effect = CONST_ME_SMALLCLOUDS, target = true}
}

monster.defenses = {
	defense = 15,
	armor = 15,
	{name ="combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 9, maxDamage = 15, effect = CONST_ME_MAGIC_BLUE, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 30},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 10},
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
