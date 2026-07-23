local mType = Game.createMonsterType("Orclops Ravager")
local monster = {}

monster.description = "an orclops ravager"
monster.experience = 1100
monster.outfit = {
	lookType = 935,
	lookHead = 94,
	lookBody = 1,
	lookLegs = 80,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1320
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Desecrated Glade",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 25074
monster.speed = 130
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Crushing! Smashing! Ripping! Yeah!!", yell = false },
	{ text = "It's clobberin time!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 120 }, -- Gold Coin
	{ id = 3035, chance = 60000 }, -- Platinum Coin
	{ id = 24382, chance = 19300 }, -- Bug Meat
	{ id = 24381, chance = 18500 }, -- Beetle Carapace
	{ id = 24380, chance = 18000 }, -- Bone Toothpick
	{ id = 236, chance = 16200 }, -- Strong Health Potion
	{ id = 23811, chance = 10200 }, -- Reinvigorating Seeds
	{ id = 3316, chance = 8100 }, -- Orcish Axe
	{ id = 3724, chance = 8000, maxCount = 3 }, -- Red Mushroom
	{ id = 3078, chance = 6400 }, -- Mysterious Fetish
	{ id = 9057, chance = 3800, maxCount = 2 }, -- Small Topaz
	{ id = 8015, chance = 3200, maxCount = 2 }, -- Onion
	{ id = 3030, chance = 3100, maxCount = 3 }, -- Small Ruby
	{ id = 3027, chance = 2900, maxCount = 2 }, -- Black Pearl
	{ id = 16123, chance = 2600, maxCount = 2 }, -- Brown Crystal Splinter
	{ id = 7452, chance = 1500 }, -- Spiked Squelcher
	{ id = 17828, chance = 1300 }, -- Pair of Iron Fists
	{ id = 2966, chance = 1100 }, -- War Drum
	{ id = 7439, chance = 900 }, -- Berserk Potion
	{ id = 7419, chance = 10 }, -- Dreaded Cleaver
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = -180, maxDamage = -220, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 35,
	mitigation = 1.24,
	{ name = "speed", interval = 2000, chance = 10, speedChange = 336, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000 },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_HEALING, minDamage = 80, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
