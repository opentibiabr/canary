local mType = Game.createMonsterType("The Percht Queen")
local monster = {}

monster.description = "The Percht Queen"
monster.experience = 500
monster.outfit = {
	lookTypeEx = 30340, -- (frozen) // lookTypeEx = 30341 (thawed)
}

monster.bosstiary = {
	bossRaceId = 1744,
	bossRace = RARITY_NEMESIS,
}

monster.health = 2300
monster.maxHealth = 2300
monster.race = "undead"
monster.corpse = 30272
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
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
}

monster.loot = {
	{ id = 23526, chance = 100000 }, -- Collar of Blue Plasma
	{ id = 3035, chance = 100000, maxCount = 2 }, -- Platinum Coin
	{ id = 25759, chance = 100000, maxCount = 35 }, -- Royal Star
	{ id = 23375, chance = 100000, maxCount = 30 }, -- Supreme Health Potion
	{ id = 49271, chance = 100000, maxCount = 8 }, -- Transcendence Potion
	{ id = 2995, chance = 100000 }, -- Piggy Bank
	{ id = 30283, chance = 100000 }, -- Ice Hatchet
	{ id = 23509, chance = 100000 }, -- Mysterious Remains
	{ id = 23535, chance = 100000 }, -- Energy Bar
	{ id = 3038, chance = 100000 }, -- Green Gem
	{ id = 3037, chance = 100000, maxCount = 2 }, -- Yellow Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -200, range = 7, shootEffect = CONST_ANI_ICE, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 79,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 90 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 80 },
	{ type = COMBAT_DEATHDAMAGE, percent = 90 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
