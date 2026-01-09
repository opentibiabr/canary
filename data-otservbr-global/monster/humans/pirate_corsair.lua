local mType = Game.createMonsterType("Pirate Corsair")
local monster = {}

monster.description = "a pirate corsair"
monster.experience = 350
monster.outfit = {
	lookType = 98,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 250
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Nargor, Trade Quarter, Foreigner Quarter Dock, Krailos Steppe During a World Change.",
}

monster.health = 675
monster.maxHealth = 675
monster.race = "blood"
monster.corpse = 18194
monster.speed = 119
monster.manaCost = 775

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 40,
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
	{ text = "Hiyaa!", yell = false },
	{ text = "Give up!", yell = false },
	{ text = "Plundeeeeer!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 55460, maxCount = 88 }, -- Gold Coin
	{ id = 3273, chance = 12569 }, -- Sabre
	{ id = 3287, chance = 47295, maxCount = 12 }, -- Throwing Star
	{ id = 10302, chance = 5423 }, -- Compass
	{ id = 3383, chance = 3369 }, -- Dark Armor
	{ id = 236, chance = 1441 }, -- Strong Health Potion
	{ id = 3421, chance = 670 }, -- Dark Shield
	{ id = 5926, chance = 990 }, -- Pirate Backpack
	{ id = 6096, chance = 1050 }, -- Pirate Hat
	{ id = 6097, chance = 1735 }, -- Hook
	{ id = 6098, chance = 656 }, -- Eye Patch
	{ id = 6126, chance = 656 }, -- Peg Leg
	{ id = 5461, chance = 320 }, -- Pirate Boots
	{ id = 5812, chance = 120 }, -- Skull Candle
	{ id = 2995, chance = 80 }, -- Piggy Bank
	{ id = 5552, chance = 120 }, -- Rum Flask
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -170 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, range = 3, shootEffect = CONST_ANI_THROWINGSTAR, target = false },
	{ name = "pirate corsair skill reducer", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 20,
	mitigation = 1.46,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
