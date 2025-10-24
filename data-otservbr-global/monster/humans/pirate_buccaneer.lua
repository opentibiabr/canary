local mType = Game.createMonsterType("Pirate Buccaneer")
local monster = {}

monster.description = "a pirate buccaneer"
monster.experience = 250
monster.outfit = {
	lookType = 97,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 249
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Nargor, Tyrsung on the ship, Yalahar Foreign Quarter, Krailos Steppe and The Cave.",
}

monster.health = 425
monster.maxHealth = 425
monster.race = "blood"
monster.corpse = 18190
monster.speed = 109
monster.manaCost = 595

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
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 50,
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
	{ text = "Give up!", yell = false },
	{ text = "Hiyaa", yell = false },
	{ text = "Plundeeeeer!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 67610, maxCount = 60 }, -- Gold Coin
	{ id = 2920, chance = 9483 }, -- Torch
	{ id = 3123, chance = 10282 }, -- Worn Leather Boots
	{ id = 3273, chance = 9514 }, -- Sabre
	{ id = 3298, chance = 21321, maxCount = 5 }, -- Throwing Knife
	{ id = 10302, chance = 10726 }, -- Compass
	{ id = 3413, chance = 3646 }, -- Battle Shield
	{ id = 236, chance = 616 }, -- Strong Health Potion
	{ id = 3357, chance = 972 }, -- Plate Armor
	{ id = 5706, chance = 1030 }, -- Treasure Map (Pirate)
	{ id = 5926, chance = 447 }, -- Pirate Backpack
	{ id = 6095, chance = 883 }, -- Pirate Shirt
	{ id = 6097, chance = 476 }, -- Hook
	{ id = 6098, chance = 659 }, -- Eye Patch
	{ id = 6126, chance = 578 }, -- Peg Leg
	{ id = 5552, chance = 130 }, -- Rum Flask
	{ id = 5792, chance = 50 }, -- Die
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -160 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 4, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 16,
	mitigation = 1.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
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
