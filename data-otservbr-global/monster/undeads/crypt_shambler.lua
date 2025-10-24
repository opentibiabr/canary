local mType = Game.createMonsterType("Crypt Shambler")
local monster = {}

monster.description = "a crypt shambler"
monster.experience = 195
monster.outfit = {
	lookType = 100,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 100
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Ankrahmun Tombs, Trapwood, Ramoa, Hellgate, Helheim, Mount Sternum Undead Cave, Deeper Catacombs, \z
		Cemetery Quarter, Treasure Island, Upper Spike, Lion's Rock.",
}

monster.health = 330
monster.maxHealth = 330
monster.race = "undead"
monster.corpse = 6029
monster.speed = 70
monster.manaCost = 580

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
	{ text = "Aaaaahhhh!", yell = false },
	{ text = "Hoooohhh!", yell = false },
	{ text = "Uhhhhhhh!", yell = false },
	{ text = "Chhhhhhh!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 57423, maxCount = 55 }, -- Gold Coin
	{ id = 3492, chance = 41074, maxCount = 10 }, -- Worm
	{ id = 10283, chance = 4730 }, -- Half-Digested Piece of Meat
	{ id = 3115, chance = 16499 }, -- Bone
	{ id = 3353, chance = 1613 }, -- Iron Helmet
	{ id = 3265, chance = 2131 }, -- Two Handed Sword
	{ id = 3112, chance = 6777 }, -- Rotten Meat
	{ id = 3338, chance = 885 }, -- Bone Sword
	{ id = 3287, chance = 2094, maxCount = 3 }, -- Throwing Star
	{ id = 3441, chance = 1141 }, -- Bone Shield
	{ id = 3028, chance = 699 }, -- Small Diamond
	{ id = 3081, chance = 1000 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -140 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -28, maxDamage = -55, range = 1, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 30,
	mitigation = 0.64,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
