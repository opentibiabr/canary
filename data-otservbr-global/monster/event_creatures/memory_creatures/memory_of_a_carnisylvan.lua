local mType = Game.createMonsterType("Memory of a Carnisylvan")
local monster = {}

monster.description = "a memory of a carnisylvan"
monster.experience = 1850
monster.outfit = {
	lookType = 1418,
	lookHead = 23,
	lookBody = 98,
	lookLegs = 22,
	lookFeet = 61,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 3800
monster.maxHealth = 3800
monster.race = "blood"
monster.corpse = 36890
monster.speed = 52
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	targetDistance = 4,
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
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 16103, chance = 80000 }, -- mushroom pie
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 3731, chance = 80000, maxCount = 3 }, -- fire mushroom
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 34249, chance = 80000 }, -- wooden trash
	{ id = 24392, chance = 80000 }, -- gemmed figurine
	{ id = 37530, chance = 80000 }, -- bottle of champagne
	{ id = 3010, chance = 80000 }, -- emerald bangle
	{ id = 37468, chance = 80000 }, -- special fx box
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -100, radius = 4, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = 0, maxDamage = -100, range = 5, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POISONAREA, target = true },
}

monster.defenses = {
	defense = 37,
	armor = 37,
	mitigation = 1.30,
	{ name = "speed", interval = 2000, chance = 8, speedChange = 250, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000 },
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
