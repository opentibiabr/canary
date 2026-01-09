local mType = Game.createMonsterType("Arachnophobica")
local monster = {}

monster.description = "an arachnophobica"
monster.experience = 4700
monster.outfit = {
	lookType = 1135,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1729
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Buried Cathedral, Haunted Cellar, Court of Summer, Court of Winter, Dream Labyrinth.",
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "blood"
monster.corpse = 30073
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
	{ text = "Tip tap tip tap!", yell = false },
	{ text = "Zip zip zip!!!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 85423, maxCount = 14 }, -- Platinum Coin
	{ id = 7642, chance = 31072, maxCount = 3 }, -- Great Spirit Potion
	{ id = 8031, chance = 10588 }, -- Spider Fangs
	{ id = 10306, chance = 7668 }, -- Essence of a Bad Dream
	{ id = 3054, chance = 7019 }, -- Silver Amulet
	{ id = 3091, chance = 5530 }, -- Sword Ring
	{ id = 3062, chance = 4760 }, -- Mind Stone
	{ id = 3073, chance = 4538 }, -- Wand of Cosmic Energy
	{ id = 3051, chance = 4243 }, -- Energy Ring
	{ id = 3052, chance = 2873 }, -- Life Ring
	{ id = 3092, chance = 2806 }, -- Axe Ring
	{ id = 817, chance = 2215 }, -- Magma Amulet
	{ id = 3060, chance = 2084 }, -- Orb
	{ id = 3050, chance = 2715 }, -- Power Ring
	{ id = 3082, chance = 2856 }, -- Elven Amulet
	{ id = 8082, chance = 2756 }, -- Underworld Rod
	{ id = 6299, chance = 2033 }, -- Death Ring
	{ id = 23544, chance = 1446 }, -- Collar of Red Plasma
	{ id = 23529, chance = 1377 }, -- Ring of Blue Plasma
	{ id = 3083, chance = 1063 }, -- Garlic Necklace
	{ id = 9302, chance = 1856 }, -- Sacred Tree Amulet
	{ id = 3098, chance = 1052 }, -- Ring of Healing
	{ id = 3055, chance = 1660 }, -- Platinum Amulet
	{ id = 5879, chance = 1289 }, -- Spider Silk
	{ id = 3045, chance = 650 }, -- Strange Talisman
	{ id = 3058, chance = 638 }, -- Strange Symbol
	{ id = 13990, chance = 968 }, -- Necklace of the Deep
	{ id = 23543, chance = 432 }, -- Collar of Green Plasma
	{ id = 3081, chance = 686 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "arachnophobicawavedice", interval = 2000, chance = 20, minDamage = -250, maxDamage = -350, target = false },
	{ name = "arachnophobicawaveenergy", interval = 2000, chance = 20, minDamage = -250, maxDamage = -350, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -350, radius = 4, effect = CONST_ME_BLOCKHIT, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -300, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 70,
	mitigation = 1.94,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
