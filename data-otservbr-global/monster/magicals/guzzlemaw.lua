local mType = Game.createMonsterType("Guzzlemaw")
local monster = {}

monster.description = "a guzzlemaw"
monster.experience = 6050
monster.outfit = {
	lookType = 584,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1013
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Guzzlemaw Valley, and a single spawn in a tower in Upper Roshamuul (south of the Depot and west of the entrance to Roshamuul Prison).",
}

monster.health = 6400
monster.maxHealth = 6400
monster.race = "blood"
monster.corpse = 20151
monster.speed = 200
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 88000, maxCount = 7 }, -- Platinum Coin
	{ id = 3031, chance = 75000, maxCount = 100 }, -- Gold Coin
	{ id = 238, chance = 14700, maxCount = 3 }, -- Great Mana Potion
	{ id = 239, chance = 13200, maxCount = 2 }, -- Great Health Potion
	{ id = 20198, chance = 11100 }, -- Frazzle Tongue
	{ id = 20199, chance = 9500 }, -- Frazzle Skin
	{ id = 3114, chance = 9300 }, -- Skull (Item)
	{ id = 3115, chance = 8500 }, -- Bone
	{ id = 3111, chance = 8100 }, -- Fishbone
	{ id = 16279, chance = 8000 }, -- Crystal Rubbish
	{ id = 5951, chance = 7700 }, -- Fish Tail
	{ id = 3125, chance = 7700 }, -- Remains of a Fish
	{ id = 16123, chance = 7600, maxCount = 2 }, -- Brown Crystal Splinter
	{ id = 3110, chance = 7500 }, -- Piece of Iron
	{ id = 3582, chance = 7200 }, -- Ham
	{ id = 3104, chance = 7000 }, -- Banana Skin
	{ id = 16126, chance = 5600 }, -- Red Crystal Fragment
	{ id = 3578, chance = 5000, maxCount = 3 }, -- Fish
	{ id = 3116, chance = 4300 }, -- Big Bone
	{ id = 5895, chance = 3400 }, -- Fish Fin
	{ id = 5925, chance = 2900 }, -- Hardened Bone
	{ id = 16120, chance = 2500 }, -- Violet Crystal Shard
	{ id = 3265, chance = 2100 }, -- Two Handed Sword
	{ id = 5880, chance = 2000 }, -- Iron Ore
	{ id = 7407, chance = 1800 }, -- Haunted Blade
	{ id = 50183, chance = 1100 }, -- Sai
	{ id = 20062, chance = 950 }, -- Cluster of Solace
	{ id = 7404, chance = 740 }, -- Assassin Dagger
	{ id = 7418, chance = 540 }, -- Nightmare Blade
	{ id = 10389, chance = 170 }, -- Traditional Sai
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -499 },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 10, minDamage = -500, maxDamage = -1000, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -900, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -500, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -800, radius = 6, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -800, length = 8, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 74,
	mitigation = 2.31,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
