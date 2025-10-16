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
	{ id = 3031, chance = 80000, maxCount = 287 }, -- gold coin
	{ id = 3122, chance = 80000 }, -- dirty cape
	{ id = 3120, chance = 80000 }, -- mouldy cheese
	{ id = 3282, chance = 23000 }, -- morning star
	{ id = 3110, chance = 23000 }, -- piece of iron
	{ id = 3265, chance = 23000 }, -- two handed sword
	{ id = 3305, chance = 23000 }, -- battle hammer
	{ id = 3409, chance = 23000 }, -- steel shield
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 3035, chance = 23000, maxCount = 2 }, -- platinum coin
	{ id = 7365, chance = 23000, maxCount = 4 }, -- onyx arrow
	{ id = 8896, chance = 23000 }, -- slightly rusted armor
	{ id = 3371, chance = 23000 }, -- knight legs
	{ id = 3093, chance = 5000 }, -- club ring
	{ id = 3033, chance = 5000, maxCount = 3 }, -- small amethyst
	{ id = 3092, chance = 5000 }, -- axe ring
	{ id = 3017, chance = 5000 }, -- silver brooch
	{ id = 3279, chance = 5000 }, -- war hammer
	{ id = 3554, chance = 1000 }, -- steel boots
	{ id = 5887, chance = 1000 }, -- piece of royal steel
	{ id = 5888, chance = 1000 }, -- piece of hell steel
	{ id = 5889, chance = 1000 }, -- piece of draconian steel
	{ id = 3332, chance = 1000 }, -- hammer of wrath
	{ id = 3010, chance = 260 }, -- emerald bangle
	{ id = 2958, chance = 260 }, -- war horn
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
