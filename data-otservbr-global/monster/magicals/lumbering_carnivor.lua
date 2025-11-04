local mType = Game.createMonsterType("Lumbering Carnivor")
local monster = {}

monster.description = "a lumbering carnivor"
monster.experience = 1452
monster.outfit = {
	lookType = 1133,
	lookHead = 0,
	lookBody = 59,
	lookLegs = 67,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1721
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Carnivora's Rocks.",
}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 30065
monster.speed = 200
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 107,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 86856, maxCount = 3 }, -- Platinum Coin
	{ id = 29345, chance = 30064, maxCount = 3 }, -- Blue Glass Plate
	{ id = 3264, chance = 7404 }, -- Sword
	{ id = 3274, chance = 19370 }, -- Axe
	{ id = 3284, chance = 11422 }, -- Ice Rapier
	{ id = 282, chance = 2284 }, -- Giant Shimmering Pearl (Brown)
	{ id = 3036, chance = 2266 }, -- Violet Gem
	{ id = 3038, chance = 2494 }, -- Green Gem
	{ id = 3265, chance = 1556 }, -- Two Handed Sword
	{ id = 7454, chance = 2185 }, -- Glorious Axe
	{ id = 16121, chance = 1633 }, -- Green Crystal Shard
	{ id = 3041, chance = 1527 }, -- Blue Gem
	{ id = 3567, chance = 1064 }, -- Blue Robe
	{ id = 22085, chance = 1082 }, -- Fur Armor
	{ id = 8043, chance = 172 }, -- Focus Cape
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -150, radius = 4, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 65,
	mitigation = 1.82,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -40 },
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
