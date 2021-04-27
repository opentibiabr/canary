local mType = Game.createMonsterType("Giant Spider")
local monster = {}

monster.description = "a giant spider"
monster.experience = 900
monster.outfit = {
	lookType = 38,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 38
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Plains of Havoc, Point of no Return in Outlaw Camp, Ghostlands, Hellgate, \z
		Mintwallin Secret Laboratory, Mad Mage Room deep below Ancient Temple, \z
		Mount Sternum Undead Cave, Green Claw Swamp, Maze of Lost Souls, \z
		Crusader Helmet Quest in the Dwarf Mines, Mushroom Gardens, \z
		west drillworm cave, Edron Hero Cave, Edron Orc Cave, \z
		on a hill near Drefia, on a hill north-west of Ankrahmun (inaccessible), \z
		Forbidden Lands, Deeper Banuta, Malada, Ramoa, Arena and Zoo Quarter, \z
		second floor up of Cemetery Quarter, beneath Fenrock, Vengoth Castle, \z
		Vandura Mountain, in a cave in Robson Isle, Chyllfroest, Spider Caves, \z
		Second floor of Krailos Spider Lair , Caverna Exanima."
	}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "venom"
monster.corpse = 5977
monster.speed = 240
monster.manaCost = 0
monster.maxSummons = 2

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
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
	staticAttackChance = 70,
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

monster.summons = {
	{name = "Poison Spider", chance = 10, interval = 2000, max = 2}
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{name = "gold coin", chance = 99990, maxCount = 100},
	{name = "gold coin", chance = 99990, maxCount = 95},
	{id = 2169, chance = 710},
	{name = "platinum amulet", chance = 280},
	{name = "two handed sword", chance = 5100},
	{name = "steel helmet", chance = 4980},
	{name = "plate armor", chance = 9980},
	{name = "knight armor", chance = 500},
	{name = "knight legs", chance = 840},
	{name = "poison arrow", chance = 11950, maxCount = 12},
	{name = "plate legs", chance = 8333},
	{name = "spider silk", chance = 1990},
	{name = "strong health potion", chance = 3550},
	{name = "lightning headband", chance = 270}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, condition = {type = CONDITION_POISON, totalDamage = 160, interval = 4000}},
	{name ="poisonfield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -40, maxDamage = -70, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true}
}

monster.defenses = {
	defense = 0,
	armor = 30,
	{name ="speed", interval = 2000, chance = 15, speedChange = 390, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 20},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 20},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
