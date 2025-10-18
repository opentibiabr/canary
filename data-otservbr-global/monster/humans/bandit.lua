local mType = Game.createMonsterType("Bandit")
local monster = {}

monster.description = "a bandit"
monster.experience = 65
monster.outfit = {
	lookType = 129,
	lookHead = 58,
	lookBody = 40,
	lookLegs = 24,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 223
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Dark Cathedral, Tiquanda Bandit Caves, Outlaw Camp, mountain pass west of Ankrahmun, \z
		Tyrsung, Thais Bandit Cave, Formorgar Mines. Also summoned by Gamel.",
}

monster.health = 245
monster.maxHealth = 245
monster.race = "blood"
monster.corpse = 18050
monster.speed = 90
monster.manaCost = 450

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 25,
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
	{ text = "Hand me your purse!", yell = false },
	{ text = "Your money or your life!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 49220, maxCount = 30 }, -- Gold Coin
	{ id = 3274, chance = 30672 }, -- Axe
	{ id = 3286, chance = 9502 }, -- Mace
	{ id = 3411, chance = 18468 }, -- Brass Shield
	{ id = 3559, chance = 17302 }, -- Leather Legs
	{ id = 3596, chance = 12988, maxCount = 2 }, -- Tomato
	{ id = 3352, chance = 5747 }, -- Chain Helmet
	{ id = 3359, chance = 3002 }, -- Brass Armor
	{ id = 3353, chance = 347 }, -- Iron Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -45 },
}

monster.defenses = {
	defense = 15,
	armor = 11,
	mitigation = 0.43,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
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
