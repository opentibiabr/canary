local mType = Game.createMonsterType("Vemiath")
local monster = {}

monster.description = "Vemiath"
monster.experience = 3250000
monster.outfit = {
	lookType = 1668,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.bosstiary = {
	bossRaceId = 2365,
	bossRace = RARITY_ARCHFOE
}

monster.health = 480000
monster.maxHealth = 480000
monster.runHealth = 0
monster.race = "blood"
monster.corpse = 44022
monster.speed = 222
monster.summonCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "drunk", condition = true},
	{type = "bleed", condition = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.attacks = {
}

monster.defenses = {
	defense = 5,
	armor = 10
}

monster.loot = {
	{ name = "crystal coin", chance = 14816, maxCount = 125 },
	{ name = "ultimate mana potion", chance = 12593, maxCount = 211 },
	{ name = "giant emerald", chance = 9578, maxCount = 1 },
	{ name = "supreme health potion", chance = 14034, maxCount = 179 },
	{ name = "yellow gem", chance = 9632, maxCount = 5 },
	{ name = "berserk potion", chance = 10509, maxCount = 45 },
	{ name = "blue gem", chance = 10106, maxCount = 5 },
	{ name = "green gem", chance = 11715, maxCount = 4 },
	{ name = "bullseye potion", chance = 6199, maxCount = 26 },
	{ name = "mastermind potion", chance = 10603, maxCount = 44 },
	{ name = "ultimate spirit potion", chance = 12789, maxCount = 25 },
	{ name = "giant topaz", chance = 13024, maxCount = 1 },
	{ name = "giant amethyst", chance = 10998, maxCount = 1 },
	{ name = "gold ingot", chance = 12055, maxCount = 1 },
	{ id = 3039, chance = 13346, maxCount = 1 }, -- red gem
	{ name = "dragon figurine", chance = 5573, maxCount = 1 },
	{ name = "raw watermelon tourmaline", chance = 8035, maxCount = 1 },
	{ name = "vemiath's infused basalt", chance = 9923, maxCount = 1 },
	{ name = "violet gem", chance = 10812, maxCount = 1 },
}

mType:register(monster)
