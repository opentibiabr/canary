local mType = Game.createMonsterType("Drillworm")
local monster = {}

monster.description = "a drillworm"
monster.experience = 858
monster.outfit = {
	lookType = 527,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 878
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Drillworm Caves, Lower Spike and in the Lost Dwarf version of the Forsaken Mine."
	}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "venom"
monster.corpse = 19705
monster.speed = 220
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20
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
	{text = "Knarrrk!", yell = false},
	{text = "Krrrk!", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 50000, maxCount = 100},
	{name = "gold coin", chance = 50000, maxCount = 50},
	{id = 2553, chance = 5280},
	{name = "worm", chance = 4580, maxCount = 5},
	{name = "iron ore", chance = 1750},
	{name = "spiked squelcher", chance = 540},
	{name = "terra amulet", chance = 2360},
	{name = "lump of earth", chance = 15000},
	{name = "clay lump", chance = 700},
	{id = 13757, chance = 12130},
	{name = "green crystal splinter", chance = 9780},
	{name = "brown crystal splinter", chance = 9260},
	{name = "blue crystal splinter", chance = 9610},
	{name = "pulverized ore", chance = 5400},
	{name = "vein of ore", chance = 7280},
	{name = "drill bolt", chance = 4870, maxCount = 2}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, condition = {type = CONDITION_POISON, totalDamage = 100, interval = 4000}},
	{name ="speed", interval = 2000, chance = 15, speedChange = -600, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_HITBYPOISON, target = false},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -150, radius = 3, effect = CONST_ME_POISONAREA, target = true}
}

monster.defenses = {
	defense = 35,
	armor = 35
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 15},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 16},
	{type = COMBAT_HOLYDAMAGE , percent = 25},
	{type = COMBAT_DEATHDAMAGE , percent = 15}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
