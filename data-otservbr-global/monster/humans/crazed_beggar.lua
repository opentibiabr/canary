local mType = Game.createMonsterType("Crazed Beggar")
local monster = {}

monster.description = "a crazed beggar"
monster.experience = 35
monster.outfit = {
	lookType = 153,
	lookHead = 40,
	lookBody = 19,
	lookLegs = 21,
	lookFeet = 97,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 525
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Factory, Foreigner, and Trade Quarters in Yalahar.",
}

monster.health = 100
monster.maxHealth = 100
monster.race = "blood"
monster.corpse = 18070
monster.speed = 77
monster.manaCost = 300

monster.changeTarget = {
	interval = 4000,
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
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 10,
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
	{ text = "Hehehe!", yell = false },
	{ text = "Raahhh!", yell = false },
	{ text = "You are one of THEM! Die!", yell = false },
	{ text = "Wanna buy roses??", yell = false },
	{ text = "Make it stop!", yell = false },
	{ text = "They're coming! They're coming!", yell = false },
	{ text = "Gimme money!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99000, maxCount = 9 }, -- Gold Coin
	{ id = 3122, chance = 60000 }, -- Dirty Cape
	{ id = 3601, chance = 19600 }, -- Roll
	{ id = 3577, chance = 9900 }, -- Meat
	{ id = 3470, chance = 9600 }, -- Wooden Spoon
	{ id = 3459, chance = 7000 }, -- Wooden Hammer
	{ id = 3658, chance = 5300 }, -- Red Rose
	{ id = 3473, chance = 4300 }, -- Rolling Pin
	{ id = 2389, chance = 670 }, -- Small Blue Pillow
	{ id = 5552, chance = 560 }, -- Rum Flask
	{ id = 3738, chance = 540 }, -- Sling Herb
	{ id = 2950, chance = 320 }, -- Lute
	{ id = 8894, chance = 300 }, -- Heavily Rusted Armor
	{ id = 6091, chance = 280 }, -- Very Noble-Looking Watch
	{ id = 3097, chance = 110 }, -- Dwarven Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -25 },
}

monster.defenses = {
	defense = 15,
	armor = 4,
	mitigation = 0.20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
