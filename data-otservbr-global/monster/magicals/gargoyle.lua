local mType = Game.createMonsterType("Gargoyle")
local monster = {}

monster.description = "a gargoyle"
monster.experience = 150
monster.outfit = {
	lookType = 95,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 95
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Meriana Gargoyle Cave, Ankrahmun Tombs, Mal'ouquah, Goroma, Deeper Banuta, \z
		Formorgar Mines, Vengoth, Farmine Mines, Upper Spike and Medusa Tower.",
}

monster.health = 250
monster.maxHealth = 250
monster.race = "undead"
monster.corpse = 6027
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 30,
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
	{ text = "Feel my claws, softskin.", yell = false },
	{ text = "There is a stone in your shoe!", yell = false },
	{ text = "Stone sweet stone.", yell = false },
	{ text = "Harrrr harrrr!", yell = false },
	{ text = "Chhhhhrrrrk!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 30 }, -- gold coin
	{ id = 8010, chance = 23000, maxCount = 2 }, -- potato
	{ id = 1781, chance = 23000, maxCount = 10 }, -- small stone
	{ id = 10278, chance = 23000 }, -- stone wing
	{ id = 3591, chance = 5000, maxCount = 5 }, -- strawberry
	{ id = 3413, chance = 5000 }, -- battle shield
	{ id = 3282, chance = 5000 }, -- morning star
	{ id = 5940, chance = 1000 }, -- wolf tooth chain
	{ id = 3351, chance = 1000 }, -- steel helmet
	{ id = 10426, chance = 1000 }, -- piece of marble rock
	{ id = 10310, chance = 260 }, -- shiny stone
	{ id = 3093, chance = 260 }, -- club ring
	{ id = 3383, chance = 260 }, -- dark armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -65 },
}

monster.defenses = {
	defense = 25,
	armor = 26,
	mitigation = 0.78,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 5, maxDamage = 15, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
