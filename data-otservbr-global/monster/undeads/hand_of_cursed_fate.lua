local mType = Game.createMonsterType("Hand of Cursed Fate")
local monster = {}

monster.description = "a hand of cursed fate"
monster.experience = 5000
monster.outfit = {
	lookType = 230,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 281
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Pits of Inferno, The Battlefield, The Arcanum, The Blood Halls and The Crystal Caves.",
}

monster.health = 6600
monster.maxHealth = 6600
monster.race = "blood"
monster.corpse = 6311
monster.speed = 130
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
	staticAttackChance = 20,
	targetDistance = 1,
	runHealth = 3500,
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
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 267 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 7 }, -- platinum coin
	{ id = 5944, chance = 80000 }, -- soul orb
	{ id = 6558, chance = 80000, maxCount = 4 }, -- flask of demonic blood
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 3062, chance = 23000 }, -- mind stone
	{ id = 7368, chance = 23000, maxCount = 5 }, -- assassin star
	{ id = 3029, chance = 23000, maxCount = 4 }, -- small sapphire
	{ id = 6499, chance = 23000 }, -- demonic essence
	{ id = 3084, chance = 23000 }, -- protection amulet
	{ id = 3037, chance = 23000 }, -- yellow gem
	{ id = 3010, chance = 5000 }, -- emerald bangle
	{ id = 3071, chance = 5000 }, -- wand of inferno
	{ id = 3155, chance = 5000, maxCount = 8 }, -- sudden death rune
	{ id = 3370, chance = 5000 }, -- knight armor
	{ id = 3051, chance = 5000 }, -- energy ring
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 6299, chance = 5000 }, -- death ring
	{ id = 3381, chance = 1000 }, -- crown armor
	{ id = 3055, chance = 1000 }, -- platinum amulet
	{ id = 3324, chance = 1000 }, -- skull staff
	{ id = 3036, chance = 1000 }, -- violet gem
	{ id = 9058, chance = 1000 }, -- gold ingot
	{ id = 3079, chance = 260 }, -- boots of haste
	{ id = 5668, chance = 260 }, -- mysterious voodoo skull
	{ id = 7414, chance = 260 }, -- abyss hammer
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -520, condition = { type = CONDITION_POISON, totalDamage = 380, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -620, range = 1, target = false },
	{ name = "drunk", interval = 2000, chance = 10, radius = 4, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 3000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -220, maxDamage = -880, range = 1, effect = CONST_ME_SMALLCLOUDS, target = false },
}

monster.defenses = {
	defense = 25,
	armor = 53,
	mitigation = 1.88,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 1000, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
