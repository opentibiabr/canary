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
	{ id = 3031, chance = 85662, maxCount = 30 }, -- Gold Coin
	{ id = 8010, chance = 7300, maxCount = 2 }, -- Potato
	{ id = 1781, chance = 46101, maxCount = 10 }, -- Small Stone
	{ id = 10278, chance = 11054 }, -- Stone Wing
	{ id = 3591, chance = 1806, maxCount = 5 }, -- Strawberry
	{ id = 3413, chance = 1306 }, -- Battle Shield
	{ id = 3282, chance = 1109 }, -- Morning Star
	{ id = 3012, chance = 493 }, -- Wolf Tooth Chain
	{ id = 3351, chance = 403 }, -- Steel Helmet
	{ id = 10426, chance = 490 }, -- Piece of Marble Rock
	{ id = 10310, chance = 242 }, -- Shiny Stone
	{ id = 3093, chance = 169 }, -- Club Ring
	{ id = 3383, chance = 233 }, -- Dark Armor
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
