local mType = Game.createMonsterType("Wandering Pillar")
local monster = {}

monster.description = "a wandering pillar"
monster.experience = 23200
monster.outfit = {
	lookType = 1657,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2395
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

monster.health = 37000
monster.maxHealth = 37000
monster.race = "undead"
monster.corpse = 43828
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
	{ text = "POWERRR!!", yell = false },
	{ text = "DARKNESS. DEATH. ENERGIES.", yell = false },
	{ text = "TREMMMBLE!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 6629, maxCount = 1 },
	{ name = "darklight obsidian axe", chance = 14652, maxCount = 1 },
	{ name = "basalt crumbs", chance = 8184, maxCount = 1 },
	{ name = "sulphurous stone", chance = 5873, maxCount = 1 },
	{ name = "magma boots", chance = 5080, maxCount = 1 },
	{ id = 12600, chance = 9802, maxCount = 4 }, -- coal
	{ name = "dark helmet", chance = 7490, maxCount = 1 },
	{ name = "magma coat", chance = 11753, maxCount = 1 },
	{ name = "onyx chip", chance = 9311, maxCount = 2 },
	{ name = "darklight core", chance = 5957, maxCount = 1 },
	{ name = "fire sword", chance = 8319, maxCount = 1 },
	{ name = "magma clump", chance = 6260, maxCount = 1 },
	{ id = 3039, chance = 9915, maxCount = 1 }, -- red gem
	{ name = "green gem", chance = 12864, maxCount = 1 },
	{ name = "basalt core", chance = 9037, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1200 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -1400, maxDamage = -1650, length = 8, spread = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false },
	{ name = "combat", intervall = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -1100, maxDamage = -1500, radius = 5, effect = CONST_ME_PINK_BEAM, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -1400, maxDamage = -1700, radius = 5, effect = CONST_ME_HITBYFIRE, target = true },
	{ name = "largeholyring", interval = 3000, chance = 15, minDamage = -900, maxDamage = -1250 },
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
