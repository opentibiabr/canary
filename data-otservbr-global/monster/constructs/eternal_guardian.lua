local mType = Game.createMonsterType("Eternal Guardian")
local monster = {}

monster.description = "an eternal guardian"
monster.experience = 1800
monster.outfit = {
	lookType = 345,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 615
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "North-east Muggy Plains, Deeper Banuta.",
}

monster.health = 2500
monster.maxHealth = 2500
monster.race = "undead"
monster.corpse = 10383
monster.speed = 102
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canWalkOnEnergy = false,
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
	{ text = "Zzrrkrrch!", yell = false },
	{ text = "<crackle>", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 90560, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 99750, maxCount = 4 }, -- Platinum Coin
	{ id = 1781, chance = 30502, maxCount = 10 }, -- Small Stone
	{ id = 9632, chance = 9480 }, -- Ancient Stone
	{ id = 10408, chance = 10030 }, -- Spiked Iron Ball
	{ id = 5880, chance = 1649 }, -- Iron Ore
	{ id = 10406, chance = 1980 }, -- Zaoan Halberd
	{ id = 10422, chance = 657 }, -- Clay Lump
	{ id = 3315, chance = 600 }, -- Guardian Halberd
	{ id = 10310, chance = 874 }, -- Shiny Stone
	{ id = 3428, chance = 769 }, -- Tower Shield
	{ id = 12600, chance = 474 }, -- Coal
	{ id = 10426, chance = 790 }, -- Piece of Marble Rock
	{ id = 10390, chance = 110 }, -- Zaoan Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
}

monster.defenses = {
	defense = 40,
	armor = 62,
	mitigation = 1.18,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
