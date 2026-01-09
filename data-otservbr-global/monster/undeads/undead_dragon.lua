local mType = Game.createMonsterType("Undead Dragon")
local monster = {}

monster.description = "an undead dragon"
monster.experience = 7500
monster.outfit = {
	lookType = 231,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 282
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Helheim (single, isolated spawn), Pits of Inferno (Ashfalor's throneroom), \z
		Demon Forge (The Shadow Nexus and The Arcanum), under Razachai (including the Inner Sanctum), \z
		Chyllfroest, Oramond Fury Dungeon.",
}

monster.health = 8350
monster.maxHealth = 8350
monster.race = "undead"
monster.corpse = 6305
monster.speed = 165
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "FEEEED MY ETERNAL HUNGER!", yell = true },
	{ text = "I SENSE LIFE", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 99953, maxCount = 198 }, -- Gold Coin
	{ id = 3035, chance = 50499, maxCount = 5 }, -- Platinum Coin
	{ id = 10316, chance = 37931 }, -- Unholy Bone
	{ id = 3029, chance = 27253, maxCount = 2 }, -- Small Sapphire
	{ id = 7368, chance = 25380, maxCount = 5 }, -- Assassin Star
	{ id = 238, chance = 25726, maxCount = 3 }, -- Great Mana Potion
	{ id = 239, chance = 23645, maxCount = 3 }, -- Great Health Potion
	{ id = 3027, chance = 23867, maxCount = 2 }, -- Black Pearl
	{ id = 3450, chance = 14687, maxCount = 15 }, -- Power Bolt
	{ id = 5925, chance = 13205 }, -- Hardened Bone
	{ id = 6499, chance = 14781 }, -- Demonic Essence
	{ id = 2903, chance = 4710 }, -- Golden Mug
	{ id = 3370, chance = 4426 }, -- Knight Armor
	{ id = 7430, chance = 3961 }, -- Dragonbone Staff
	{ id = 3061, chance = 1172 }, -- Life Crystal
	{ id = 3342, chance = 1374 }, -- War Axe
	{ id = 6299, chance = 1595 }, -- Death Ring
	{ id = 9058, chance = 1381 }, -- Gold Ingot
	{ id = 3392, chance = 1031 }, -- Royal Helmet
	{ id = 7402, chance = 944 }, -- Dragon Slayer
	{ id = 3360, chance = 593 }, -- Golden Armor
	{ id = 10438, chance = 906 }, -- Spellweaver's Robe
	{ id = 3041, chance = 956 }, -- Blue Gem
	{ id = 8057, chance = 438 }, -- Divine Plate
	{ id = 3081, chance = 540 }, -- Stone Skin Amulet
	{ id = 8061, chance = 328 }, -- Skullcracker Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -400, range = 7, radius = 4, effect = CONST_ME_HITAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -125, maxDamage = -600, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -390, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -150, maxDamage = -690, length = 8, spread = 3, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -700, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -200, radius = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "undead dragon curse", interval = 2000, chance = 10, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 90 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
