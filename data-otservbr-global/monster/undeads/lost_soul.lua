local mType = Game.createMonsterType("Lost Soul")
local monster = {}

monster.description = "a lost soul"
monster.experience = 4000
monster.outfit = {
	lookType = 232,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 283
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, Formorgar Mines, Helheim, Roshamuul Prison and in The Arcanum Part of the Inquisition quest, Oramond Fury Dungeon",
}

monster.health = 5800
monster.maxHealth = 5800
monster.race = "undead"
monster.corpse = 6309
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	runHealth = 450,
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
	{ text = "Mouuuurn meeee!", yell = false },
	{ text = "Forgive Meee!", yell = false },
	{ text = "Help meee!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 198 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 7 }, -- platinum coin
	{ id = 3147, chance = 80000, maxCount = 3 }, -- blank rune
	{ id = 10316, chance = 80000 }, -- unholy bone
	{ id = 5944, chance = 23000 }, -- soul orb
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 239, chance = 23000, maxCount = 2 }, -- great health potion
	{ id = 3026, chance = 23000, maxCount = 3 }, -- white pearl
	{ id = 3027, chance = 23000, maxCount = 3 }, -- black pearl
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 3016, chance = 5000 }, -- ruby necklace
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 7370, chance = 5000 }, -- silver goblet
	{ id = 6299, chance = 5000 }, -- death ring
	{ id = 6525, chance = 5000 }, -- skeleton decoration
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 8896, chance = 5000 }, -- slightly rusted armor
	{ id = 3081, chance = 1000 }, -- stone skin amulet
	{ id = 3324, chance = 1000 }, -- skull staff
	{ id = 3428, chance = 1000 }, -- tower shield
	{ id = 7407, chance = 1000 }, -- haunted blade
	{ id = 5741, chance = 260 }, -- skull helmet
	{ id = 8895, chance = 80000 }, -- rusted armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -420 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -40, maxDamage = -210, length = 3, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -800, radius = 6, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 4000 },
}

monster.defenses = {
	defense = 30,
	armor = 28,
	mitigation = 1.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
