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
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 16123, chance = 80000 }, -- brown crystal splinter
	{ id = 238, chance = 80000, maxCount = 2 }, -- great mana potion
	{ id = 11542, chance = 80000 }, -- fish tail
	{ id = 3111, chance = 80000 }, -- fishbone
	{ id = 20199, chance = 80000 }, -- frazzle skin
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 3582, chance = 80000 }, -- ham
	{ id = 20198, chance = 80000 }, -- frazzle tongue
	{ id = 7885, chance = 80000 }, -- fish
	{ id = 3125, chance = 80000 }, -- remains of a fish
	{ id = 7573, chance = 80000 }, -- bone
	{ id = 16120, chance = 80000 }, -- violet crystal shard
	{ id = 16126, chance = 80000 }, -- red crystal fragment
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 5925, chance = 80000 }, -- hardened bone
	{ id = 3110, chance = 80000 }, -- piece of iron
	{ id = 3104, chance = 80000 }, -- banana skin
	{ id = 16279, chance = 80000 }, -- crystal rubbish
	{ id = 3116, chance = 80000 }, -- big bone
	{ id = 5880, chance = 80000 }, -- iron ore
	{ id = 5895, chance = 80000 }, -- fish fin
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
