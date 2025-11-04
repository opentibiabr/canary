local mType = Game.createMonsterType("Bullwark")
local monster = {}

monster.description = "Bullwark"
monster.experience = 22000
monster.outfit = {
	lookType = 607,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1060,
	bossRace = RARITY_BANE,
}

monster.health = 72000
monster.maxHealth = 72000
monster.race = "blood"
monster.corpse = 20996
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 3,
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
	{ id = 3031, chance = 100000, maxCount = 375 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 9 }, -- Platinum Coin
	{ id = 3582, chance = 53939, maxCount = 9 }, -- Ham
	{ id = 3577, chance = 46060, maxCount = 9 }, -- Meat
	{ id = 239, chance = 26666, maxCount = 9 }, -- Great Health Potion
	{ id = 238, chance = 34355, maxCount = 9 }, -- Great Mana Potion
	{ id = 7642, chance = 39877, maxCount = 9 }, -- Great Spirit Potion
	{ id = 5878, chance = 100000 }, -- Minotaur Leather
	{ id = 21200, chance = 100000, maxCount = 3 }, -- Moohtant Horn
	{ id = 3028, chance = 14110, maxCount = 9 }, -- Small Diamond
	{ id = 3032, chance = 14723, maxCount = 9 }, -- Small Emerald
	{ id = 3030, chance = 16564, maxCount = 9 }, -- Small Ruby
	{ id = 3029, chance = 13496, maxCount = 9 }, -- Small Sapphire
	{ id = 21199, chance = 100000 }, -- Giant Pacifier
	{ id = 21166, chance = 7878 }, -- Mooh'tah Plate
	{ id = 21173, chance = 1000 }, -- Moohtant Cudgel
	{ id = 5911, chance = 5521 }, -- Red Piece of Cloth
	{ id = 3037, chance = 3680 }, -- Yellow Gem
	{ id = 21219, chance = 1840 }, -- One Hit Wonder
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 180, attack = 200 },
	{ name = "combat", interval = 2000, chance = 19, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -400, radius = 6, effect = CONST_ME_MAGIC_RED, target = false },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 9, minDamage = -400, maxDamage = -600, radius = 8, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -400, range = 7, radius = 6, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -400, range = 7, radius = 4, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{ name = "bullwark paralyze", interval = 2000, chance = 6, target = false },
}

monster.defenses = {
	defense = 66,
	armor = 48,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 1, type = COMBAT_HEALING, minDamage = 4000, maxDamage = 6000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 11, speedChange = 660, effect = CONST_ME_HITAREA, target = false, duration = 7000 },
	{ name = "bullwark summon", interval = 2000, chance = 9, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
