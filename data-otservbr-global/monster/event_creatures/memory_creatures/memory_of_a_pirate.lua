local mType = Game.createMonsterType("Memory of a Pirate")
local monster = {}

monster.description = "a memory of a pirate"
monster.experience = 1500
monster.outfit = {
	lookType = 97,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3750
monster.maxHealth = 3750
monster.race = "blood"
monster.corpse = 18190
monster.speed = 109
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	targetDistance = 1,
	runHealth = 50,
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
	{ id = 6095, chance = 80000 }, -- pirate shirt
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 236, chance = 80000 }, -- strong health potion
	{ id = 3123, chance = 80000 }, -- worn leather boots
	{ id = 3298, chance = 80000 }, -- throwing knife
	{ id = 5926, chance = 80000 }, -- pirate backpack
	{ id = 11050, chance = 80000 }, -- torch
	{ id = 37530, chance = 80000 }, -- bottle of champagne
	{ id = 37468, chance = 80000 }, -- special fx box
	{ id = 3032, chance = 80000 }, -- small emerald
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 3357, chance = 80000 }, -- plate armor
	{ id = 3273, chance = 80000 }, -- sabre
	{ id = 3413, chance = 80000 }, -- battle shield
	{ id = 5552, chance = 80000 }, -- rum flask
	{ id = 31946, chance = 80000 }, -- treasure map
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -160 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 4, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 1.30,
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
