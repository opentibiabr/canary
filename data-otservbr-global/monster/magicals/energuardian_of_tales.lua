local mType = Game.createMonsterType("Energuardian of Tales")
local monster = {}

monster.description = "an energuardian of tales"
monster.experience = 11361
monster.outfit = {
	lookType = 1063,
	lookHead = 86,
	lookBody = 85,
	lookLegs = 82,
	lookFeet = 93,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1666
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "The Secret Library (energy section).",
}

monster.health = 14000
monster.maxHealth = 14000
monster.race = "undead"
monster.corpse = 28873
monster.speed = 210
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
	{ text = "Die, enervating mortal!", yell = false },
	{ text = "Let the energy flow!", yell = false },
}

monster.loot = {
	{ id = 28569, chance = 57993, maxCount = 6 }, -- Book Page
	{ id = 3033, chance = 55297, maxCount = 10 }, -- Small Amethyst
	{ id = 28570, chance = 19970, maxCount = 4 }, -- Glowing Rune
	{ id = 761, chance = 7519, maxCount = 15 }, -- Flash Arrow
	{ id = 822, chance = 7782 }, -- Lightning Legs
	{ id = 7643, chance = 13179 }, -- Ultimate Health Potion
	{ id = 23373, chance = 8801 }, -- Ultimate Mana Potion
	{ id = 8092, chance = 6990 }, -- Wand of Starstorm
	{ id = 8073, chance = 9023 }, -- Spellbook of Warding
	{ id = 816, chance = 4674, maxCount = 2 }, -- Lightning Pendant
	{ id = 3048, chance = 2271 }, -- Might Ring
	{ id = 3055, chance = 2299 }, -- Platinum Amulet
	{ id = 16096, chance = 1290 }, -- Wand of Defiance
	{ id = 10438, chance = 1052 }, -- Spellweaver's Robe
	{ id = 9304, chance = 770 }, -- Shockwave Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -10, maxDamage = -550 },
	{ name = "combat", interval = 1000, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -555, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 77,
	mitigation = 1.94,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -12 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
