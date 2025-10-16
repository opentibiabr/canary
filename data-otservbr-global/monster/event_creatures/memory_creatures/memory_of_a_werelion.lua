local mType = Game.createMonsterType("Memory of a Werelion")
local monster = {}

monster.description = "a memory of a werelion"
monster.experience = 1800
monster.outfit = {
	lookType = 1301,
	lookHead = 58,
	lookBody = 2,
	lookLegs = 94,
	lookFeet = 0,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 3880
monster.maxHealth = 3880
monster.race = "blood"
monster.corpse = 33825
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	runHealth = 5,
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
	{ id = 25737, chance = 80000, maxCount = 3 }, -- rainbow quartz
	{ id = 3577, chance = 80000 }, -- meat
	{ id = 24391, chance = 80000 }, -- coral brooch
	{ id = 37468, chance = 80000 }, -- special fx box
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 22193, chance = 80000 }, -- onyx chip
	{ id = 676, chance = 80000, maxCount = 5 }, -- small enchanted ruby
	{ id = 7642, chance = 80000, maxCount = 2 }, -- great spirit potion
	{ id = 3017, chance = 80000 }, -- silver brooch
	{ id = 3028, chance = 80000 }, -- small diamond
	{ id = 37530, chance = 80000 }, -- bottle of champagne
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "werelion wave", interval = 2000, chance = 20, minDamage = -50, maxDamage = -150, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -50, maxDamage = -150, range = 3, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -50, maxDamage = -100, range = 3, shootEffect = CONST_ANI_HOLY, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 1.40,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
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
