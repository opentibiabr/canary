local mType = Game.createMonsterType("Rage Squid")
local monster = {}

monster.description = "a rage squid"
monster.experience = 16300
monster.outfit = {
	lookType = 1059,
	lookHead = 94,
	lookBody = 78,
	lookLegs = 79,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1668
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library (fire section).",
}

monster.health = 17000
monster.maxHealth = 17000
monster.race = "undead"
monster.corpse = 28782
monster.speed = 215
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
	{ id = 3035, chance = 74800, maxCount = 6 }, -- Platinum Coin
	{ id = 7643, chance = 29690, maxCount = 3 }, -- Ultimate Health Potion
	{ id = 238, chance = 19270, maxCount = 3 }, -- Great Mana Potion
	{ id = 7642, chance = 18640, maxCount = 3 }, -- Great Spirit Potion
	{ id = 28570, chance = 18700 }, -- Glowing Rune
	{ id = 6499, chance = 6980 }, -- Demonic Essence
	{ id = 28568, chance = 11200 }, -- Inkwell (Black)
	{ id = 3731, chance = 14910, maxCount = 6 }, -- Fire Mushroom
	{ id = 9057, chance = 7690, maxCount = 5 }, -- Small Topaz
	{ id = 3030, chance = 7320, maxCount = 5 }, -- Small Ruby
	{ id = 3033, chance = 7470, maxCount = 5 }, -- Small Amethyst
	{ id = 3032, chance = 7640, maxCount = 5 }, -- Small Emerald
	{ id = 3320, chance = 5720 }, -- Fire Axe
	{ id = 3281, chance = 2310 }, -- Giant Sword
	{ id = 3039, chance = 2220 }, -- Red Gem
	{ id = 3034, chance = 2530 }, -- Talon
	{ id = 21194, chance = 2810 }, -- Slime Heart
	{ id = 3060, chance = 2160 }, -- Orb
	{ id = 3048, chance = 1770 }, -- Might Ring
	{ id = 9663, chance = 1060 }, -- Piece of Dead Brain
	{ id = 3420, chance = 2110 }, -- Demon Shield
	{ id = 3055, chance = 1930 }, -- Platinum Amulet
	{ id = 7382, chance = 1540 }, -- Demonrage Sword
	{ id = 2848, chance = 970 }, -- Purple Tome
	{ id = 3356, chance = 810 }, -- Devil Helmet
	{ id = 3366, chance = 320 }, -- Magic Plate Armor
	{ id = 16115, chance = 250 }, -- Wand of Everblazing
	{ id = 7393, chance = 40 }, -- Demon Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -280, range = 7, shootEffect = CONST_ANI_FLAMMINGARROW, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -380, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -175, maxDamage = -200, length = 5, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -475, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -200, maxDamage = -475, radius = 2, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
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
