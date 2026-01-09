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
	{ id = 5792, chance = 1150 }, -- Die
	{ id = 6095, chance = 2310 }, -- Pirate Shirt
	{ id = 3030, chance = 13499 }, -- Small Ruby
	{ id = 236, chance = 7968 }, -- Strong Health Potion
	{ id = 3123, chance = 11709 }, -- Worn Leather Boots
	{ id = 3298, chance = 9426 }, -- Throwing Knife
	{ id = 5926, chance = 1303 }, -- Pirate Backpack
	{ id = 2920, chance = 6832 }, -- Torch
	{ id = 37530, chance = 1350 }, -- Bottle of Champagne
	{ id = 37468, chance = 380 }, -- Special Fx Box
	{ id = 3032, chance = 9431 }, -- Small Emerald
	{ id = 3031, chance = 42278 }, -- Gold Coin
	{ id = 3357, chance = 3743 }, -- Plate Armor
	{ id = 3273, chance = 8944 }, -- Sabre
	{ id = 3413, chance = 7970 }, -- Battle Shield
	{ id = 5552, chance = 1134 }, -- Rum Flask
	{ id = 5090, chance = 580 }, -- Treasure Map
	{ id = 37531, chance = 3850 }, -- Candy Floss (Large)
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
