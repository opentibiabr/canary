local mType = Game.createMonsterType("Lethal Lissy")
local monster = {}

monster.description = "Lethal Lissy"
monster.experience = 500
monster.outfit = {
	lookType = 155,
	lookHead = 77,
	lookBody = 0,
	lookLegs = 76,
	lookFeet = 115,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 1450
monster.maxHealth = 1450
monster.race = "blood"
monster.corpse = 18157
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
	canPushCreatures = false,
	staticAttackChance = 50,
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

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Pirate Cutthroat", chance = 50, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 121 }, -- Gold Coin
	{ id = 6100, chance = 100000 }, -- The Lethal Lissy's Shirt
	{ id = 3114, chance = 83335, maxCount = 2 }, -- Skull (Item)
	{ id = 3357, chance = 56526 }, -- Plate Armor
	{ id = 3370, chance = 13640 }, -- Knight Armor
	{ id = 3577, chance = 27269, maxCount = 3 }, -- Meat
	{ id = 3028, chance = 9090 }, -- Small Diamond
	{ id = 5926, chance = 8700 }, -- Pirate Backpack
	{ id = 9185, chance = 18180 }, -- Very Old Piece of Paper
	{ id = 3275, chance = 100000 }, -- Double Axe
	{ id = 3084, chance = 1000 }, -- Protection Amulet
	{ id = 239, chance = 9090 }, -- Great Health Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
}

monster.defenses = {
	defense = 50,
	armor = 35,
	mitigation = 1.20,
	{ name = "combat", interval = 6000, chance = 65, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
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
