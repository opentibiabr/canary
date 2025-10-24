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
	{ id = 3031, chance = 96871, maxCount = 287 }, -- Gold Coin
	{ id = 3122, chance = 59301 }, -- Dirty Cape
	{ id = 3120, chance = 43963 }, -- Mouldy Cheese
	{ id = 3282, chance = 29475 }, -- Morning Star
	{ id = 3110, chance = 18934 }, -- Piece of Iron
	{ id = 3265, chance = 20049 }, -- Two Handed Sword
	{ id = 3305, chance = 19155 }, -- Battle Hammer
	{ id = 3409, chance = 19467 }, -- Steel Shield
	{ id = 5944, chance = 12641 }, -- Soul Orb
	{ id = 239, chance = 9679 }, -- Great Health Potion
	{ id = 6499, chance = 8710 }, -- Demonic Essence
	{ id = 3035, chance = 11390, maxCount = 2 }, -- Platinum Coin
	{ id = 7365, chance = 19043, maxCount = 4 }, -- Onyx Arrow
	{ id = 8896, chance = 7573 }, -- Slightly Rusted Armor
	{ id = 3371, chance = 6934 }, -- Knight Legs
	{ id = 3093, chance = 4293 }, -- Club Ring
	{ id = 3033, chance = 9727, maxCount = 3 }, -- Small Amethyst
	{ id = 3092, chance = 5215 }, -- Axe Ring
	{ id = 3017, chance = 1987 }, -- Silver Brooch
	{ id = 3279, chance = 1821 }, -- War Hammer
	{ id = 3554, chance = 1400 }, -- Steel Boots
	{ id = 5887, chance = 1266 }, -- Piece of Royal Steel
	{ id = 5888, chance = 1173 }, -- Piece of Hell Steel
	{ id = 5889, chance = 1048 }, -- Piece of Draconian Steel
	{ id = 3332, chance = 722 }, -- Hammer of Wrath
	{ id = 3010, chance = 369 }, -- Emerald Bangle
	{ id = 2958, chance = 202 }, -- War Horn
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
