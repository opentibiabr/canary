local mType = Game.createMonsterType("Lucifuga Aranea")
local monster = {}

monster.description = "a lucifuga aranea"
monster.experience = 10000
monster.outfit = {
	lookType = 263,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 12000
monster.maxHealth = 12000
monster.race = "undead"
monster.corpse = 7344
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	canPushCreatures = false,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 5,
	color = 107,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 29348, chance = 80000 }, -- poison gland
	{ id = 3315, chance = 80000 }, -- guardian halberd
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 7449, chance = 80000 }, -- crystal sword
	{ id = 16119, chance = 80000 }, -- blue crystal shard
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 3269, chance = 80000 }, -- halberd
	{ id = 3357, chance = 80000 }, -- plate armor
	{ id = 16125, chance = 80000 }, -- cyan crystal fragment
	{ id = 3053, chance = 80000 }, -- time ring
	{ id = 3008, chance = 80000 }, -- crystal necklace
	{ id = 3313, chance = 80000 }, -- obsidian lance
	{ id = 7741, chance = 80000 }, -- ice cube
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, condition = { type = CONDITION_POISON, totalDamage = 160, interval = 4000 } },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -800, range = 7, radius = 6, effect = CONST_ME_POFF, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -50, maxDamage = -100, range = 7, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, range = 7, shootEffect = CONST_ANI_SNOWBALL, target = true, duration = 10000 },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 250, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
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
