local mType = Game.createMonsterType("Enlightened of the Cult")
local monster = {}

monster.description = "an enlightened of the cult"
monster.experience = 500
monster.outfit = {
	lookType = 193,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 252
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Goroma, Formorgar Mines, Magician Quarter, Forbidden Temple.",
}

monster.health = 700
monster.maxHealth = 700
monster.race = "blood"
monster.corpse = 18110
monster.speed = 100
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
	staticAttackChance = 50,
	targetDistance = 4,
	runHealth = 0,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Crypt Shambler", chance = 10, interval = 2000, count = 1 },
		{ name = "Ghost", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Praise to my master Urgith!", yell = false },
	{ text = "You will rise as my servant!", yell = false },
	{ text = "Praise to my masters! Long live the triangle!", yell = false },
	{ text = "You will die in the name of the triangle!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 65000, maxCount = 92 }, -- Gold Coin
	{ id = 9638, chance = 10400 }, -- Cultish Mask
	{ id = 11455, chance = 1000 }, -- Cultish Symbol
	{ id = 237, chance = 880 }, -- Strong Mana Potion
	{ id = 3084, chance = 870 }, -- Protection Amulet
	{ id = 2828, chance = 780 }, -- Book (Orange)
	{ id = 6090, chance = 550 }, -- Music Sheet (Fourth Verse)
	{ id = 3029, chance = 510 }, -- Small Sapphire
	{ id = 5810, chance = 450 }, -- Pirate Voodoo Doll
	{ id = 3051, chance = 420 }, -- Energy Ring
	{ id = 3324, chance = 340 }, -- Skull Staff
	{ id = 3055, chance = 200 }, -- Platinum Amulet
	{ id = 3071, chance = 150 }, -- Wand of Inferno
	{ id = 5801, chance = 130 }, -- Jewelled Backpack
	{ id = 11652, chance = 130 }, -- Broken Key Ring
	{ id = 2995, chance = 120 }, -- Piggy Bank
	{ id = 7426, chance = 100 }, -- Amber Staff
	{ id = 3567, chance = 93 }, -- Blue Robe
	{ id = 5668, chance = 75 }, -- Mysterious Voodoo Skull
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100, condition = { type = CONDITION_POISON, totalDamage = 4, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -70, maxDamage = -185, range = 1, radius = 1, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true, duration = 5000 },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -360, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 6000 },
}

monster.defenses = {
	defense = 25,
	armor = 40,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 60, maxDamage = 90, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_YELLOW_RINGS },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
