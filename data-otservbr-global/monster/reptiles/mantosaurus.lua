local mType = Game.createMonsterType("Mantosaurus")
local monster = {}

monster.description = "a mantosaurus"
monster.experience = 11569
monster.outfit = {
	lookType = 1556,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2274
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

monster.health = 19400
monster.maxHealth = 19400
monster.race = "blood"
monster.corpse = 39315
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
	{ text = "Klkkk... Klkkk...", yell = false },
}

monster.loot = {
	{ id = 3043, chance = 23812, maxCount = 2 }, -- Crystal Coin
	{ id = 16125, chance = 2996 }, -- Cyan Crystal Fragment
	{ id = 39386, chance = 17823 }, -- Mantosaurus Jaw
	{ id = 3017, chance = 5087 }, -- Silver Brooch
	{ id = 3007, chance = 1545 }, -- Crystal Ring
	{ id = 23373, chance = 10033, maxCount = 3 }, -- Ultimate Mana Potion
	{ id = 16121, chance = 2813 }, -- Green Crystal Shard
	{ id = 16126, chance = 3262 }, -- Red Crystal Fragment
	{ id = 24391, chance = 2019 }, -- Coral Brooch
	{ id = 3063, chance = 1285 }, -- Gold Ring
	{ id = 3057, chance = 160 }, -- Amulet of Loss
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000 },
	{ name = "combat", interval = 3500, chance = 47, type = COMBAT_PHYSICALDAMAGE, minDamage = -750, maxDamage = -1100, radius = 4, effect = CONST_ME_YELLOWSMOKE, target = false },
	{ name = "combat", interval = 2500, chance = 31, type = COMBAT_EARTHDAMAGE, minDamage = -550, maxDamage = -800, radius = 4, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "mantosaurus ring", interval = 4000, chance = 25, minDamage = -500, maxDamage = -700, range = 4, target = true },
}

monster.defenses = {
	defense = 110,
	armor = 65,
	mitigation = 1.79,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
