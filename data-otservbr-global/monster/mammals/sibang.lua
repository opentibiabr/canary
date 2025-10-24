local mType = Game.createMonsterType("Sibang")
local monster = {}

monster.description = "a sibang"
monster.experience = 105
monster.outfit = {
	lookType = 118,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 118
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "In Banuta, north-east of Port Hope.",
}

monster.health = 225
monster.maxHealth = 225
monster.race = "blood"
monster.corpse = 6045
monster.speed = 107
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
	{ text = "Eeeeek! Eeeeek!", yell = false },
	{ text = "Huh! Huh! Huh!", yell = false },
	{ text = "Ahhuuaaa!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 88779, maxCount = 35 }, -- Gold Coin
	{ id = 3587, chance = 46795, maxCount = 12 }, -- Banana
	{ id = 3586, chance = 53247, maxCount = 5 }, -- Orange
	{ id = 1781, chance = 53141, maxCount = 3 }, -- Small Stone
	{ id = 11511, chance = 4950 }, -- Banana Sash
	{ id = 5883, chance = 1005 }, -- Ape Fur
	{ id = 3589, chance = 10489, maxCount = 3 }, -- Coconut
	{ id = 3593, chance = 2295 }, -- Melon
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -40 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -55, range = 7, shootEffect = CONST_ANI_SMALLSTONE, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 0.83,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 380, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
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
