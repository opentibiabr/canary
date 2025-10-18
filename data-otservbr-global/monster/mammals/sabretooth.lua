local mType = Game.createMonsterType("Sabretooth")
local monster = {}

monster.description = "a sabretooth"
monster.experience = 11931
monster.outfit = {
	lookType = 1549,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2267
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

monster.health = 17300
monster.maxHealth = 17300
monster.race = "blood"
monster.corpse = 39287
monster.speed = 225
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
}

monster.loot = {
	{ id = 3043, chance = 23060, maxCount = 2 }, -- Crystal Coin
	{ id = 39378, chance = 23590 }, -- Sabretooth Fur
	{ id = 826, chance = 3860 }, -- Magma Coat
	{ id = 3071, chance = 4800 }, -- Wand of Inferno
	{ id = 3075, chance = 2360 }, -- Wand of Dragonbreath
	{ id = 3082, chance = 5100 }, -- Elven Amulet
	{ id = 3085, chance = 3890 }, -- Dragon Necklace
	{ id = 3280, chance = 2620 }, -- Fire Sword
	{ id = 9302, chance = 2770 }, -- Sacred Tree Amulet
	{ id = 21169, chance = 2290 }, -- Metal Spats
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100 },
	{ name = "sabretooth wave", interval = 5000, chance = 35, minDamage = -600, maxDamage = -1000 },
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -800, maxDamage = -1500, range = 1, effect = CONST_ME_BIG_SCRATCH, target = true },
	{ name = "combat", interval = 2700, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -1350, range = 1, target = true },
}

monster.defenses = {
	defense = 110,
	armor = 63,
	mitigation = 1.62,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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

RegisterPrimalPackBeast(monster)
