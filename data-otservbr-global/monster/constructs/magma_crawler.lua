local mType = Game.createMonsterType("Magma Crawler")
local monster = {}

monster.description = "a magma crawler"
monster.experience = 3900
monster.outfit = {
	lookType = 492,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 885
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Warzone 2.",
}

monster.health = 4800
monster.maxHealth = 4800
monster.race = "fire"
monster.corpse = 15991
monster.speed = 230
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
}

monster.strategiesTarget = {
	nearest = 80,
	random = 20,
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
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 5,
	color = 200,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Crrroak!", yell = false },
}

monster.loot = {
	{ name = "small diamond", chance = 8800, maxCount = 3 },
	{ name = "gold coin", chance = 50000, maxCount = 100 },
	{ name = "gold coin", chance = 50000, maxCount = 99 },
	{ name = "platinum coin", chance = 100000, maxCount = 5 },
	{ name = "yellow gem", chance = 1030 },
	{ id = 3051, chance = 1650 }, -- energy ring
	{ name = "black shield", chance = 1550 },
	{ name = "iron ore", chance = 4280 },
	{ id = 5909, chance = 2310 }, -- white piece of cloth
	{ name = "fire axe", chance = 1560 },
	{ name = "firebug", chance = 10000 },
	{ name = "fire mushroom", chance = 10000 },
	{ name = "fire sword", chance = 1710 },
	{ name = "crown shield", chance = 1180 },
	{ id = 3039, chance = 1180 }, -- red gem
	{ name = "red piece of cloth", chance = 930 },
	{ name = "yellow piece of cloth", chance = 2980 },
	{ name = "great mana potion", chance = 6500 },
	{ name = "great health potion", chance = 7270 },
	{ name = "magma amulet", chance = 3120 },
	{ name = "magma boots", chance = 1820 },
	{ name = "wand of draconia", chance = 4280 },
	{ name = "fiery heart", chance = 7810 },
	{ id = 12600, chance = 1675 }, -- coal
	{ name = "crystalline arrow", chance = 5950, maxCount = 10 },
	{ name = "wand of everblazing", chance = 690 },
	{ name = "blue crystal shard", chance = 3930, maxCount = 2 },
	{ name = "brown crystal splinter", chance = 8500, maxCount = 2 },
	{ name = "green crystal fragment", chance = 7000 },
	{ name = "magma clump", chance = 11600 },
	{ name = "blazing bone", chance = 11500 },
	{ name = "blazing bone", chance = 12220 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -203 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -1100, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "magma crawler wave", interval = 2000, chance = 15, minDamage = -290, maxDamage = -800, target = false },
	{ name = "magma crawler soulfire", interval = 2000, chance = 20, target = false },
	{ name = "soulfire rune", interval = 2000, chance = 10, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -140, maxDamage = -180, radius = 3, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -800, radius = 2, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 45,
	armor = 84,
	mitigation = 2.51,
	{ name = "invisible", interval = 2000, chance = 5, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
