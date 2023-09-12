local mType = Game.createMonsterType("Mercurial Menace")
local monster = {}

monster.description = "a mercurial menace"
monster.experience = 12095
monster.outfit = {
	lookType = 1561,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2279
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Crystal Enigma",
}

monster.health = 18500
monster.maxHealth = 18500
monster.race = "blood"
monster.corpse = 39335
monster.speed = 190
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
	{ text = "Shwooo...", yell = false },
}

monster.loot = {
	{ name = "Crystal Coin", chance = 24890, minCount = 1, maxCount = 2 },
	{ name = "Mercurial Wing", chance = 21500 },
	{ name = "Terra Boots", chance = 4250 },
	{ name = "Silver Brooch", chance = 2700 },
	{ name = "Terra Rod", chance = 1660 },
	{ name = "Wand of Defiance", chance = 1230 },
	{ name = "Dream Blossom Staff", chance = 1090 },
	{ name = "Coral Brooch", chance = 1030 },
	{ name = "Lightning Boots", chance = 1000 },
	{ name = "Wand of Cosmic Energy", chance = 860 },
	{ name = "Gemmed Figurine", chance = 830 },
	{ name = "Butterfly Ring", chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 2000, chance = 75, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -750, range = 4, shootEffect = CONST_ANI_SMALLSTONE, target = true },
	{ name = "combat", interval = 3000, chance = 40, type = COMBAT_ENERGYDAMAGE, minDamage = -800, maxDamage = -1500, range = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = true },
	{ name = "mercurial menace ring", interval = 4500, chance = 37, minDamage = -500, maxDamage = -700 },
}

monster.defenses = {
	defense = 110,
	armor = 91,
	mitigation = 2.54,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
