local mType = Game.createMonsterType("Harpy")
local monster = {}

monster.description = "a harpy"
monster.experience = 5720
monster.outfit = {
	lookType = 1604,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2340
monster.Bestiary = {
	class = "Bird",
	race = BESTY_RACE_BIRD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Ingol",
}

monster.health = 7700
monster.maxHealth = 7700
monster.race = "blood"
monster.corpse = 42222
monster.speed = 175
monster.manaCost = 0

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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 3,
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
	{ text = "Blood will flow!", yell = false },
	{ text = "Shriek!", yell = false },
	{ text = "Screech!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 74985 }, -- Platinum Coin
	{ id = 40585, chance = 6511 }, -- Harpy Feathers
	{ id = 16119, chance = 5645 }, -- Blue Crystal Shard
	{ id = 16120, chance = 5120 }, -- Violet Crystal Shard
	{ id = 3063, chance = 2589 }, -- Gold Ring
	{ id = 7642, chance = 2347 }, -- Great Spirit Potion
	{ id = 16096, chance = 1535 }, -- Wand of Defiance
	{ id = 14247, chance = 1393 }, -- Ornate Crossbow
	{ id = 3036, chance = 2690 }, -- Violet Gem
	{ id = 8043, chance = 893 }, -- Focus Cape
	{ id = 3366, chance = 674 }, -- Magic Plate Armor
	{ id = 9304, chance = 777 }, -- Shockwave Amulet
	{ id = 16160, chance = 213 }, -- Crystalline Sword
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -345 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -296, maxDamage = -350, range = 3, effect = CONST_ME_BIG_SCRATCH, target = true },
	{ name = "energy ring", interval = 2000, chance = 20, minDamage = -280, maxDamage = -350 },
	{ name = "energy chain", interval = 2000, chance = 20, minDamage = -155, maxDamage = -249, range = 3, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -310, maxDamage = -405, length = 5, spread = 3, effect = CONST_ME_SOUND_BLUE, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -320, maxDamage = -420, range = 7, radius = 4, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -425, maxDamage = -545, effect = CONST_ME_POISON, target = true },
}

monster.defenses = {
	defense = 50,
	armor = 58,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
