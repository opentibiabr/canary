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
	{ name = "crystal coin", chance = 12186, maxCount = 1 },
	{ name = "yellow darklight matter", chance = 5354, maxCount = 1 },
	{ name = "magma clump", chance = 11440, maxCount = 1 },
	{ name = "darklight core", chance = 10276, maxCount = 1 },
	{ id = 12600, chance = 8489, maxCount = 4 }, -- coal
	{ name = "darklight basalt chunk", chance = 12855, maxCount = 1 },
	{ name = "onyx chip", chance = 12831, maxCount = 2 },
	{ name = "strange helmet", chance = 11001, maxCount = 1 },
	{ name = "fire sword", chance = 8347, maxCount = 1 },
	{ name = "ultimate mana potion", chance = 9687, maxCount = 3 },
	{ name = "blue gem", chance = 5868, maxCount = 1 },
	{ name = "magma legs", chance = 14497, maxCount = 1 },
	{ name = "white gem", chance = 9936, maxCount = 1 },
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
