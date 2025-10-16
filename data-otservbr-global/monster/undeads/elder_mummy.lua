local mType = Game.createMonsterType("Elder Mummy")
local monster = {}

monster.description = "an elder mummy"
monster.experience = 560
monster.outfit = {
	lookType = 65,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 711
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Horestis Tomb.",
}

monster.health = 850
monster.maxHealth = 850
monster.race = "undead"
monster.corpse = 6004
monster.speed = 85
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	isPreyExclusive = true,
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
	{ id = 3031, chance = 80000, maxCount = 160 }, -- gold coin
	{ id = 3042, chance = 23000, maxCount = 3 }, -- scarab coin
	{ id = 3047, chance = 23000 }, -- magic light wand
	{ id = 3492, chance = 23000, maxCount = 3 }, -- worm
	{ id = 9649, chance = 23000 }, -- gauze bandage
	{ id = 11466, chance = 23000 }, -- flask of embalming fluid
	{ id = 6093, chance = 5000 }, -- crystal ring
	{ id = 3017, chance = 5000 }, -- silver brooch
	{ id = 3045, chance = 5000 }, -- strange talisman
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 12483, chance = 5000 }, -- pharaoh banner
	{ id = 3027, chance = 1000 }, -- black pearl
	{ id = 3299, chance = 1000 }, -- poison dagger
	{ id = 10290, chance = 260 }, -- mini mummy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120, condition = { type = CONDITION_POISON, totalDamage = 3, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -130, range = 1, effect = CONST_ME_MORTAREA, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -300, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 30,
	armor = 35,
	mitigation = 0.67,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
