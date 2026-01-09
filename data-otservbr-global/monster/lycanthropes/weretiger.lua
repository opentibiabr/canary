local mType = Game.createMonsterType("Weretiger")
local monster = {}

monster.description = "a weretiger"
monster.experience = 3920
monster.outfit = {
	lookType = 1646,
	lookHead = 97,
	lookBody = 114,
	lookLegs = 113,
	lookFeet = 94,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2386
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Murky Caverns",
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "blood"
monster.corpse = 43669
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
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

monster.voices = {}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 13 }, -- Platinum Coin
	{ id = 43730, chance = 9750 }, -- Weretiger Tooth
	{ id = 3577, chance = 5710, maxCount = 4 }, -- Meat
	{ id = 7432, chance = 5970 }, -- Furry Club
	{ id = 22083, chance = 1970 }, -- Moonlight Crystals
	{ id = 16120, chance = 3709 }, -- Violet Crystal Shard
	{ id = 3370, chance = 3200 }, -- Knight Armor
	{ id = 7436, chance = 1590 }, -- Angelic Axe
	{ id = 43915, chance = 550 }, -- Weretiger Trophy
	{ id = 3041, chance = 670 }, -- Blue Gem
	{ id = 43732, chance = 360 }, -- Silver Moon Coin
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -50, maxDamage = -625 },
	{ name = "energy chain", interval = 3300, chance = 20, minDamage = -175, maxDamage = -375, range = 3, target = true },
	{ name = "combat", interval = 3300, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -375, length = 5, spread = 2, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false },
	{ name = "combat", interval = 2700, chance = 37, type = COMBAT_PHYSICALDAMAGE, minDamage = -175, maxDamage = -325, radius = 1, effect = CONST_ME_BIG_SCRATCH, range = 1, target = true },
}

monster.defenses = {
	defense = 30,
	armor = 76,
	mitigation = 2.16,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
