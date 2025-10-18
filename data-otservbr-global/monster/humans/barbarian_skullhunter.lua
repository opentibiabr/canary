local mType = Game.createMonsterType("Barbarian Skullhunter")
local monster = {}

monster.description = "a barbarian skullhunter"
monster.experience = 85
monster.outfit = {
	lookType = 254,
	lookHead = 0,
	lookBody = 77,
	lookLegs = 96,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 322
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Ragnir, Krimhorn, Bittermor, and Fenrock.",
}

monster.health = 135
monster.maxHealth = 135
monster.race = "blood"
monster.corpse = 18066
monster.speed = 84
monster.manaCost = 450

monster.changeTarget = {
	interval = 60000,
	chance = 0,
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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 70,
	targetDistance = 1,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will become my trophy.", yell = false },
	{ text = "Fight harder, coward.", yell = false },
	{ text = "Show that you are a worthy opponent.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 75002, maxCount = 30 }, -- Gold Coin
	{ id = 2920, chance = 59527 }, -- Torch
	{ id = 3291, chance = 15370 }, -- Knife
	{ id = 3354, chance = 19993 }, -- Brass Helmet
	{ id = 3367, chance = 8550 }, -- Viking Helmet
	{ id = 3114, chance = 2592 }, -- Skull (Item)
	{ id = 3377, chance = 3850 }, -- Scale Armor
	{ id = 266, chance = 668 }, -- Health Potion
	{ id = 5913, chance = 495 }, -- Brown Piece of Cloth
	{ id = 50150, chance = 1500 }, -- Ring of Orange Plasma
	{ id = 3052, chance = 116 }, -- Life Ring
	{ id = 7449, chance = 104 }, -- Crystal Sword
	{ id = 7457, chance = 218 }, -- Fur Boots
	{ id = 7462, chance = 227 }, -- Ragnir Helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -60 },
}

monster.defenses = {
	defense = 0,
	armor = 8,
	mitigation = 0.33,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
