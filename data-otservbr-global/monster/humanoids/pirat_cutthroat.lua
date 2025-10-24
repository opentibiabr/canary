local mType = Game.createMonsterType("Pirat Cutthroat")
local monster = {}

monster.description = "a pirat cutthroat"
monster.experience = 1800
monster.outfit = {
	lookType = 1346,
	lookHead = 2,
	lookBody = 96,
	lookLegs = 78,
	lookFeet = 96,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2036
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Darashia, Krailos Steppe, Liberty Bay, Pirat Mines, Port Hope, Thais, The Wreckoning.",
}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 35372
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 1,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
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
	{ id = 239, chance = 20300, maxCount = 4 }, -- Great Health Potion
	{ id = 3284, chance = 12830 }, -- Ice Rapier
	{ id = 3318, chance = 4810 }, -- Knight Axe
	{ id = 7449, chance = 8510 }, -- Crystal Sword
	{ id = 35572, chance = 7060, maxCount = 10 }, -- Pirate Coin
	{ id = 3304, chance = 4650 }, -- Crowbar
	{ id = 3370, chance = 3100 }, -- Knight Armor
	{ id = 8043, chance = 1930 }, -- Focus Cape
	{ id = 35573, chance = 4820 }, -- Pirat's Tail
	{ id = 5704, chance = 4070 }, -- Shark Fin
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -110, maxDamage = -190, length = 4, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -120, maxDamage = -175, radius = 3, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 68,
	armor = 72,
	mitigation = 1.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
