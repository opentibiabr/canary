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
	{ id = 3043, chance = 80000, maxCount = 2 }, -- crystal coin
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 39386, chance = 23000 }, -- mantosaurus jaw
	{ id = 3017, chance = 5000 }, -- silver brooch
	{ id = 6093, chance = 5000 }, -- crystal ring
	{ id = 23373, chance = 5000, maxCount = 3 }, -- ultimate mana potion
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 16126, chance = 5000 }, -- red crystal fragment
	{ id = 24391, chance = 5000 }, -- coral brooch
	{ id = 3063, chance = 5000 }, -- gold ring
	{ id = 3057, chance = 260 }, -- amulet of loss
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
