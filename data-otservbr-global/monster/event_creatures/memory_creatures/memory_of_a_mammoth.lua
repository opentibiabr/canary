local mType = Game.createMonsterType("Memory of a Mammoth")
local monster = {}

monster.description = "a memory of a mammoth"
monster.experience = 1830
monster.outfit = {
	lookType = 199,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3850
monster.maxHealth = 3850
monster.race = "blood"
monster.corpse = 6074
monster.speed = 95
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
	{ id = 7381, chance = 7904 }, -- Mammoth Whopper
	{ id = 37531, chance = 6200 }, -- Candy Floss (Large)
	{ id = 7432, chance = 10305 }, -- Furry Club
	{ id = 3577, chance = 51203 }, -- Meat
	{ id = 3031, chance = 88658 }, -- Gold Coin
	{ id = 3582, chance = 39178 }, -- Ham
	{ id = 3443, chance = 7217 }, -- Tusk Shield
	{ id = 9057, chance = 12372 }, -- Small Topaz
	{ id = 37530, chance = 1460 }, -- Bottle of Champagne
	{ id = 37468, chance = 730 }, -- Special Fx Box
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 1.60,
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
