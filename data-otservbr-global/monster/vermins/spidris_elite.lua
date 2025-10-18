local mType = Game.createMonsterType("Spidris Elite")
local monster = {}

monster.description = "a spidris elite"
monster.experience = 4000
monster.outfit = {
	lookType = 457,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 797
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "The Hive: east tower (beyond gates), west tower (including beyond gates), \z
		also anywhere Hive Overseers are found (as summons), Hive Outpost.",
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "venom"
monster.corpse = 13870
monster.speed = 197
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
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
	{ id = 3031, chance = 96430, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 43170, maxCount = 6 }, -- Platinum Coin
	{ id = 14082, chance = 29090 }, -- Spidris Mandible
	{ id = 14083, chance = 13600 }, -- Compound Eye
	{ id = 238, chance = 21480 }, -- Great Mana Potion
	{ id = 3030, chance = 23550, maxCount = 5 }, -- Small Ruby
	{ id = 7643, chance = 11340 }, -- Ultimate Health Potion
	{ id = 6299, chance = 4590 }, -- Death Ring
	{ id = 281, chance = 2930 }, -- Giant Shimmering Pearl (Green)
	{ id = 14086, chance = 1410 }, -- Calopteryx Cape
	{ id = 14089, chance = 1330 }, -- Hive Scythe
	{ id = 7413, chance = 1160 }, -- Titan Axe
	{ id = 3036, chance = 1100 }, -- Violet Gem
	{ id = 14088, chance = 980 }, -- Carapace Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -349 },
}

monster.defenses = {
	defense = 30,
	armor = 55,
	mitigation = 1.74,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -3 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
