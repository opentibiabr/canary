local mType = Game.createMonsterType("Drillworm")
local monster = {}

monster.description = "a drillworm"
monster.experience = 1200
monster.outfit = {
	lookType = 527,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"LowerSpikeDeath",
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
	Locations = "Drillworm Caves, Lower Spike, Lost Dwarf version of the Forsaken Mine, Oramond Factory Raids and Warzone 4.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "venom"
monster.corpse = 17425
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Krrrk!", yell = false },
	{ text = "Knarrrk!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 150 }, -- Gold Coin
	{ id = 10305, chance = 15030 }, -- Lump of Earth
	{ id = 12600, chance = 12190 }, -- Coal
	{ id = 16122, chance = 10050 }, -- Green Crystal Splinter
	{ id = 16123, chance = 10090 }, -- Brown Crystal Splinter
	{ id = 16124, chance = 9960 }, -- Blue Crystal Splinter
	{ id = 16135, chance = 7339 }, -- Vein of Ore
	{ id = 814, chance = 2570 }, -- Terra Amulet
	{ id = 3097, chance = 2430 }, -- Dwarven Ring
	{ id = 3456, chance = 5040 }, -- Pick
	{ id = 3492, chance = 5020, maxCount = 5 }, -- Worm
	{ id = 5880, chance = 1520 }, -- Iron Ore
	{ id = 16133, chance = 5150 }, -- Pulverized Ore
	{ id = 16142, chance = 5010, maxCount = 2 }, -- Drill Bolt
	{ id = 7452, chance = 520 }, -- Spiked Squelcher
	{ id = 10422, chance = 750 }, -- Clay Lump
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, condition = { type = CONDITION_POISON, totalDamage = 100, interval = 4000 } },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -150, radius = 3, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 41,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 16 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
