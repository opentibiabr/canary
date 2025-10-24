local mType = Game.createMonsterType("Mountain Troll")
local monster = {}

monster.description = "a mountain troll"
monster.experience = 12
monster.outfit = {
	lookType = 15,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MorrisTrollDeath",
}

monster.health = 30
monster.maxHealth = 30
monster.race = "blood"
monster.corpse = 5960
monster.speed = 55
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
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
	{ id = 3031, chance = 100000, maxCount = 8 }, -- Gold Coin
	{ id = 3577, chance = 28380, maxCount = 2 }, -- Meat
	{ id = 3003, chance = 7818 }, -- Rope
	{ id = 3277, chance = 5689 }, -- Spear
	{ id = 21352, chance = 1980 }, -- Lightest Missile Rune
	{ id = 3361, chance = 4399 }, -- Leather Armor
	{ id = 3268, chance = 3078 }, -- Hand Axe
	{ id = 3336, chance = 3096 }, -- Studded Club
	{ id = 3272, chance = 3058 }, -- Rapier
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 10, attack = 9 },
}

monster.defenses = {
	defense = 2,
	armor = 0,
	mitigation = 0.10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
