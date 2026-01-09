local mType = Game.createMonsterType("Turbulent Elemental")
local monster = {}

monster.description = "a turbulent elemental"
monster.experience = 19360
monster.outfit = {
	lookType = 1314,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1940
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Ebb and Flow.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "blood"
monster.corpse = 33905
monster.speed = 180
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
}

monster.loot = {
	{ id = 3043, chance = 48079 }, -- Crystal Coin
	{ id = 7643, chance = 14087 }, -- Ultimate Health Potion
	{ id = 9058, chance = 16103 }, -- Gold Ingot
	{ id = 815, chance = 2047 }, -- Glacier Amulet
	{ id = 824, chance = 1272 }, -- Glacier Robe
	{ id = 3036, chance = 3629 }, -- Violet Gem
	{ id = 3041, chance = 3286 }, -- Blue Gem
	{ id = 3575, chance = 934 }, -- Wood Cape
	{ id = 8083, chance = 2446 }, -- Northwind Rod
	{ id = 8084, chance = 4031 }, -- Springsprout Rod
	{ id = 9302, chance = 3159 }, -- Sacred Tree Amulet
	{ id = 3081, chance = 820 }, -- Stone Skin Amulet
	{ id = 21165, chance = 659 }, -- Rubber Cap
	{ id = 22085, chance = 537 }, -- Fur Armor
	{ id = 3048, chance = 250 }, -- Might Ring
	{ id = 8050, chance = 459 }, -- Crystalline Armor
	{ id = 34109, chance = 1000 }, -- Bag You Desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -900, maxDamage = -1350, range = 7, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_ICEATTACK, target = true },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -700, maxDamage = -1000, range = 7, shootEffect = CONST_ANI_HUNTINGSPEAR, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 4000, chance = 24, type = COMBAT_ICEDAMAGE, minDamage = -950, maxDamage = -1260, radius = 4, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_ICEDAMAGE, minDamage = -950, maxDamage = -1260, radius = 4, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -950, maxDamage = -1100, length = 5, radius = 2, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "soulwars fear", interval = 2000, chance = 1, target = true },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	mitigation = 2.72,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
