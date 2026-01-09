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
	{ id = 3035, chance = 83348, maxCount = 17 }, -- Platinum Coin
	{ id = 3010, chance = 6861 }, -- Emerald Bangle
	{ id = 3135, 3136, 3137, 3138, 3139, 3140, chance = 7101 }, -- Wooden Trash
	{ id = 3315, chance = 5659 }, -- Guardian Halberd
	{ id = 7642, chance = 6515 }, -- Great Spirit Potion
	{ id = 16103, chance = 8155 }, -- Mushroom Pie
	{ id = 36805, chance = 7872 }, -- Carnisylvan Finger
	{ id = 36806, chance = 10540 }, -- Carnisylvan Bark
	{ id = 281, chance = 1609 }, -- Giant Shimmering Pearl (Green)
	{ id = 3065, chance = 4159 }, -- Terra Rod
	{ id = 3318, chance = 3665 }, -- Knight Axe
	{ id = 3731, chance = 3452, maxCount = 3 }, -- Fire Mushroom
	{ id = 7387, chance = 3691 }, -- Diamond Sceptre
	{ id = 8082, chance = 3643 }, -- Underworld Rod
	{ id = 8092, chance = 3218 }, -- Wand of Starstorm
	{ id = 9302, chance = 2075 }, -- Sacred Tree Amulet
	{ id = 23526, chance = 4615 }, -- Collar of Blue Plasma
	{ id = 24392, chance = 787 }, -- Gemmed Figurine
	{ id = 36807, chance = 256 }, -- Human Teeth
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
