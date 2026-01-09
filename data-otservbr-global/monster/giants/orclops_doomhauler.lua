local mType = Game.createMonsterType("Orclops Doomhauler")
local monster = {}

monster.description = "an orclops doomhauler"
monster.experience = 1450
monster.outfit = {
	lookType = 934,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1314
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Desecrated Glade, Edron Orc Cave",
}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 25078
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 15,
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
	{ text = "Me mash!", yell = false },
	{ text = "GRRRRR!", yell = true },
	{ text = "Muhahaha!", yell = false },
	{ text = "Me strong, you weak!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 184 }, -- Gold Coin
	{ id = 236, chance = 16780 }, -- Strong Health Potion
	{ id = 3078, chance = 6030 }, -- Mysterious Fetish
	{ id = 3316, chance = 7899 }, -- Orcish Axe
	{ id = 3724, chance = 8090, maxCount = 3 }, -- Red Mushroom
	{ id = 24380, chance = 19530 }, -- Bone Toothpick
	{ id = 24381, chance = 14970 }, -- Beetle Carapace
	{ id = 24382, chance = 20210 }, -- Bug Meat
	{ id = 3027, chance = 3150, maxCount = 2 }, -- Black Pearl
	{ id = 3030, chance = 3370, maxCount = 3 }, -- Small Ruby
	{ id = 7452, chance = 1390 }, -- Spiked Squelcher
	{ id = 8015, chance = 3000, maxCount = 2 }, -- Onion
	{ id = 9057, chance = 3040, maxCount = 2 }, -- Small Topaz
	{ id = 16123, chance = 2430, maxCount = 2 }, -- Brown Crystal Splinter
	{ id = 17828, chance = 1380 }, -- Pair of Iron Fists
	{ id = 2966, chance = 960 }, -- War Drum
	{ id = 7439, chance = 1060 }, -- Berserk Potion
	{ id = 10457, chance = 979 }, -- Beetle Necklace
	{ id = 7419, chance = 1000 }, -- Dreaded Cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -117, maxDamage = -220, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true },
	-- curse
	{ name = "condition", type = CONDITION_CURSED, interval = 2000, chance = 50, minDamage = -100, maxDamage = -200, radius = 4, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 35,
	mitigation = 1.32,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 336, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
