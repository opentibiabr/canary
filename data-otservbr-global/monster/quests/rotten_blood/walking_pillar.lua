local mType = Game.createMonsterType("Walking Pillar")
local monster = {}

monster.description = "a walking pillar"
monster.experience = 24300
monster.outfit = {
	lookType = 1656,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2394
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Darklight Core",
}

monster.health = 38000
monster.maxHealth = 38000
monster.race = "undead"
monster.corpse = 43824
monster.speed = 190
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 50,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "TREEMBLE", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 51831 }, -- Crystal Coin
	{ id = 43780, chance = 15387 }, -- Yellow Darklight Matter
	{ id = 16130, chance = 8805 }, -- Magma Clump
	{ id = 43853, chance = 6684 }, -- Darklight Core (Object)
	{ id = 12600, chance = 8850, maxCount = 4 }, -- Coal
	{ id = 43852, chance = 9228 }, -- Darklight Basalt Chunk
	{ id = 22193, chance = 5009, maxCount = 2 }, -- Onyx Chip
	{ id = 3373, chance = 3481 }, -- Strange Helmet
	{ id = 3280, chance = 3849 }, -- Fire Sword
	{ id = 23373, chance = 3247, maxCount = 3 }, -- Ultimate Mana Potion
	{ id = 3041, chance = 796 }, -- Blue Gem
	{ id = 821, chance = 475 }, -- Magma Legs
	{ id = 32769, chance = 299 }, -- White Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1500 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -1400, maxDamage = -1650, length = 8, spread = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false },
	{ name = "combat", intervall = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -1500, maxDamage = -1800, radius = 5, effect = CONST_ME_PURPLESMOKE, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -1200, maxDamage = -1200, radius = 5, effect = CONST_ME_GHOSTLY_BITE, target = true },
	{ name = "extended energy chain", interval = 2000, chance = 5, minDamage = -800, maxDamage = 1200, target = true },
	{ name = "largepinkring", interval = 3500, chance = 10, minDamage = -1100, maxDamage = -1600, target = false },
}

monster.defenses = {
	defense = 120,
	armor = 120,
	mitigation = 2.75,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 60 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 45 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
