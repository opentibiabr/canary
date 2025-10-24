local mType = Game.createMonsterType("Kerberos")
local monster = {}

monster.description = "Kerberos"
monster.experience = 10000
monster.outfit = {
	lookType = 240,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 11000
monster.maxHealth = 11000
monster.race = "blood"
monster.corpse = 6331
monster.speed = 140
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 206,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 18 }, -- Platinum Coin
	{ id = 3027, chance = 82078, maxCount = 5 }, -- Black Pearl
	{ id = 9637, chance = 100000 }, -- Hellhound Slobber
	{ id = 6558, chance = 90569 }, -- Flask of Demonic Blood
	{ id = 238, chance = 81130, maxCount = 3 }, -- Great Mana Potion
	{ id = 9058, chance = 82073, maxCount = 5 }, -- Gold Ingot
	{ id = 817, chance = 97620 }, -- Magma Amulet
	{ id = 6499, chance = 57548, maxCount = 3 }, -- Demonic Essence
	{ id = 3038, chance = 33961 }, -- Green Gem
	{ id = 3280, chance = 24527 }, -- Fire Sword
	{ id = 3318, chance = 56607 }, -- Knight Axe
	{ id = 3360, chance = 28304 }, -- Golden Armor
	{ id = 4871, chance = 33963 }, -- Explorer Brooch
	{ id = 6553, chance = 5660 }, -- Ruthless Axe
	{ id = 7453, chance = 2380 }, -- Executioner
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -508 },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -700, length = 8, spread = 3, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -498, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -662, length = 8, spread = 3, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -976, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -549, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 2.95,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
