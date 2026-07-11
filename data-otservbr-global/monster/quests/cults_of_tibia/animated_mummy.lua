local mType = Game.createMonsterType("Animated Mummy")
local monster = {}

monster.description = "an animated mummy"
monster.experience = 150
monster.outfit = {
	lookType = 65,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 240
monster.maxHealth = 240
monster.race = "undead"
monster.corpse = 6004
monster.speed = 75
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
	{ id = 3031, chance = 34000, maxCount = 77 }, -- Gold Coin
	{ id = 3492, chance = 21000, maxCount = 3 }, -- Worm
	{ id = 11466, chance = 11900 }, -- Flask of Embalming Fluid
	{ id = 3046, chance = 8800 }, -- Magic Light Wand
	{ id = 9649, chance = 5000 }, -- Gauze Bandage
	{ id = 3017, chance = 4400 }, -- Silver Brooch
	{ id = 3045, chance = 4400 }, -- Strange Talisman
	{ id = 5914, chance = 1200 }, -- Yellow Piece of Cloth
	{ id = 3027, chance = 1200 }, -- Black Pearl
	{ id = 3007, chance = 620 }, -- Crystal Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -85, condition = { type = CONDITION_POISON, totalDamage = 4, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -40, range = 1, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -226, range = 7, effect = CONST_ME_MAGIC_RED, target = true, duration = 10000 },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	--	mitigation = ???,
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
