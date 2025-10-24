local mType = Game.createMonsterType("Gang Member")
local monster = {}

monster.description = "a gang member"
monster.experience = 70
monster.outfit = {
	lookType = 151,
	lookHead = 114,
	lookBody = 19,
	lookLegs = 23,
	lookFeet = 40,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 526
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Throughout the Foreigner, Factory, and Trade Quarters in Yalahar.",
}

monster.health = 295
monster.maxHealth = 295
monster.race = "blood"
monster.corpse = 18122
monster.speed = 95
monster.manaCost = 450

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
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 35,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "This is our territory!", yell = false },
	{ text = "Help me guys!", yell = false },
	{ text = "I don't like the way you look!", yell = false },
	{ text = "You're wearing the wrong colours!", yell = false },
	{ text = "Don't mess with us!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 48850, maxCount = 30 }, -- Gold Coin
	{ id = 3559, chance = 14689 }, -- Leather Legs
	{ id = 3286, chance = 9482 }, -- Mace
	{ id = 3362, chance = 4856 }, -- Studded Legs
	{ id = 3602, chance = 4961 }, -- Brown Bread
	{ id = 3093, chance = 859 }, -- Club Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -70 },
}

monster.defenses = {
	defense = 15,
	armor = 8,
	mitigation = 0.38,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
