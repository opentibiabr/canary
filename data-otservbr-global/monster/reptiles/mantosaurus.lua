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
	{ name = "Crystal Coin", chance = 25640, minCount = 1, maxCount = 2 },
	{ name = "Mantosaurus Jaw", chance = 19120 },
	{ name = "Ultimate Mana Potion", chance = 9660, minCount = 1, maxCount = 3 },
	{ name = "Silver Brooch", chance = 3920 },
	{ name = "Red Crystal Fragment", chance = 3570 },
	{ name = "Cyan Crystal Fragment", chance = 3010 },
	{ name = "Green Crystal Shard", chance = 3010 },
	{ name = "Coral Brooch", chance = 2420 },
	{ id = 3007, chance = 1430 }, -- Crystal Ring
	{ name = "Gold Ring", chance = 1370 },
	{ name = "Amulet of Loss", chance = 170 },
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
