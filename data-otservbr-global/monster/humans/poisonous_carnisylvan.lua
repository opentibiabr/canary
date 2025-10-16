local mType = Game.createMonsterType("Poisonous Carnisylvan")
local monster = {}

monster.description = "a poisonous carnisylvan"
monster.experience = 4400
monster.outfit = {
	lookType = 1418,
	lookHead = 23,
	lookBody = 98,
	lookLegs = 22,
	lookFeet = 61,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2108
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Forest of Life.",
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "blood"
monster.corpse = 36890
monster.speed = 105
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
	targetDistance = 4,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Carnisylvan Sapling", chance = 70, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 17 }, -- platinum coin
	{ id = 3010, chance = 23000 }, -- emerald bangle
	{ id = 34249, chance = 23000 }, -- wooden trash
	{ id = 3315, chance = 23000 }, -- guardian halberd
	{ id = 7642, chance = 23000 }, -- great spirit potion
	{ id = 16103, chance = 23000 }, -- mushroom pie
	{ id = 36805, chance = 23000 }, -- carnisylvan finger
	{ id = 36806, chance = 23000 }, -- carnisylvan bark
	{ id = 3065, chance = 5000 }, -- terra rod
	{ id = 3318, chance = 5000 }, -- knight axe
	{ id = 3731, chance = 5000, maxCount = 3 }, -- fire mushroom
	{ id = 7387, chance = 5000 }, -- diamond sceptre
	{ id = 8082, chance = 5000 }, -- underworld rod
	{ id = 8092, chance = 5000 }, -- wand of starstorm
	{ id = 9302, chance = 5000 }, -- sacred tree amulet
	{ id = 23526, chance = 5000 }, -- collar of blue plasma
	{ id = 24392, chance = 1000 }, -- gemmed figurine
	{ id = 36807, chance = 260 }, -- human teeth
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -520, radius = 4, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -350, maxDamage = -450, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 37,
	armor = 37,
	mitigation = 1.13,
	{ name = "speed", interval = 2000, chance = 8, speedChange = 250, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
