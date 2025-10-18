local mType = Game.createMonsterType("Brain Squid")
local monster = {}

monster.description = "a brain squid"
monster.experience = 17672
monster.outfit = {
	lookType = 1059,
	lookHead = 17,
	lookBody = 41,
	lookLegs = 77,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1653
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library (energy section).",
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "undead"
monster.corpse = 28582
monster.speed = 215
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
	{ text = "tzzzz tzzzzz tzzzzz", yell = false },
	{ text = "tzuuuumme tzuuummmmee", yell = false },
}

monster.loot = {
	{ id = 16120, chance = 34039, maxCount = 4 }, -- Violet Crystal Shard
	{ id = 3035, chance = 75668, maxCount = 20 }, -- Platinum Coin
	{ id = 28570, chance = 22904, maxCount = 4 }, -- Glowing Rune
	{ id = 23516, chance = 18113 }, -- Instable Proto Matter
	{ id = 23523, chance = 18937 }, -- Energy Ball
	{ id = 23535, chance = 15565 }, -- Energy Bar
	{ id = 23545, chance = 15290 }, -- Energy Drink
	{ id = 23510, chance = 7623 }, -- Odd Organ
	{ id = 23519, chance = 11456 }, -- Frozen Lightning
	{ id = 28568, chance = 11747 }, -- Inkwell (Black)
	{ id = 3030, chance = 5801, maxCount = 6 }, -- Small Ruby
	{ id = 16124, chance = 7185 }, -- Blue Crystal Splinter
	{ id = 23373, chance = 11931 }, -- Ultimate Mana Potion
	{ id = 3036, chance = 4845 }, -- Violet Gem
	{ id = 16125, chance = 4008 }, -- Cyan Crystal Fragment
	{ id = 9663, chance = 1263 }, -- Piece of Dead Brain
	{ id = 16096, chance = 1439 }, -- Wand of Defiance
	{ id = 828, chance = 5251, maxCount = 2 }, -- Lightning Headband
	{ id = 816, chance = 1760 }, -- Lightning Pendant
	{ id = 21194, chance = 1710 }, -- Slime Heart
	{ id = 23544, chance = 1812 }, -- Collar of Red Plasma
	{ id = 23526, chance = 1598 }, -- Collar of Blue Plasma
	{ id = 23533, chance = 3055 }, -- Ring of Red Plasma
	{ id = 23529, chance = 2442 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 2633 }, -- Ring of Green Plasma
	{ id = 23543, chance = 590 }, -- Collar of Green Plasma
	{ id = 3048, chance = 1970 }, -- Might Ring
	{ id = 10438, chance = 509 }, -- Spellweaver's Robe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -470, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -505, radius = 3, effect = CONST_ME_ENERGYAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
