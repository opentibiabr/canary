local mType = Game.createMonsterType("Animated Guzzlemaw")
local monster = {}

monster.description = "an animated guzzlemaw"
monster.experience = 5500
monster.outfit = {
	lookType = 584,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6400
monster.maxHealth = 6400
monster.race = "blood"
monster.corpse = 20151
monster.speed = 135
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
	staticAttackChance = 80,
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
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 6 }, -- Platinum Coin
	{ id = 16123, chance = 11110 }, -- Brown Crystal Splinter
	{ id = 238, chance = 18520, maxCount = 2 }, -- Great Mana Potion
	{ id = 5951, chance = 7410 }, -- Fish Tail
	{ id = 3111, chance = 3700 }, -- Fishbone
	{ id = 20199, chance = 14810 }, -- Frazzle Skin
	{ id = 3114, chance = 7410 }, -- Skull (Item)
	{ id = 7407, chance = 7410 }, -- Haunted Blade
	{ id = 3582, chance = 14810 }, -- Ham
	{ id = 20198, chance = 18520 }, -- Frazzle Tongue
	{ id = 3578, chance = 11110 }, -- Fish
	{ id = 3125, chance = 11110 }, -- Remains of a Fish
	{ id = 3115, chance = 3700 }, -- Bone
	{ id = 16120, chance = 7410 }, -- Violet Crystal Shard
	{ id = 16126, chance = 7410 }, -- Red Crystal Fragment
	{ id = 239, chance = 7410 }, -- Great Health Potion
	{ id = 5925, chance = 18520 }, -- Hardened Bone
	{ id = 3110, chance = 11110 }, -- Piece of Iron
	{ id = 3104, chance = 3700 }, -- Banana Skin
	{ id = 16279, chance = 18520 }, -- Crystal Rubbish
	{ id = 3116, chance = 3700 }, -- Big Bone
	{ id = 5880, chance = 7410 }, -- Iron Ore
	{ id = 5895, chance = 3700 }, -- Fish Fin
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -499 },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 10, minDamage = -500, maxDamage = -1000, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -900, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -500, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -800, radius = 6, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -800, length = 8, spread = 0, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_HITBYPOISON, target = false },
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
