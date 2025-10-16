local mType = Game.createMonsterType("Tremendous Tyrant")
local monster = {}

monster.description = "a tremendous tyrant"
monster.experience = 6100
monster.outfit = {
	lookType = 1396,
	lookHead = 60,
	lookBody = 84,
	lookLegs = 40,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2089
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Dwelling of the Forgotten",
}

monster.health = 11500
monster.maxHealth = 11500
monster.race = "blood"
monster.corpse = 36684
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 10,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 3,
	color = 106,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 28 }, -- platinum coin
	{ id = 36706, chance = 23000 }, -- red gem
	{ id = 9058, chance = 23000 }, -- gold ingot
	{ id = 16119, chance = 23000 }, -- blue crystal shard
	{ id = 16120, chance = 23000 }, -- violet crystal shard
	{ id = 16121, chance = 23000 }, -- green crystal shard
	{ id = 36784, chance = 23000 }, -- tremendous tyrant shell
	{ id = 822, chance = 5000 }, -- lightning legs
	{ id = 824, chance = 5000 }, -- glacier robe
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 3067, chance = 5000 }, -- hailstorm rod
	{ id = 3073, chance = 5000 }, -- wand of cosmic energy
	{ id = 3082, chance = 5000 }, -- elven amulet
	{ id = 3284, chance = 5000 }, -- ice rapier
	{ id = 3318, chance = 5000 }, -- knight axe
	{ id = 7430, chance = 5000 }, -- dragonbone staff
	{ id = 8043, chance = 5000 }, -- focus cape
	{ id = 8073, chance = 5000 }, -- spellbook of warding
	{ id = 8092, chance = 5000 }, -- wand of starstorm
	{ id = 14042, chance = 5000 }, -- warriors shield
	{ id = 36783, chance = 5000 }, -- tremendous tyrant head
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -650, length = 5, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -600, maxDamage = -700, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = false }, -- avalanche
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -750, maxDamage = -950, range = 5, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYAREA, target = true },
}

monster.defenses = {
	defense = 71,
	armor = 71,
	mitigation = 1.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
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
