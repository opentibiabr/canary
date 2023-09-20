local mType = Game.createMonsterType("Undertaker")
local monster = {}

monster.description = "an undertaker"
monster.experience = 13543
monster.outfit = {
	lookType = 1551,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2269
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Monster Graveyard",
}

monster.health = 20100
monster.maxHealth = 20100
monster.race = "venom"
monster.corpse = 39295
monster.speed = 205
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
	{ text = "Hizzzzz!", yell = false },
}

monster.loot = {
	{ name = "Great Spirit Potion", chance = 30660, minCount = 1, maxCount = 3 },
	{ name = "Undertaker Fangs", chance = 25740 },
	{ name = "Crystal Coin", chance = 15100, minCount = 1, maxCount = 3 },
	{ name = "Spider Silk", chance = 3520 },
	{ name = "Terra Boots", chance = 3390 },
	{ name = "Blue Crystal Shard", chance = 1840 },
	{ name = "Relic Sword", chance = 1650 },
	{ name = "Terra Legs", chance = 1640 },
	{ name = "Necrotic Rod", chance = 1400 },
	{ name = "Butterfly Ring", chance = 1240 },
	{ name = "Wand of Voodoo", chance = 960 },
	{ name = "Violet Gem", chance = 850 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1200 },
	{ name = "combat", interval = 4500, chance = 47, type = COMBAT_DEATHDAMAGE, minDamage = -800, maxDamage = -1150, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 3650, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -600, maxDamage = -950, radius = 2, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "undertaker square explosion", interval = 3000, chance = 25, minDamage = -775, maxDamage = -900, range = 4, target = true },
	{ name = "combat", interval = 5000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -1500, maxDamage = -2000, range = 1, radius = 1, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "root wave", interval = 2000, chance = 5, target = true },
}

monster.defenses = {
	defense = 110,
	armor = 77,
	mitigation = 2.22,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
