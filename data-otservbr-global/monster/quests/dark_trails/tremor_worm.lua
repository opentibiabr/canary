local mType = Game.createMonsterType("Tremor Worm")
local monster = {}

monster.description = "a tremor worm"
monster.experience = 80000
monster.outfit = {
	lookType = 295,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 125000
monster.maxHealth = 125000
monster.race = "blood"
monster.corpse = 0
monster.speed = 85
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	{ id = 239, chance = 100000, maxCount = 17 }, -- Great Health Potion
	{ id = 3035, chance = 100000, maxCount = 37 }, -- Platinum Coin
	{ id = 238, chance = 100000, maxCount = 23 }, -- Great Mana Potion
	{ id = 7643, chance = 100000, maxCount = 16 }, -- Ultimate Health Potion
	{ id = 21203, chance = 86000, maxCount = 3 }, -- Glooth Bag
	{ id = 3031, chance = 71000, maxCount = 153 }, -- Gold Coin
	{ id = 16125, chance = 57000 }, -- Cyan Crystal Fragment
	{ id = 16127, chance = 43000 }, -- Green Crystal Fragment
	{ id = 3037, chance = 29000 }, -- Yellow Gem
	{ id = 3028, chance = 29000, maxCount = 8 }, -- Small Diamond
	{ id = 3098, chance = 29000 }, -- Ring of Healing
	{ id = 16126, chance = 29000 }, -- Red Crystal Fragment
	{ id = 3030, chance = 14300 }, -- Small Ruby
	{ id = 3081, chance = 14300 }, -- Stone Skin Amulet
	{ id = 3053, chance = 14300 }, -- Time Ring
	{ id = 3039, chance = 14300 }, -- Red Gem
	{ id = 21164, chance = 14300 }, -- Glooth Cape
	{ id = 21902, chance = 14300 }, -- Glooth Glider Crank
	{ id = 16120, chance = 14300, maxCount = 3 }, -- Violet Crystal Shard
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -0, maxDamage = -400 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 75 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 75 },
	{ type = COMBAT_EARTHDAMAGE, percent = 75 },
	{ type = COMBAT_FIREDAMAGE, percent = 75 },
	{ type = COMBAT_LIFEDRAIN, percent = 75 },
	{ type = COMBAT_MANADRAIN, percent = 75 },
	{ type = COMBAT_DROWNDAMAGE, percent = 75 },
	{ type = COMBAT_ICEDAMAGE, percent = 75 },
	{ type = COMBAT_HOLYDAMAGE, percent = 75 },
	{ type = COMBAT_DEATHDAMAGE, percent = 75 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
