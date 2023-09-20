local mType = Game.createMonsterType("Ghastly Dragon")
local monster = {}

monster.description = "a ghastly dragon"
monster.experience = 4600
monster.outfit = {
	lookType = 351,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 643
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Ghastly Dragon Lair, Corruption Hole, Razachai including the Inner Sanctum, Zao Palace, Deeper Banuta single spawn, Chyllfroest.",
}

monster.health = 7800
monster.maxHealth = 7800
monster.race = "undead"
monster.corpse = 10445
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	runHealth = 366,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 119,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "EMBRACE MY GIFTS!", yell = true },
	{ text = "I WILL FEAST ON YOUR SOUL!", yell = true },
}

monster.loot = {
	{ name = "gold coin", chance = 99500, maxCount = 238 },
	{ name = "plate legs", chance = 53270 },
	{ name = "small emerald", chance = 41210, maxCount = 5 },
	{ name = "platinum coin", chance = 33170, maxCount = 2 },
	{ name = "great spirit potion", chance = 32659, maxCount = 2 },
	{ name = "dark armor", chance = 30650 },
	{ name = "great mana potion", chance = 27140, maxCount = 2 },
	{ name = "ultimate health potion", chance = 24120 },
	{ name = "undead heart", chance = 21610 },
	{ name = "zaoan halberd", chance = 16580 },
	{ id = 8896, chance = 15080 }, -- slightly rusted armor
	{ name = "demonic essence", chance = 10550 },
	{ name = "terra boots", chance = 10050 },
	{ name = "twin hooks", chance = 9550 },
	{ name = "ghastly dragon head", chance = 7540 },
	{ name = "soul orb", chance = 7040 },
	{ name = "terra legs", chance = 4520 },
	{ name = "jade hat", chance = 1010 },
	{ name = "zaoan armor", chance = 1010 },
	{ name = "guardian boots", chance = 1010 },
	{ name = "drakinata", chance = 1010 },
	{ name = "spellweaver's robe", chance = 500 },
	{ name = "zaoan shoes", chance = 980 },
	{ name = "zaoan legs", chance = 970 },
	{ name = "shiny stone", chance = 830 },
	{ name = "zaoan helmet", chance = 230 },
	{ name = "zaoan sword", chance = 120 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -603 },
	{ name = "ghastly dragon curse", interval = 2000, chance = 5, range = 5, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -920, maxDamage = -1280, range = 5, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -230, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "ghastly dragon wave", interval = 2000, chance = 10, minDamage = -120, maxDamage = -250, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -110, maxDamage = -180, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -800, range = 7, effect = CONST_ME_SMALLCLOUDS, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 35,
	armor = 30,
	mitigation = 1.24,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
