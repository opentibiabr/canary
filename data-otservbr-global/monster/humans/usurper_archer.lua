local mType = Game.createMonsterType("Usurper Archer")
local monster = {}

monster.description = "an usurper archer"
monster.experience = 6800
monster.outfit = {
	lookType = 1316,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 76,
	lookFeet = 95,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1973
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Bounac, the Order of the Lion settlement.",
}

monster.health = 7300
monster.maxHealth = 7300
monster.race = "blood"
monster.corpse = 33981
monster.speed = 125
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_PLAYER, FACTION_LION }

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	targetDistance = 4,
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
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 3577, chance = 43390 }, -- Meat
	{ id = 7643, chance = 73550 }, -- Ultimate Health Potion
	{ id = 34161, chance = 15429 }, -- Broken Longbow
	{ id = 3027, chance = 9040 }, -- Black Pearl
	{ id = 3017, chance = 7370 }, -- Silver Brooch
	{ id = 21175, chance = 7680 }, -- Mino Shield
	{ id = 3369, chance = 8090 }, -- Warrior Helmet
	{ id = 34160, chance = 7339 }, -- Lion Crest
	{ id = 34162, chance = 9410 }, -- Lion Cloak Patch
	{ id = 3291, chance = 6150 }, -- Knife
	{ id = 7404, chance = 1100 }, -- Assassin Dagger
	{ id = 3026, chance = 3100 }, -- White Pearl
	{ id = 14247, chance = 1030 }, -- Ornate Crossbow
	{ id = 3370, chance = 3180 }, -- Knight Armor
	{ id = 24392, chance = 5290 }, -- Gemmed Figurine
	{ id = 24391, chance = 1210 }, -- Coral Brooch
	{ id = 819, chance = 2190 }, -- Glacier Shoes
	{ id = 281, chance = 5240 }, -- Giant Shimmering Pearl (Green)
	{ id = 3575, chance = 1050 }, -- Wood Cape
	{ id = 3010, chance = 700 }, -- Emerald Bangle
	{ id = 7438, chance = 330 }, -- Elvish Bow
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -430, range = 7, shootEffect = CONST_ANI_BURSTARROW, target = true },
	{ name = "combat", interval = 6000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -160, maxDamage = -485, range = 7, shootEffect = CONST_ANI_SMALLHOLY, target = true },
	{ name = "combat", interval = 4000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -160, maxDamage = -545, range = 7, effect = CONST_ME_MORTAREA, shootEffect = CONST_ANI_SUDDENDEATH, target = true },
	{ name = "combat", interval = 4000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -150, maxDamage = -425, radius = 3, effect = CONST_ME_ICEAREA, target = true },
}

monster.defenses = {
	defense = 50,
	armor = 82,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
