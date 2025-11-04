local mType = Game.createMonsterType("Braindeath")
local monster = {}

monster.description = "a braindeath"
monster.experience = 985
monster.outfit = {
	lookType = 256,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 321
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Helheim, Demon Forge (The Arcanum), beneath Fenrock, Vandura Bonelord Cave, \z
		Alchemist Quarter and Cemetery Quarter.",
}

monster.health = 1225
monster.maxHealth = 1225
monster.race = "undead"
monster.corpse = 7256
monster.speed = 109
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
	staticAttackChance = 80,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 180,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Vampire", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You have disturbed my thoughts!", yell = false },
	{ text = "I will turn you into something more useful!", yell = false },
	{ text = "Let me taste your brain!", yell = false },
	{ text = "You will be punished!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99096, maxCount = 90 }, -- Gold Coin
	{ id = 3338, chance = 14455 }, -- Bone Sword
	{ id = 7364, chance = 12938, maxCount = 4 }, -- Sniper Arrow
	{ id = 3409, chance = 6744 }, -- Steel Shield
	{ id = 5898, chance = 3490 }, -- Bonelord Eye
	{ id = 3311, chance = 1950 }, -- Clerical Mace
	{ id = 9663, chance = 5099 }, -- Piece of Dead Brain
	{ id = 7407, chance = 1482 }, -- Haunted Blade
	{ id = 3059, chance = 901 }, -- Spellbook
	{ id = 3408, chance = 221 }, -- Bonelord Helmet
	{ id = 3418, chance = 140 }, -- Bonelord Shield
	{ id = 7452, chance = 188 }, -- Spiked Squelcher
	{ id = 3081, chance = 1010 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -93, maxDamage = -170, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -75, maxDamage = -125, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -85, maxDamage = -170, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -65, maxDamage = -125, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -75, maxDamage = -85, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -155, range = 7, target = false },
}

monster.defenses = {
	defense = 12,
	armor = 12,
	mitigation = 0.67,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 260, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
