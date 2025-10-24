local mType = Game.createMonsterType("Animated Feather")
local monster = {}

monster.description = "an animated feather"
monster.experience = 9860
monster.outfit = {
	lookType = 1058,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1671
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "The Secret Library (ice section).",
}

monster.health = 13000
monster.maxHealth = 13000
monster.race = "ink"
monster.corpse = 28578
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 179,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3029, chance = 39790, maxCount = 12 }, -- Small Sapphire
	{ id = 3035, chance = 77370, maxCount = 21 }, -- Platinum Coin
	{ id = 28570, chance = 77790, maxCount = 5 }, -- Glowing Rune
	{ id = 829, chance = 7560 }, -- Glacier Mask
	{ id = 3051, chance = 13930 }, -- Energy Ring
	{ id = 7441, chance = 14300 }, -- Ice Cube
	{ id = 23373, chance = 17380, maxCount = 2 }, -- Ultimate Mana Potion
	{ id = 28567, chance = 13489 }, -- Quill
	{ id = 7387, chance = 4660 }, -- Diamond Sceptre
	{ id = 815, chance = 2940 }, -- Glacier Amulet
	{ id = 2903, chance = 2640 }, -- Golden Mug
	{ id = 3028, chance = 4810, maxCount = 12 }, -- Small Diamond
	{ id = 3061, chance = 3650 }, -- Life Crystal
	{ id = 3067, chance = 2470 }, -- Hailstorm Rod
	{ id = 3333, chance = 2820 }, -- Crystal Mace
	{ id = 7437, chance = 870 }, -- Sapphire Hammer
	{ id = 16118, chance = 919 }, -- Glacial Rod
	{ id = 8050, chance = 200 }, -- Crystalline Armor
	{ id = 9303, chance = 390 }, -- Leviathan's Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -200, range = 7, shootEffect = CONST_ANI_ICE, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -780, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -200, maxDamage = -275, length = 3, spread = 2, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_ICEDAMAGE, minDamage = -230, maxDamage = -680, range = 7, radius = 3, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICETORNADO, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 79,
	mitigation = 2.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -18 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
