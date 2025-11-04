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
	{ id = 3031, chance = 89231, maxCount = 160 }, -- Gold Coin
	{ id = 3042, chance = 10343, maxCount = 3 }, -- Scarab Coin
	{ id = 3046, chance = 7301 }, -- Magic Light Wand
	{ id = 3492, chance = 19765, maxCount = 3 }, -- Worm
	{ id = 9649, chance = 8390 }, -- Gauze Bandage
	{ id = 11466, chance = 10455 }, -- Flask of Embalming Fluid
	{ id = 3007, chance = 2314 }, -- Crystal Ring
	{ id = 3017, chance = 3453 }, -- Silver Brooch
	{ id = 3045, chance = 5374 }, -- Strange Talisman
	{ id = 3081, chance = 760 }, -- Stone Skin Amulet
	{ id = 12483, chance = 3364 }, -- Pharaoh Banner
	{ id = 3027, chance = 961 }, -- Black Pearl
	{ id = 3299, chance = 645 }, -- Poison Dagger
	{ id = 10290, chance = 1000 }, -- Mini Mummy
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
