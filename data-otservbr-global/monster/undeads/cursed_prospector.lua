local mType = Game.createMonsterType("Cursed Prospector")
local monster = {}

monster.description = "a cursed prospector"
monster.experience = 5250
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 19,
	lookLegs = 0,
	lookFeet = 38,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1880
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Barren Drift.",
}

monster.health = 3900
monster.maxHealth = 3900
monster.race = "undead"
monster.corpse = 32610
monster.speed = 210
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
	{ id = 761, chance = 19387, maxCount = 5 }, -- Flash Arrow
	{ id = 32725, chance = 10418 }, -- Spectral Silver Nugget
	{ id = 7642, chance = 18406, maxCount = 2 }, -- Great Spirit Potion
	{ id = 32724, chance = 4493 }, -- Spectral Gold Nugget
	{ id = 3010, chance = 910 }, -- Emerald Bangle
	{ id = 820, chance = 900 }, -- Lightning Boots
	{ id = 3081, chance = 3751 }, -- Stone Skin Amulet
	{ id = 32770, chance = 1057 }, -- Diamond
	{ id = 825, chance = 925 }, -- Lightning Robe
	{ id = 822, chance = 977 }, -- Lightning Legs
	{ id = 9304, chance = 572 }, -- Shockwave Amulet
	{ id = 3082, chance = 737 }, -- Elven Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 1700, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -550, radius = 3, shootEffect = CONST_ANI_ENVENOMEDARROW, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 1700, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -150, maxDamage = -550, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 1700, chance = 35, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -550, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1700, chance = 35, type = COMBAT_HOLYDAMAGE, minDamage = -250, maxDamage = -550, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -550, range = 4, radius = 4, effect = CONST_ME_ENERGYAREA, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 85,
	mitigation = 2.40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 60 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
