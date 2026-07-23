local mType = Game.createMonsterType("Plaguesmith")
local monster = {}

monster.description = "a plaguesmith"
monster.experience = 3800
monster.outfit = {
	lookType = 247,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 314
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, Formorgar Mines, Edron Demon Forge (The Vats, The Foundry), \z
	Magician Quarter, Alchemist Quarter, Roshamuul Prison, Grounds of Plague and Halls of Ascension.",
}

monster.health = 8250
monster.maxHealth = 8250
monster.race = "venom"
monster.corpse = 6515
monster.speed = 160
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
	runHealth = 500,
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
	{ text = "You are looking a bit feverish!", yell = false },
	{ text = "You don't look that good!", yell = false },
	{ text = "Hachoo!", yell = false },
	{ text = "Cough Cough", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 96000, maxCount = 266 }, -- Gold Coin
	{ id = 3122, chance = 48000 }, -- Dirty Cape
	{ id = 3120, chance = 41000 }, -- Mouldy Cheese
	{ id = 3282, chance = 23000 }, -- Morning Star
	{ id = 3305, chance = 16300 }, -- Battle Hammer
	{ id = 3110, chance = 16200 }, -- Piece of Iron
	{ id = 3409, chance = 16200 }, -- Steel Shield
	{ id = 3265, chance = 16200 }, -- Two Handed Sword
	{ id = 5944, chance = 9500 }, -- Soul Orb
	{ id = 239, chance = 7400 }, -- Great Health Potion
	{ id = 6499, chance = 7200 }, -- Demonic Essence
	{ id = 8896, chance = 6300 }, -- Slightly Rusted Armor
	{ id = 7365, chance = 6300, maxCount = 4 }, -- Onyx Arrow
	{ id = 3035, chance = 6000, maxCount = 2 }, -- Platinum Coin
	{ id = 3371, chance = 5900 }, -- Knight Legs
	{ id = 3033, chance = 4300, maxCount = 3 }, -- Small Amethyst
	{ id = 3092, chance = 4200 }, -- Axe Ring
	{ id = 3093, chance = 4000 }, -- Club Ring
	{ id = 3279, chance = 1800 }, -- War Hammer
	{ id = 3017, chance = 1600 }, -- Silver Brooch
	{ id = 3554, chance = 1100 }, -- Steel Boots
	{ id = 5889, chance = 910 }, -- Piece of Draconian Steel
	{ id = 5888, chance = 870 }, -- Piece of Hell Steel
	{ id = 5887, chance = 860 }, -- Piece of Royal Steel
	{ id = 3332, chance = 600 }, -- Hammer of Wrath
	{ id = 3010, chance = 280 }, -- Emerald Bangle
	{ id = 2958, chance = 52 }, -- War Horn
}

monster.attacks = {
	{ name = "melee", interval = 1500, chance = 100, minDamage = 0, maxDamage = -539, condition = { type = CONDITION_POISON, totalDamage = 200, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -114, radius = 4, effect = CONST_ME_POISONAREA, target = false },
	{ name = "plaguesmith wave", interval = 2000, chance = 10, minDamage = -100, maxDamage = -350, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -800, radius = 4, effect = CONST_ME_POISONAREA, target = false, duration = 30000 },
}

monster.defenses = {
	defense = 40,
	armor = 30,
	mitigation = 1.32,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 200, maxDamage = 280, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 440, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
