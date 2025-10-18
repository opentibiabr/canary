local mType = Game.createMonsterType("Dreadbeast")
local monster = {}

monster.description = "a dreadbeast"
monster.experience = 250
monster.outfit = {
	lookType = 101,
	lookHead = 20,
	lookBody = 30,
	lookLegs = 40,
	lookFeet = 50,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 800
monster.maxHealth = 800
monster.race = "undead"
monster.corpse = 4212
monster.speed = 68
monster.manaCost = 800

monster.changeTarget = {
	interval = 60000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 70443, maxCount = 88 }, -- Gold Coin
	{ id = 3115, chance = 7259 }, -- Bone
	{ id = 3357, chance = 1531 }, -- Plate Armor
	{ id = 3114, chance = 1319 }, -- Skull (Item)
	{ id = 3116, chance = 1315 }, -- Big Bone
	{ id = 3337, chance = 928 }, -- Bone Club
	{ id = 3441, chance = 535 }, -- Bone Shield
	{ id = 3732, chance = 499 }, -- Green Mushroom
	{ id = 5925, chance = 393 }, -- Hardened Bone
	{ id = 266, chance = 376 }, -- Health Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "dreadbeast skill reducer", interval = 3000, chance = 15, range = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_YELLOWENERGY, target = true },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -70, maxDamage = -90, range = 1, shootEffect = CONST_ANI_ICE, effect = CONST_ME_LOSEENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -250, radius = 1, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_PURPLEENERGY, target = true },
}

monster.defenses = {
	defense = 36,
	armor = 34,
	--	mitigation = ???,
	{ name = "combat", interval = 5000, chance = 20, type = COMBAT_HEALING, minDamage = 35, maxDamage = 65, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 55 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 75 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = -50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
