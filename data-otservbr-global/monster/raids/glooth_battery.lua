local mType = Game.createMonsterType("Glooth Battery")
local monster = {}

monster.description = "a glooth battery"
monster.experience = 3000
monster.outfit = {
	lookTypeEx = 20710,
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "blood"
monster.corpse = 21940
monster.speed = 0
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
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ id = 3035, chance = 76670, maxCount = 5 }, -- Platinum Coin
	{ id = 239, chance = 12219 }, -- Great Health Potion
	{ id = 238, chance = 10000 }, -- Great Mana Potion
	{ id = 21169, chance = 2220 }, -- Metal Spats
	{ id = 21170, chance = 5560 }, -- Gearwheel Chain
	{ id = 9016, chance = 7220 }, -- Flask of Rust Remover
	{ id = 8775, chance = 4440 }, -- Gear Wheel
	{ id = 5880, chance = 2780 }, -- Iron Ore
	{ id = 7440, chance = 560 }, -- Mastermind Potion
	{ id = 3554, chance = 1110 }, -- Steel Boots
	{ id = 21167, chance = 1669 }, -- Heat Core
	{ id = 21168, chance = 560 }, -- Alloy Legs
	{ id = 9654, chance = 1669 }, -- War Crystal
	{ id = 9063, chance = 560 }, -- Crystal Pedestal (Red)
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -206, maxDamage = -252, radius = 6, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 133, maxDamage = 454, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 1 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
