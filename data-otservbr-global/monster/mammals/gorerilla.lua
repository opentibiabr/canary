local mType = Game.createMonsterType("Gorerilla")
local monster = {}

monster.description = "a gorerilla"
monster.experience = 13172
monster.outfit = {
	lookType = 1559,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2277
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Sparkling Pools",
}

monster.health = 16850
monster.maxHealth = 16850
monster.race = "blood"
monster.corpse = 39327
monster.speed = 215
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
	{ text = "Shwooosh!", yell = false },
}

monster.loot = {
	{ name = "Crystal Coin", chance = 20700, minCount = 1, maxCount = 2 },
	{ name = "Gorerilla Mane", chance = 19890 },
	{ name = "Gorerilla Tail", chance = 17060 },
	{ name = "Ultimate Mana Potion", chance = 11210, minCount = 1, maxCount = 3 },
	{ name = "Doublet", chance = 5880 },
	{ name = "Magma Coat", chance = 2440 },
	{ name = "Black Pearl", chance = 500, minCount = 1, maxCount = 2 },
	{ name = "Crystal Crossbow", chance = 110 },
	{ name = "Composite Hornbow", chance = 30 },
	{ name = "Ornate Crossbow", chance = 30 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -950 },
	{ name = "combat", interval = 2200, chance = 60, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -750, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = true },
	{ name = "combat", interval = 3100, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -650, maxDamage = -850, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "gorerilla large ring", interval = 3500, chance = 35, minDamage = -600, maxDamage = -1000 },
	{ name = "gorerilla small ring", interval = 3800, chance = 20, minDamage = -600, maxDamage = -1000 },
}

monster.defenses = {
	defense = 76,
	armor = 76,
	mitigation = 1.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
