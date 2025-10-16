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
	{ id = 3031, chance = 80000, maxCount = 198 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 10316, chance = 80000 }, -- unholy bone
	{ id = 3029, chance = 80000, maxCount = 2 }, -- small sapphire
	{ id = 7368, chance = 80000, maxCount = 5 }, -- assassin star
	{ id = 238, chance = 80000, maxCount = 3 }, -- great mana potion
	{ id = 239, chance = 80000, maxCount = 3 }, -- great health potion
	{ id = 3027, chance = 23000, maxCount = 2 }, -- black pearl
	{ id = 3450, chance = 23000, maxCount = 15 }, -- power bolt
	{ id = 5925, chance = 23000 }, -- hardened bone
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 2903, chance = 5000 }, -- golden mug
	{ id = 3370, chance = 5000 }, -- knight armor
	{ id = 7430, chance = 5000 }, -- dragonbone staff
	{ id = 3061, chance = 5000 }, -- life crystal
	{ id = 3342, chance = 5000 }, -- war axe
	{ id = 6299, chance = 5000 }, -- death ring
	{ id = 9058, chance = 5000 }, -- gold ingot
	{ id = 3392, chance = 1000 }, -- royal helmet
	{ id = 7402, chance = 1000 }, -- dragon slayer
	{ id = 3360, chance = 1000 }, -- golden armor
	{ id = 10438, chance = 1000 }, -- spellweavers robe
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 8057, chance = 1000 }, -- divine plate
	{ id = 3081, chance = 1000 }, -- stone skin amulet
	{ id = 8061, chance = 260 }, -- skullcracker armor
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
