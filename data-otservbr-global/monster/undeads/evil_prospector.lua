local mType = Game.createMonsterType("Evil Prospector")
local monster = {}

monster.description = "an evil prospector"
monster.experience = 9000
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 14,
	lookLegs = 0,
	lookFeet = 34,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1885
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Barren Drift",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "undead"
monster.corpse = 32610
monster.speed = 220
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
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 8092, chance = 10474 }, -- Wand of Starstorm
	{ id = 32725, chance = 10737 }, -- Spectral Silver Nugget
	{ id = 816, chance = 3546 }, -- Lightning Pendant
	{ id = 828, chance = 2907 }, -- Lightning Headband
	{ id = 3010, chance = 3879 }, -- Emerald Bangle
	{ id = 3045, chance = 3243 }, -- Strange Talisman
	{ id = 16096, chance = 2546 }, -- Wand of Defiance
	{ id = 3081, chance = 3238 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500 },
	{ name = "combat", interval = 1700, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -250, maxDamage = -550, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 1700, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -550, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1700, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -550, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1700, chance = 35, type = COMBAT_HOLYDAMAGE, minDamage = -250, maxDamage = -400, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 1700, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -450, range = 4, radius = 4, effect = CONST_ME_ENERGYAREA, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 100,
	mitigation = 2.81,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 65 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 35 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
