local mType = Game.createMonsterType("Merlkin")
local monster = {}

monster.description = "a merlkin"
monster.experience = 145
monster.outfit = {
	lookType = 117,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 117
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Banuta, north-east of Port Hope.",
}

monster.health = 235
monster.maxHealth = 235
monster.race = "blood"
monster.corpse = 6044
monster.speed = 97
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 70,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ugh! Ugh! Ugh!", yell = false },
	{ text = "Holy banana!", yell = false },
	{ text = "Chakka! Chakka!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 82969, maxCount = 45 }, -- Gold Coin
	{ id = 3587, chance = 40542, maxCount = 12 }, -- Banana
	{ id = 3046, chance = 3426 }, -- Magic Light Wand
	{ id = 5883, chance = 891 }, -- Ape Fur
	{ id = 11511, chance = 1920 }, -- Banana Sash
	{ id = 268, chance = 592 }, -- Mana Potion
	{ id = 3586, chance = 2548, maxCount = 5 }, -- Orange
	{ id = 3072, chance = 1024 }, -- Wand of Decay
	{ id = 3348, chance = 107 }, -- Banana Staff
	{ id = 3033, chance = 185 }, -- Small Amethyst
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -30 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -60, maxDamage = -90, range = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -15, maxDamage = -45, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "poisonfield", interval = 2000, chance = 15, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 16,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 30, maxDamage = 40, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
