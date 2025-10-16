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
	{ id = 3031, chance = 80000, maxCount = 64 }, -- gold coin
	{ id = 3577, chance = 80000, maxCount = 3 }, -- meat
	{ id = 3277, chance = 80000 }, -- spear
	{ id = 3336, chance = 80000 }, -- studded club
	{ id = 3552, chance = 80000 }, -- leather boots
	{ id = 3054, chance = 80000 }, -- silver amulet
	{ id = 9689, chance = 80000 }, -- bunch of troll hair
	{ id = 3268, chance = 80000 }, -- hand axe
	{ id = 3412, chance = 80000 }, -- wooden shield
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
