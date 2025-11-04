local mType = Game.createMonsterType("Brutus Bloodbeard")
local monster = {}

monster.description = "Brutus Bloodbeard"
monster.experience = 795
monster.outfit = {
	lookType = 98,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1555
monster.maxHealth = 1555
monster.race = "blood"
monster.corpse = 18197
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	rewardBoss = true,
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
	{ id = 3031, chance = 100000, maxCount = 200 }, -- Gold Coin
	{ id = 6099, chance = 100000 }, -- Brutus Bloodbeard's Hat
	{ id = 3114, chance = 71430 }, -- Skull (Item)
	{ id = 3577, chance = 44441 }, -- Meat
	{ id = 3357, chance = 52943 }, -- Plate Armor
	{ id = 3028, chance = 17648 }, -- Small Diamond
	{ id = 3370, chance = 17650 }, -- Knight Armor
	{ id = 9185, chance = 20004 }, -- Very Old Piece of Paper
	{ id = 239, chance = 11768 }, -- Great Health Potion
	{ id = 5926, chance = 5880 }, -- Pirate Backpack
	{ id = 3267, chance = 7140 }, -- Dagger
	{ id = 3084, chance = 7140 }, -- Protection Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -175 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -175, range = 7, shootEffect = CONST_ANI_THROWINGSTAR, target = false },
	{ name = "drunk", interval = 2000, chance = 10, length = 3, spread = 2, effect = CONST_ME_POFF, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 50,
	armor = 35,
	mitigation = 1.20,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -1 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
