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
	{ id = 3110, chance = 80000 }, -- piece of iron
	{ id = 3116, chance = 80000 }, -- big bone
	{ id = 16123, chance = 80000 }, -- brown crystal splinter
	{ id = 20062, chance = 80000 }, -- cluster of solace
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 16126, chance = 80000 }, -- red crystal fragment
	{ id = 16279, chance = 80000 }, -- crystal rubbish
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 37530, chance = 80000 }, -- bottle of champagne
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 3582, chance = 80000 }, -- ham
	{ id = 11542, chance = 80000 }, -- fish tail
	{ id = 3104, chance = 80000 }, -- banana skin
	{ id = 3111, chance = 80000 }, -- fishbone
	{ id = 7885, chance = 80000 }, -- fish
	{ id = 7573, chance = 80000 }, -- bone
	{ id = 16120, chance = 80000 }, -- violet crystal shard
	{ id = 37468, chance = 80000 }, -- special fx box
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
