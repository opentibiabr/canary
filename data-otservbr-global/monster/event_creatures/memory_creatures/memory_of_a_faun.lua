local mType = Game.createMonsterType("Memory of a Faun")
local monster = {}

monster.description = "a memory of a faun"
monster.experience = 1600
monster.outfit = {
	lookType = 980,
	lookHead = 81,
	lookBody = 115,
	lookLegs = 114,
	lookFeet = 81,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 25815
monster.speed = 105
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 20,
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
	{ id = 24383, chance = 7182 }, -- Cave Turnip
	{ id = 2953, chance = 5932 }, -- Panpipes
	{ id = 675, chance = 10818 }, -- Small Enchanted Sapphire
	{ id = 236, chance = 18728 }, -- Strong Health Potion
	{ id = 239, chance = 9885 }, -- Great Health Potion
	{ id = 1781, chance = 4056 }, -- Small Stone
	{ id = 37468, chance = 1144 }, -- Special Fx Box
	{ id = 37530, chance = 834 }, -- Bottle of Champagne
	{ id = 3031, chance = 100000 }, -- Gold Coin
	{ id = 3728, chance = 12591 }, -- Dark Mushroom
	{ id = 24962, chance = 12383 }, -- Prismatic Quartz
	{ id = 3674, chance = 9259 }, -- Goat Grass
	{ id = 37531, chance = 4058 }, -- Candy Floss (Large)
	{ id = 5014, chance = 314 }, -- Mandrake
	{ id = 5792, chance = 419 }, -- Die
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -50, maxDamage = -115, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "drunk", interval = 2000, chance = 11, length = 4, spread = 2, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 25000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, shootEffect = CONST_ANI_LEAFSTAR, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 1.30,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 75, maxDamage = 90, effect = CONST_ME_MAGIC_BLUE, target = false },
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
