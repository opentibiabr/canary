local mType = Game.createMonsterType("Ink Blob")
local monster = {}

monster.description = "an ink blob"
monster.experience = 14450
monster.outfit = {
	lookType = 1064,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1658
monster.Bestiary = {
	class = "Slime",
	race = BESTY_RACE_SLIME,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Secret Library (earth, fire and ice sections)",
}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "ink"
monster.corpse = 28601
monster.speed = 190
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
	canPushCreatures = false,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 0,
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
}

monster.loot = {
	{ id = 3028, chance = 66890, maxCount = 7 }, -- Small Diamond
	{ id = 3035, chance = 75250, maxCount = 25 }, -- Platinum Coin
	{ id = 9057, chance = 49780, maxCount = 3 }, -- Small Topaz
	{ id = 9640, chance = 35380, maxCount = 9 }, -- Poisonous Slime
	{ id = 16143, chance = 69600, maxCount = 40 }, -- Envenomed Arrow
	{ id = 28568, chance = 43890, maxCount = 4 }, -- Inkwell (Black)
	{ id = 282, chance = 15680, maxCount = 3 }, -- Giant Shimmering Pearl (Brown)
	{ id = 813, chance = 5320 }, -- Terra Boots
	{ id = 830, chance = 5580 }, -- Terra Hood
	{ id = 3041, chance = 4720 }, -- Blue Gem
	{ id = 812, chance = 2870 }, -- Terra Legs
	{ id = 3081, chance = 1609 }, -- Stone Skin Amulet
	{ id = 3084, chance = 1250 }, -- Protection Amulet
	{ id = 9302, chance = 1669 }, -- Sacred Tree Amulet
	{ id = 8084, chance = 750 }, -- Springsprout Rod
	{ id = 811, chance = 870 }, -- Terra Mantle
	{ id = 10422, chance = 540 }, -- Clay Lump
	{ id = 814, chance = 390 }, -- Terra Amulet
	{ id = 8052, chance = 119 }, -- Swamplair Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 45, attack = 40, condition = { type = CONDITION_POISON, totalDamage = 280, interval = 4000 } },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 13, minDamage = -400, maxDamage = -580, radius = 4, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 11, type = COMBAT_EARTHDAMAGE, minDamage = -285, maxDamage = -480, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -260, maxDamage = -505, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 70,
	mitigation = 2.02,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 20, maxDamage = 30, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -8 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
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
