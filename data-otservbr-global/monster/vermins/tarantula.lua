local mType = Game.createMonsterType("Tarantula")
local monster = {}

monster.description = "a tarantula"
monster.experience = 120
monster.outfit = {
	lookType = 219,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 219
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Tiquanda Tarantula Caves, Spider Caves, Trapwood ground level and underground, \z
		in 2 small caves South of Thais, Dark Cathedral, single spawn on top of Crocodile den north of Port Hope, \z
		Plains of Havoc, underground Liberty Bay, Nargor Undead Cave and other constituents of the Shattered Isles, \z
		Green Claw Swamp, first floor up in the big building in the Cemetery Quarter, Robson Isle, Vengoth. \z
		After the summer update of 2876, tarantulas can be seen on the beginner's island of Rookgaard.",
}

monster.health = 225
monster.maxHealth = 225
monster.race = "venom"
monster.corpse = 6060
monster.speed = 107
monster.manaCost = 485

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = false,
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 78948, maxCount = 40 }, -- Gold Coin
	{ id = 10281, chance = 9693 }, -- Tarantula Egg
	{ id = 8031, chance = 4069 }, -- Spider Fangs
	{ id = 3372, chance = 2992 }, -- Brass Legs
	{ id = 3410, chance = 1934 }, -- Plate Shield
	{ id = 3351, chance = 1110 }, -- Steel Helmet
	{ id = 50258, chance = 400 }, -- Monk Robe
	{ id = 3053, chance = 159 }, -- Time Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90, condition = { type = CONDITION_POISON, totalDamage = 40, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, range = 1, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_CARNIPHILA, target = true },
}

monster.defenses = {
	defense = 10,
	armor = 20,
	mitigation = 0.51,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 220, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
