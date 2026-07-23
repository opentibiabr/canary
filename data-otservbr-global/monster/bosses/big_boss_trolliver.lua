local mType = Game.createMonsterType("Big Boss Trolliver")
local monster = {}

monster.description = "Big Boss Trolliver"
monster.experience = 105
monster.outfit = {
	lookType = 281,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 432,
	bossRace = RARITY_NEMESIS,
}

monster.health = 150
monster.maxHealth = 150
monster.race = "blood"
monster.corpse = 861
monster.speed = 95
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 95,
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

monster.summon = {
	maxSummons = 5,
	summons = {
		{ name = "Troll Champion", chance = 30, interval = 2000, count = 5 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Me big nauti! Hehehe!", yell = false },
	{ text = "Frind or day?!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 86000, maxCount = 59 }, -- Gold Coin
	{ id = 3577, chance = 38000 }, -- Meat
	{ id = 3412, chance = 24000 }, -- Wooden Shield
	{ id = 3336, chance = 24000 }, -- Studded Club
	{ id = 3054, chance = 19000 }, -- Silver Amulet
	{ id = 9689, chance = 19000 }, -- Bunch of Troll Hair
	{ id = 3552, chance = 14300 }, -- Leather Boots
	{ id = 3355, chance = 9500 }, -- Leather Helmet
	{ id = 3268, chance = 9500 }, -- Hand Axe
	{ id = 3277, chance = 9500 }, -- Spear
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -45 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
