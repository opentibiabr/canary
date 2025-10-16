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
	{ id = 3028, chance = 80000, maxCount = 7 }, -- small diamond
	{ id = 3035, chance = 80000, maxCount = 25 }, -- platinum coin
	{ id = 9057, chance = 80000, maxCount = 3 }, -- small topaz
	{ id = 9640, chance = 80000, maxCount = 9 }, -- poisonous slime
	{ id = 16143, chance = 80000, maxCount = 40 }, -- envenomed arrow
	{ id = 813, chance = 23000 }, -- terra boots
	{ id = 830, chance = 23000 }, -- terra hood
	{ id = 3041, chance = 23000 }, -- blue gem
	{ id = 812, chance = 5000 }, -- terra legs
	{ id = 3081, chance = 5000 }, -- stone skin amulet
	{ id = 3084, chance = 5000 }, -- protection amulet
	{ id = 9302, chance = 5000 }, -- sacred tree amulet
	{ id = 8084, chance = 1000 }, -- springsprout rod
	{ id = 811, chance = 1000 }, -- terra mantle
	{ id = 10422, chance = 1000 }, -- clay lump
	{ id = 814, chance = 260 }, -- terra amulet
	{ id = 8052, chance = 260 }, -- swamplair armor
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
