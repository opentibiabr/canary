local mType = Game.createMonsterType("Memory of a Frazzlemaw")
local monster = {}

monster.description = "a memory of a frazzlemaw"
monster.experience = 1810
monster.outfit = {
	lookType = 594,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3770
monster.maxHealth = 3770
monster.race = "blood"
monster.corpse = 20233
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	canWalkOnPoison = true,
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
	{ id = 3031, chance = 82000, maxCount = 99 }, -- Gold Coin
	{ id = 239, chance = 21000, maxCount = 2 }, -- Great Health Potion
	{ id = 3111, chance = 14700 }, -- Fishbone
	{ id = 16123, chance = 11800 }, -- Brown Crystal Splinter
	{ id = 3116, chance = 8800 }, -- Big Bone
	{ id = 5951, chance = 8800 }, -- Fish Tail
	{ id = 3104, chance = 8800 }, -- Banana Skin
	{ id = 16279, chance = 5900 }, -- Crystal Rubbish
	{ id = 238, chance = 5900, maxCount = 2 }, -- Great Mana Potion
	{ id = 3110, chance = 2900 }, -- Piece of Iron
	{ id = 3582, chance = 2900 }, -- Ham
	{ id = 3115, chance = 2900 }, -- Bone
	{ id = 9058, chance = 2900 }, -- Gold Ingot
	{ id = 16126, chance = 2900 }, -- Red Crystal Fragment
	{ id = 20062, chance = 290 }, -- Cluster of Solace
	{ id = 37530, chance = 2050 }, -- Bottle of Champagne
	{ id = 3578, chance = 5870 }, -- Fish
	{ id = 16120, chance = 2640 }, -- Violet Crystal Shard
	{ id = 37468, chance = 290 }, -- Special Fx Box
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 10, minDamage = -50, maxDamage = -120, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -110, length = 5, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -80, maxDamage = -150, radius = 4, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 1.40,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_HITBYPOISON, target = false },
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
