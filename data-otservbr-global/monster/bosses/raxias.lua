local mType = Game.createMonsterType("Raxias")
local monster = {}

monster.description = "a raxias"
monster.experience = 900
monster.outfit = {
	lookType = 980,
	lookHead = 79,
	lookBody = 95,
	lookLegs = 81,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "blood"
monster.corpse = 25814
monster.speed = 25
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1624,
	bossRace = RARITY_NEMESIS,
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
	{ text = "This is a nightmare and you won't wake up!", yell = false },
	{ text = "This was your last chance!", yell = false },
	{ text = "Blood, fight and rage!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 140 }, -- Gold Coin
	{ id = 25735, chance = 14400, maxCount = 8 }, -- Leaf Star
	{ id = 25694, chance = 11100 }, -- Fairy Wings
	{ id = 236, chance = 10000, maxCount = 2 }, -- Strong Health Potion
	{ id = 25693, chance = 7800 }, -- Shimmering Beetles
	{ id = 24383, chance = 5600, maxCount = 2 }, -- Cave Turnip
	{ id = 1781, chance = 5600, maxCount = 4 }, -- Small Stone
	{ id = 3728, chance = 5600, maxCount = 2 }, -- Dark Mushroom
	{ id = 24962, chance = 4400 }, -- Prismatic Quartz
	{ id = 239, chance = 4400 }, -- Great Health Potion
	{ id = 3674, chance = 3300 }, -- Goat Grass
	{ id = 675, chance = 3300, maxCount = 2 }, -- Small Enchanted Sapphire
	{ id = 3575, chance = 3300 }, -- Wood Cape
	{ id = 2953, chance = 2200 }, -- Panpipes
	{ id = 9014, chance = 1100 }, -- Leaf Legs
	{ id = 236, chance = 1100, maxCount = 2 }, -- Strong Health Potion
	{ id = 236, chance = 1100 }, -- Strong Health Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -180, range = 7, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -175, length = 3, spread = 3, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
