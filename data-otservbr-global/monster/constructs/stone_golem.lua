local mType = Game.createMonsterType("Stone Golem")
local monster = {}

monster.description = "a stone golem"
monster.experience = 160
monster.outfit = {
	lookType = 67,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 67
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Maze of Lost Souls, in and around Ashta daramai, Formorgar Mines, \z
		Mad Technomancer room, Dark Cathedral, Demona, Goroma, Tarpit Tomb, Peninsula Tomb, \z
		Deeper Banuta, Forbidden Lands, Beregar Mines, Farmine Mines, Drillworm Caves, 2 caves on Hrodmir, \z
		Orc Fortress (single spawn) and Medusa Tower.",
}

monster.health = 270
monster.maxHealth = 270
monster.race = "undead"
monster.corpse = 6005
monster.speed = 90
monster.manaCost = 590

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = true,
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
	{ id = 3031, chance = 42136, maxCount = 40 }, -- Gold Coin
	{ id = 1781, chance = 32778, maxCount = 4 }, -- Small Stone
	{ id = 10315, chance = 10183 }, -- Sulphurous Stone
	{ id = 3050, chance = 4924 }, -- Power Ring
	{ id = 3283, chance = 1749 }, -- Carlin Sword
	{ id = 5880, chance = 1768 }, -- Iron Ore
	{ id = 9632, chance = 993 }, -- Ancient Stone
	{ id = 10310, chance = 656 }, -- Shiny Stone
	{ id = 12600, chance = 181 }, -- Coal
	{ id = 10426, chance = 489 }, -- Piece of Marble Rock
	{ id = 3007, chance = 260 }, -- Crystal Ring
	{ id = 3039, chance = 28 }, -- Red Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
}

monster.defenses = {
	defense = 20,
	armor = 30,
	mitigation = 0.64,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
