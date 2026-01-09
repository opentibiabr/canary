local mType = Game.createMonsterType("Ron the Ripper")
local monster = {}

monster.description = "Ron the Ripper"
monster.experience = 500
monster.outfit = {
	lookType = 151,
	lookHead = 95,
	lookBody = 94,
	lookLegs = 117,
	lookFeet = 59,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 18221
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
	staticAttackChance = 50,
	targetDistance = 1,
	runHealth = 250,
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
	{ text = "Muahaha!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 77 }, -- Gold Coin
	{ id = 3114, chance = 84210, maxCount = 2 }, -- Skull (Item)
	{ id = 239, chance = 23810 }, -- Great Health Potion
	{ id = 3577, chance = 19048 }, -- Meat
	{ id = 3267, chance = 47370 }, -- Dagger
	{ id = 3357, chance = 52379 }, -- Plate Armor
	{ id = 3370, chance = 16669 }, -- Knight Armor
	{ id = 3275, chance = 1000 }, -- Double Axe
	{ id = 3028, chance = 13639 }, -- Small Diamond
	{ id = 9185, chance = 26320 }, -- Very Old Piece of Paper
	{ id = 5926, chance = 10530 }, -- Pirate Backpack
	{ id = 6101, chance = 100000 }, -- Ron the Ripper's Sabre
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{ name = "combat", interval = 4000, chance = 60, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -160, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 35,
	mitigation = 1.20,
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
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
