local mType = Game.createMonsterType("Sorcerer's Apparition")
local monster = {}

monster.description = "a sorcerer's apparition"
monster.experience = 28600
monster.outfit = {
	lookType = 138,
	lookHead = 95,
	lookBody = 114,
	lookLegs = 52,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1949
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Mirrored Nightmare.",
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 6081
monster.speed = 235
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I'll take your place when you are gone.", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 79040 },
	{ name = "great mana potion", chance = 62450, maxCount = 3 },
	-- {name = "giant shimmering pearl", chance = 10040}, -- unknown item: giant shimmering pearl
	{ name = "blue gem", chance = 5240 },
	{ id = 23533, chance = 4370 }, -- ring of red plasma
	{ name = "wand of voodoo", chance = 4370 },
	{ id = 23531, chance = 3490 }, -- ring of green plasma
	{ id = 23529, chance = 3060 }, -- ring of blue plasma
	{ name = "violet gem", chance = 2620 },
	{ name = "glacier amulet", chance = 2620 },
	{ name = "wand of everblazing", chance = 2180 },
	{ name = "wand of defiance", chance = 1750 },
	{ name = "wand of starstorm", chance = 1310 },
	{ name = "stone skin amulet", chance = 1310 },
	{ name = "alloy legs", chance = 440 },
	{ id = 34109, chance = 20 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 4000, chance = 26, type = COMBAT_ICEDAMAGE, minDamage = -1080, maxDamage = -1300, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BIGCLOUDS, target = true },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -1100, maxDamage = -1300, radius = 3, effect = CONST_ME_BIGCLOUDS, target = false },
	{ name = "combat", interval = 5000, chance = 34, type = COMBAT_ICEDAMAGE, minDamage = -1100, maxDamage = -1300, range = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BIGCLOUDS, target = true },
	{ name = "ice chain", interval = 9500, chance = 52, minDamage = -1100, maxDamage = -1300, range = 7 },
	{ name = "combat", interval = 3000, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -1100, maxDamage = -1250, range = 7, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "combat", interval = 4000, chance = 19, type = COMBAT_HOLYDAMAGE, minDamage = -1250, maxDamage = -1400, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.74,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
